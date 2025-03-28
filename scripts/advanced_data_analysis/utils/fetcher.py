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
import logging
import sys

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("fetcher")

# Get the absolute path to the current script's directory
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
# Calculate project root using relative path (3 levels up from utils)
project_root = current_dir.parent.parent.parent

# Add the shared directory to the Python path
shared_dir = project_root / "scripts" / "shared"
sys.path.append(str(shared_dir))

# Import from shared modules
from config import CSV_DUMP_DIR, TRANSFORMED_DIR, RAW_FILE_MAP, COLUMN_MAPPINGS
from db_utils import test_db_connection, create_sqlalchemy_engine

# Load environment variables from .env file in root directory
load_dotenv(project_root / '.env')

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

        # Default CSV path relative to project root if not provided
        if csv_base_path is None:
            self.csv_base_path = project_root / "csv-dump"
        else:
            self.csv_base_path = Path(csv_base_path)

        logger.info(f"CSV base path set to: {self.csv_base_path}")

        # Database connection details
        if self.source == "db":
            # Get database connection details from environment variables
            self.server = os.getenv("SQL_SERVER")
            self.database = os.getenv("SQL_DATABASE", "KPMG_Data_Challenge")
            self.username = os.getenv("SQL_USERNAME")
            self.password = os.getenv("SQL_PASSWORD")
            self.driver = os.getenv("SQL_DRIVER", "{ODBC Driver 17 for SQL Server}")

            # Check if all required environment variables are set
            if not all([self.server, self.database, self.username, self.password, self.driver]):
                logger.error("Database connection details missing in .env file")
                logger.info("Falling back to CSV files")
                self.source = "csv"
            else:
                # Create connection string (same format as in pipeline.py)
                self.conn_str = f"DRIVER={self.driver};SERVER={self.server};DATABASE={self.database};UID={self.username};PWD={self.password}"
                
                # Create SQLAlchemy engine
                try:
                    self.engine = create_engine(f"mssql+pyodbc:///?odbc_connect={self.conn_str}")
                    logger.info("Database connection initialized. Will test actual connection when fetching data.")
                except Exception as e:
                    logger.error(f"Error initializing database connection: {e}")
                    logger.info("Falling back to CSV files")
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

        logger.info(f"Testing database connection with {self.timeout}s timeout...")

        # Define a function to test the connection
        def test_connection():
            try:
                # Use pyodbc directly as in pipeline.py
                conn = pyodbc.connect(self.conn_str, timeout=self.timeout)
                cursor = conn.cursor()
                cursor.execute("SELECT 1")
                cursor.close()
                conn.close()
                return True
            except Exception as e:
                logger.error(f"Database connection test failed: {e}")
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
            logger.error(f"Database connection timed out after {self.timeout} seconds")
            self.source = "csv"
            return False

        elapsed = time.time() - start_time

        # Get the result from the thread
        if getattr(self, "_connection_result", False):
            logger.info(f"Database connection successful in {elapsed:.2f} seconds")
            self.db_connection_tested = True
            return True
        else:
            logger.error("Database connection failed, falling back to CSV")
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

        # Default tables to fetch if none specified - include all tables from data_transformation.py
        if tables is None:
            tables = [
                "practices",
                "employees",
                "clients",
                "engagements",
                "phases",
                "staffing",
                "timesheets",
                "dictionary",
                "vacations",
                "charge_out_rates",
                "optimization_parameters"
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
        if self.source == "db" and self._test_db_connection():
            try:
                # Construct a simple SELECT query
                query = f"SELECT * FROM {table_name}"

                # Read data from database into pandas DataFrame
                df = pd.read_sql(query, self.engine)
                logger.info(f"Successfully loaded {len(df)} records from {table_name} table in database.")
                return df

            except Exception as e:
                logger.error(f"Error fetching {table_name} from database: {e}")
                logger.info("Falling back to CSV file...")
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
                        "budget": "KPMG Case Data_Budget.csv",
                        "staffing": "KPMG Case Data_Staffing___2024.csv",
                        "practices": None,  # Might be internal only
                        "dictionary": "KPMG Case Data_Dictionnaire___Dictionary_.csv",
                        "vacations": None,  # Generated internally, no raw file
                        "charge_out_rates": None,  # Generated internally from timesheets
                        "optimization_parameters": None,  # Generated internally, no raw file
                    }

                    if table_name in raw_file_map and raw_file_map[table_name]:
                        csv_path = self.csv_base_path / raw_file_map[table_name]
                    else:
                        raise FileNotFoundError(f"No CSV file mapping for {table_name}")

                # Check if file exists
                if not os.path.exists(csv_path):
                    logger.error(f"CSV file not found: {csv_path}")
                    return pd.DataFrame()

                # Try different encodings
                for encoding in ["utf-8-sig", "latin1", "cp1252"]:
                    try:
                        df = pd.read_csv(csv_path, encoding=encoding)
                        logger.info(f"Successfully loaded {len(df)} records from {table_name} CSV using {encoding} encoding.")

                        # For raw files, we may need to select/transform columns to match table schema
                        if "transformed" not in str(csv_path):
                            df = self._transform_raw_csv_to_table(df, table_name)

                        break
                    except Exception as e:
                        if encoding == "cp1252":  # Last encoding to try
                            logger.error(f"Error loading {table_name} with encoding {encoding}: {e}")
                        continue

                return df

            except Exception as e:
                logger.error(f"Error loading {table_name} CSV data: {e}")
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
           
        elif table_name == "budget":
            if all(col in df.columns for col in ["Code projet", "Code phase", "Budget"]):
                df = df[["Code projet", "Code phase", "Budget"]].dropna()
                df = df.rename(columns={
                    "Code projet": "eng_no",
                    "Code phase": "eng_phase",
                    "Budget": "budget"
                })

                # Clean up numeric budget values if needed
                df["budget"] = (
                    df["budget"]
                    .astype(str)
                    .str.replace(r"[^\d]", "", regex=True)  # Remove commas, spaces
                    .astype(float)
                )

        elif table_name == 'phases':
            column_mapping = {
                "Code projet": "eng_no",
                "Code phase": "eng_phase",
                "Phase Projet": "phase_description",
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
            
            # Process staffing with date columns similar to data_transformation.py
            if 'week_start_date' not in df.columns:
                date_columns = [col for col in df.columns if col not in [
                    'Eng. No.', 'Eng. Description', 'Eng. Phase', 'Phase Description',
                    'Client No.', 'Client Name', 'Personnel No.', 'Employee Name', 'Staff Level'
                ]]
                
                # Reshape to long format with each row containing a week date
                if date_columns:
                    long_df = []
                    for _, row in df.iterrows():
                        for date_col in date_columns:
                            hours = row[date_col]
                            if pd.notna(hours) and hours > 0:
                                try:
                                    week_date = pd.to_datetime(date_col)
                                except:
                                    if ' 0:00' in date_col or ' 00:00:00' in date_col:
                                        date_str = date_col.split(' ')[0]
                                    else:
                                        date_str = date_col
                                    week_date = pd.to_datetime(date_str)
                                
                                long_df.append({
                                    'personnel_no': row['personnel_no'],
                                    'eng_no': row['eng_no'],
                                    'eng_phase': row['eng_phase'],
                                    'week_start_date': week_date,
                                    'planned_hours': float(hours)
                                })
                    
                    if long_df:
                        df = pd.DataFrame(long_df)
           
        elif table_name == "dictionary":
            if all(col in df.columns for col in ["Clé", "Description"]):
                df = df.rename(columns={
                    "Clé": "key",
                    "Description": "description"
                })
            
        elif table_name == "engagements":
            column_mapping = {
                "Code projet": "eng_no",
                "Nom de projet": "eng_description",
                "Client No.": "client_no"
            }
            df = df.rename(columns={k: v for k, v in column_mapping.items() if k in df.columns})
            
            # Add primary_practice_id if missing
            if "primary_practice_id" not in df.columns:
                df["primary_practice_id"] = 1  # Default to SAP practice
            
        elif table_name == "budget":
            if all(col in df.columns for col in ["Code projet", "Code phase", "Budget"]):
                df = df[["Code projet", "Code phase", "Budget"]].dropna()
                df = df.rename(columns={
                    "Code projet": "eng_no",
                    "Code phase": "eng_phase",
                    "Budget": "budget"
                })

                # Clean up numeric budget values if needed
                df["budget"] = (
                    df["budget"]
                    .astype(str)
                    .str.replace(r"[^\d]", "", regex=True)  # Remove commas, spaces
                    .astype(float)
                )

        # For tables generated internally, just return an empty DataFrame
        # They will be fetched from the transformed directory
        elif table_name in ["vacations", "charge_out_rates", "optimization_parameters", "practices"]:
            logger.info(f"Table {table_name} is synthetically generated - returning empty DataFrame")
            
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
