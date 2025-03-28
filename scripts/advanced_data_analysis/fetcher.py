import os
import pandas as pd
import numpy as np
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
import pyodbc
import time
import signal
import threading


class TimeoutError(Exception):
    pass


def timeout_handler(signum, frame):
    raise TimeoutError("Database connection timed out")


class DataFetcher:
    """
    Utility class to fetch data from either a database or CSV files.
    """

    def __init__(self, source="db", csv_base_path=None, timeout=5):
        """
        Initialize the DataFetcher with a specified data source.

        Args:
            source (str): 'db' to fetch from database or 'csv' to fetch from CSV files
            csv_base_path (str): Base path for CSV files if source is 'csv'
            timeout (int): Timeout in seconds for database connection attempt
        """
        self.source = source
        self.timeout = timeout
        self.db_connection_tested = False

        # Default CSV path if not provided
        if csv_base_path is None:
            self.csv_base_path = Path(
                "/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump"
            )
        else:
            self.csv_base_path = Path(csv_base_path)

        # Database connection details
        if self.source == "db":
            # Load environment variables from .env file
            load_dotenv()

            # Get database connection parameters from environment variables
            self.server = os.getenv("SQL_SERVER")
            self.database = os.getenv("SQL_DATABASE", "KPMG_Data_Challenge")
            self.username = os.getenv("SQL_USERNAME")
            self.password = os.getenv("SQL_PASSWORD")
            self.driver = os.getenv("SQL_DRIVER", "ODBC Driver 17 for SQL Server")

            # Create connection string
            self.conn_str = f"DRIVER={{{self.driver}}};SERVER={self.server};DATABASE={self.database};UID={self.username};PWD={self.password}"

            # Create SQLAlchemy engine
            try:
                self.engine = create_engine(
                    f"mssql+pyodbc:///?odbc_connect={self.conn_str}"
                )
                print(
                    "Database connection initialized. Will test actual connection when fetching data."
                )
            except Exception as e:
                print(f"Error initializing database connection: {e}")
                print("Will fall back to CSV files when fetching data.")
                self.source = "csv"

    def _test_db_connection(self):
        """
        Test database connection with timeout.

        Returns:
            bool: True if connection successful, False otherwise
        """
        if not self.source == "db":
            return False

        if self.db_connection_tested:
            return True

        print(f"Testing database connection with {self.timeout}s timeout...")

        # Define a function to test the connection
        def test_connection():
            try:
                with self.engine.connect() as conn:
                    conn.execute(text("SELECT 1"))
                return True
            except Exception as e:
                print(f"Database connection test failed: {e}")
                return False

        # Use threading with a timeout
        connection_thread = threading.Thread(
            target=lambda: setattr(self, "_connection_result", test_connection())
        )
        connection_thread.daemon = True

        start_time = time.time()
        connection_thread.start()
        connection_thread.join(timeout=self.timeout)

        # Check if the thread completed within the timeout
        if connection_thread.is_alive():
            print(f"Database connection timed out after {self.timeout} seconds")
            self.source = "csv"
            return False

        elapsed = time.time() - start_time

        # Get the result from the thread
        if getattr(self, "_connection_result", False):
            print(f"Database connection successful in {elapsed:.2f} seconds")
            self.db_connection_tested = True
            return True
        else:
            print("Database connection failed, falling back to CSV")
            self.source = "csv"
            return False

    def fetch_data(self, tables=None):
        """
        Fetch data from specified tables.

        Args:
            tables (list): List of table names to fetch. If None, fetches all tables.
                          Can include special joined tables like 'timesheets_employees'

        Returns:
            dict: Dictionary of table_name -> DataFrame
        """
        # Test database connection with timeout if using DB
        if self.source == "db":
            self._test_db_connection()

        # Default tables to fetch if none specified
        if tables is None:
            tables = [
                "timesheets",
                "employees",
                "clients",
                "engagements",
                "phases",
                "practices",
            ]

        # Handle case of single table name as string
        if isinstance(tables, str):
            tables = [tables]

        results = {}

        # Process each requested table
        for table in tables:
            # Check for special joined tables
            if table == "timesheets_employees":
                results[table] = self.fetch_timesheets_and_employees()
            elif table == "employee_timesheet_data":
                results[table] = self.fetch_employee_timesheet_data()
            elif table == "timesheet_data":
                results[table] = self.fetch_timesheet_data()
            else:
                # Standard table fetch
                results[table] = self.fetch_table(table)

        return results

    def fetch_table(self, table_name):
        """
        Fetch a single table by name.

        Args:
            table_name (str): Name of the table to fetch

        Returns:
            pandas.DataFrame: Data from the requested table
        """
        if self.source == "db":
            try:
                # Construct a simple SELECT query
                query = f"SELECT * FROM {table_name}"

                # Read data from database into pandas DataFrame
                df = pd.read_sql(query, self.engine)
                print(
                    f"Successfully loaded {len(df)} records from {table_name} table in database."
                )
                return df

            except Exception as e:
                print(f"Error fetching {table_name} from database: {e}")
                print("Falling back to CSV file...")
                self.source = "csv"

        # Fallback to CSV if database connection fails or source is set to 'csv'
        if self.source == "csv":
            try:
                # Try the transformed directory first
                csv_path = self.csv_base_path / "transformed" / f"{table_name}.csv"

                # If transformed file doesn't exist, try the raw file with naming convention
                if not os.path.exists(csv_path):
                    raw_file_map = {
                        "timesheets": "KPMG Case Data_TIME.csv",
                        "employees": "KPMG Case Data_Staffing___2024.csv",  # May need to merge with 2025
                        "clients": "KPMG Case Data_Staffing___2024.csv",  # Extracted from staffing data
                        "engagements": "KPMG Case Data_Budget.csv",
                        "phases": "KPMG Case Data_Budget.csv",
                        "staffing": "KPMG Case Data_Staffing___2024.csv",
                        "practices": None,  # Might be internal only
                        "dictionary": "KPMG Case Data_Dictionnaire___Dictionary_.csv",
                    }

                    if table_name in raw_file_map and raw_file_map[table_name]:
                        csv_path = self.csv_base_path / raw_file_map[table_name]
                    else:
                        raise FileNotFoundError(f"No CSV file mapping for {table_name}")

                # Try different encodings
                for encoding in ["utf-8-sig", "latin1", "cp1252"]:
                    try:
                        df = pd.read_csv(csv_path, encoding=encoding)
                        print(
                            f"Successfully loaded {len(df)} records from {table_name} CSV using {encoding} encoding."
                        )

                        # For raw files, we may need to select/transform columns to match table schema
                        if "transformed" not in str(csv_path):
                            df = self._transform_raw_csv_to_table(df, table_name)

                        break
                    except Exception as e:
                        if encoding == "cp1252":  # Last encoding to try
                            print(
                                f"Error loading {table_name} with encoding {encoding}: {e}"
                            )
                        continue

                return df

            except Exception as e:
                print(f"Error loading {table_name} CSV data: {e}")
                return pd.DataFrame()  # Return empty DataFrame if all methods fail

    def _transform_raw_csv_to_table(self, df, table_name):
        """
        Transform raw CSV data to match table schemas when loading from raw CSVs.

        Args:
            df (DataFrame): Raw dataframe from CSV
            table_name (str): Target table name

        Returns:
            DataFrame: Transformed dataframe matching table schema
        """
        if table_name == "timesheets":
            # Example mapping from TIME.csv to timesheets table
            column_mapping = {
                "Personnel No.": "personnel_no",
                "Work Date": "work_date",
                "Hours": "hours",
                "Eng. No.": "eng_no",
                "Eng. Phase": "eng_phase",
                "Time Entry Date": "time_entry_date",
                "Posting Date": "posting_date",
                "Charge-Out Rate": "charge_out_rate",
                "Std. Price": "std_price",
                "Adm. Surcharge": "adm_surcharge",
            }
            df = df.rename(
                columns={k: v for k, v in column_mapping.items() if k in df.columns}
            )

        elif table_name == "employees":
            # Example mapping from Staffing CSV to employees table
            if "Personnel No." in df.columns and "Employee Name" in df.columns:
                df = df[
                    ["Personnel No.", "Employee Name", "Staff Level"]
                ].drop_duplicates()
                df = df.rename(
                    columns={
                        "Personnel No.": "personnel_no",
                        "Employee Name": "employee_name",
                        "Staff Level": "staff_level",
                    }
                )
                # Add default values for missing columns
                if "is_external" not in df.columns:
                    df["is_external"] = False
                if "employment_basis" not in df.columns:
                    df["employment_basis"] = 40.0
                if "practice_id" not in df.columns:
                    df["practice_id"] = 1  # Default to SAP practice

        elif table_name == "clients":
            # Extract client info from staffing data
            if "Client No." in df.columns and "Client Name" in df.columns:
                df = df[["Client No.", "Client Name"]].drop_duplicates()
                df = df.rename(
                    columns={"Client No.": "client_no", "Client Name": "client_name"}
                )
                df = df.dropna(subset=["client_no", "client_name"])

        # Add more transformations for other tables as needed
        elif table_name == 'phases':
           column_mapping = {
           "Eng. No.": "eng_no",
           "Eng. Phase": "eng_phase",
           "Budget": "budget"
           }
           df = df.rename(columns={k: v for k, v in column_mapping.items() if k in df.columns})
           
        elif table_name == 'staffing':
           column_mapping = {
           "Eng. No.": "eng_no",
           "Eng. Phase": "eng_phase",
           "Personnel No.": "personnel_no"
           }
           df = df.rename(columns={k: v for k, v in column_mapping.items() if k in df.columns})
           
        # Add more transformations for other tables as needed

        return df

    # Backward compatibility methods below
    def fetch_timesheets_and_employees(self):
        """
        Fetch timesheet and employee data either from database or CSV files.

        Returns:
            pandas.DataFrame: Timesheet data joined with employee names
        """
        if self.source == "db":
            try:
                # SQL query to get the required data from timesheets and employees tables
                query = """
                SELECT 
                    t.work_date AS 'Work Date',
                    t.time_entry_date AS 'Time Entry Date',
                    t.hours AS 'Hours',
                    t.charge_out_rate AS 'Charge-Out Rate',
                    t.std_price AS 'Std. Price',
                    t.adm_surcharge AS 'Adm. Surcharge',
                    e.employee_name AS 'Employee Name',
                    t.personnel_no
                FROM 
                    timesheets t
                JOIN 
                    employees e ON t.personnel_no = e.personnel_no
                """

                # Read data from database into pandas DataFrame
                df_time = pd.read_sql(query, self.engine)
                print(f"Successfully loaded {len(df_time)} records from database.")
                return df_time

            except Exception as e:
                print(f"Error fetching from database: {e}")
                print("Falling back to CSV file...")
                self.source = "csv"

        # Fallback to CSV if database connection fails or source is set to 'csv'
        if self.source == "csv":
            try:
                # Path to the timesheet CSV file
                csv_path = self.csv_base_path / "KPMG Case Data_TIME.csv"

                # Try different encodings
                for encoding in ["utf-8-sig", "latin1", "cp1252"]:
                    try:
                        df_time = pd.read_csv(csv_path, encoding=encoding)
                        print(
                            f"Successfully loaded {len(df_time)} records from CSV file using {encoding} encoding."
                        )
                        break
                    except:
                        continue

                # Try to load employees data if needed
                try:
                    # We might need to join employee names or handle this differently
                    # depending on the CSV structure
                    df_time["Employee Name"] = df_time["Personnel No."]  # Placeholder
                except:
                    print("Note: Could not add employee names from CSV data")

                return df_time

            except Exception as e:
                print(f"Error loading CSV data: {e}")
                return pd.DataFrame()  # Return empty DataFrame if all methods fail

    def fetch_timesheet_data(self):
        """
        Fetch timesheet data for project allocation analysis.

        Returns:
            pandas.DataFrame: Timesheet data with project information
        """
        if self.source == "db":
            try:
                # SQL query to get the required data from database
                query = """
                SELECT 
                    t.eng_no AS 'Eng. No.',
                    t.eng_phase AS 'Eng. Phase',
                    t.work_date AS 'Posting Date',
                    t.time_entry_date AS 'Time Entry Date',
                    t.work_date AS 'Work Date',
                    t.hours AS 'Hours',
                    t.std_price AS 'Std. Price',
                    t.adm_surcharge AS 'Adm. Surcharge',
                    t.personnel_no
                FROM 
                    timesheets t
                """

                # Read data from database into pandas DataFrame
                df_time = pd.read_sql(query, self.engine)
                print(f"Successfully loaded {len(df_time)} records from database.")
                return df_time

            except Exception as e:
                print(f"Error fetching from database: {e}")
                print("Falling back to CSV file...")
                self.source = "csv"

        # Fallback to CSV if database connection fails or source is set to 'csv'
        if self.source == "csv":
            try:
                # Path to the timesheet CSV file
                csv_path = self.csv_base_path / "KPMG Case Data_TIME.csv"

                # Try different encodings
                for encoding in ["utf-8-sig", "latin1", "cp1252"]:
                    try:
                        df_time = pd.read_csv(csv_path, encoding=encoding)
                        print(
                            f"Successfully loaded {len(df_time)} records from CSV file using {encoding} encoding."
                        )
                        break
                    except:
                        continue

                return df_time

            except Exception as e:
                print(f"Error loading CSV data: {e}")
                return pd.DataFrame()  # Return empty DataFrame if all methods fail

    def fetch_employee_timesheet_data(self):
        """
        Fetch timesheet data for time entry analysis.

        Returns:
            pandas.DataFrame: Timesheet data for time entry analysis
        """
        if self.source == "db":
            try:
                # SQL query to get the required data
                query = """
                SELECT 
                    personnel_no,
                    work_date,
                    time_entry_date
                FROM 
                    timesheets
                """

                # Read data from database into pandas DataFrame
                df = pd.read_sql(query, self.engine)
                print(f"Successfully loaded {len(df)} records from database.")
                return df

            except Exception as e:
                print(f"Error fetching from database: {e}")
                print("Falling back to CSV file...")
                self.source = "csv"

        # Fallback to CSV if database connection fails or source is set to 'csv'
        if self.source == "csv":
            try:
                # Path to the transformed CSV file
                csv_path = self.csv_base_path / "transformed" / "timesheets.csv"

                # If transformed file doesn't exist, try the raw file
                if not os.path.exists(csv_path):
                    csv_path = self.csv_base_path / "KPMG Case Data_TIME.csv"
                    df = pd.read_csv(csv_path, encoding="latin-1")
                    # Rename columns to match the expected format
                    df = df.rename(
                        columns={
                            "Personnel No.": "personnel_no",
                            "Work Date": "work_date",
                            "Time Entry Date": "time_entry_date",
                        }
                    )
                else:
                    df = pd.read_csv(csv_path)

                print(f"Successfully loaded {len(df)} records from CSV file.")
                return df

            except Exception as e:
                print(f"Error loading CSV data: {e}")
                return pd.DataFrame()  # Return empty DataFrame if all methods fail
