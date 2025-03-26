import os
import pandas as pd
import numpy as np
from pathlib import Path
import logging
from datetime import datetime
import pyodbc
from simple_salesforce import Salesforce
import json
import time
import requests
from requests.exceptions import RequestException
from dotenv import load_dotenv

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Load environment variables from .env file
load_dotenv()

# Configuration paths - use environment variables with defaults that are relative to project root
# Get project root directory (can be customized via env var)
PROJECT_ROOT = Path(os.getenv('PROJECT_ROOT', Path(__file__).parent.parent.parent))
CONFIG_DIR = Path(os.getenv('CONFIG_DIR', PROJECT_ROOT / 'config'))
TEMP_DIR = Path(os.getenv('TEMP_DIR', PROJECT_ROOT / 'temp'))
OUTPUT_DIR = Path(os.getenv('OUTPUT_DIR', PROJECT_ROOT / 'output'))

class SalesforceToSQLPipeline:
    def __init__(self):
        """
        Initialize the pipeline with configuration settings for Salesforce and SQL Server.
        """
        # Ensure directories exist
        CONFIG_DIR.mkdir(exist_ok=True, parents=True)
        TEMP_DIR.mkdir(exist_ok=True, parents=True)
        OUTPUT_DIR.mkdir(exist_ok=True, parents=True)
        
        # Load configurations
        self._load_config()
        
        # Initialize connections
        self.sf_connection = None
        self.sql_connection = None
        
        # DataFrames for intermediate storage
        self.dfs = {}
        
        # SQL table schemas matching required structure
        self.sql_schemas = {
            'employees': {
                'columns': ['personnel_no', 'employee_name', 'staff_level', 'is_external', 'employment_basis'],
                'source_object': 'Contact',
                'source_mapping': {
                    'personnel_no': 'Employee_ID__c',
                    'employee_name': 'Name',
                    'staff_level': 'Title',
                    'is_external': 'Is_External__c',
                    'employment_basis': 'Employment_Basis__c'
                }
            },
            'clients': {
                'columns': ['client_no', 'client_name'],
                'source_object': 'Account',
                'source_mapping': {
                    'client_no': 'Client_Number__c',
                    'client_name': 'Name'
                }
            },
            'engagements': {
                'columns': ['eng_no', 'eng_description', 'client_no'],
                'source_object': 'Opportunity',
                'source_mapping': {
                    'eng_no': 'Engagement_Number__c',
                    'eng_description': 'Name',
                    'client_no': 'AccountId'
                }
            },
            'phases': {
                'columns': ['eng_no', 'eng_phase', 'phase_description', 'budget'],
                'source_object': 'Project_Phase__c',
                'source_mapping': {
                    'eng_no': 'Engagement__c',
                    'eng_phase': 'Phase_Number__c',
                    'phase_description': 'Name',
                    'budget': 'Budget__c'
                }
            },
            'timesheets': {
                'columns': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'work_date', 'hours', 
                           'time_entry_date', 'posting_date', 'charge_out_rate', 'std_price', 'adm_surcharge'],
                'source_object': 'TimeEntry__c',
                'source_mapping': {
                    'id': None,  # Auto-generated
                    'personnel_no': 'Contact__c',
                    'eng_no': 'Engagement__c',
                    'eng_phase': 'Project_Phase__c',
                    'work_date': 'Work_Date__c',
                    'hours': 'Hours__c',
                    'time_entry_date': 'Entry_Date__c',
                    'posting_date': 'Posting_Date__c',
                    'charge_out_rate': 'Charge_Out_Rate__c',
                    'std_price': 'Standard_Price__c',
                    'adm_surcharge': 'Admin_Surcharge__c'
                }
            }
        }
        
        # Column data types for SQL Server insertion
        self.column_types = {
            'personnel_no': 'int',
            'employee_name': 'nvarchar',
            'staff_level': 'nvarchar',
            'is_external': 'bit',
            'employment_basis': 'decimal',
            'client_no': 'int',
            'client_name': 'nvarchar',
            'eng_no': 'bigint',
            'eng_description': 'nvarchar',
            'eng_phase': 'int',
            'phase_description': 'nvarchar',
            'budget': 'decimal',
            'id': 'int',
            'week_start_date': 'date',
            'planned_hours': 'decimal',
            'work_date': 'date',
            'hours': 'decimal',
            'time_entry_date': 'date',
            'posting_date': 'date',
            'charge_out_rate': 'decimal',
            'std_price': 'decimal',
            'adm_surcharge': 'decimal'
        }
        
        # Auto-generated columns that should be excluded from INSERT statements
        self.auto_generated_columns = {
            'timesheets': ['id']
        }
    
    def _load_config(self):
        """
        Load configuration from environment variables or config files.
        """
        # Salesforce credentials
        self.sf_config = {
            'username': os.getenv('SF_USERNAME'),
            'password': os.getenv('SF_PASSWORD'),
            'security_token': os.getenv('SF_SECURITY_TOKEN'),
            'domain': os.getenv('SF_DOMAIN', 'login')
        }
        
        # SQL Server configuration
        self.sql_config = {
            'server': os.getenv('SQL_SERVER'),
            'database': os.getenv('SQL_DATABASE', 'KPMG_Data_Challenge'),
            'username': os.getenv('SQL_USERNAME'),
            'password': os.getenv('SQL_PASSWORD'),
            'driver': os.getenv('SQL_DRIVER', '{ODBC Driver 17 for SQL Server}')
        }
        
        # Fallback to config file if env vars not available
        if not all([self.sf_config['username'], self.sf_config['password']]):
            sf_config_file = CONFIG_DIR / 'salesforce_config.json'
            if sf_config_file.exists():
                with open(sf_config_file, 'r') as f:
                    self.sf_config.update(json.load(f))
        
        if not all([self.sql_config['server'], self.sql_config['username'], self.sql_config['password']]):
            sql_config_file = CONFIG_DIR / 'sql_config.json'
            if sql_config_file.exists():
                with open(sql_config_file, 'r') as f:
                    self.sql_config.update(json.load(f))
    
    def connect_to_salesforce(self):
        """
        Connect to Salesforce API.
        """
        try:
            logger.info("Connecting to Salesforce...")
            self.sf_connection = Salesforce(
                username=self.sf_config['username'],
                password=self.sf_config['password'],
                security_token=self.sf_config['security_token'],
                domain=self.sf_config['domain']
            )
            logger.info("Connected to Salesforce successfully.")
            return True
        except Exception as e:
            logger.error(f"Error connecting to Salesforce: {e}")
            return False
    
    def connect_to_sql_server(self):
        """
        Connect to SQL Server database.
        """
        try:
            logger.info(f"Connecting to SQL Server: {self.sql_config['server']}/{self.sql_config['database']}")
            conn_str = (
                f"DRIVER={self.sql_config['driver']};"
                f"SERVER={self.sql_config['server']};"
                f"DATABASE={self.sql_config['database']};"
                f"UID={self.sql_config['username']};"
                f"PWD={self.sql_config['password']}"
            )
            self.sql_connection = pyodbc.connect(conn_str)
            logger.info("Connected to SQL Server successfully.")
            return True
        except Exception as e:
            logger.error(f"Error connecting to SQL Server: {e}")
            return False
    
    def extract_from_salesforce(self):
        """
        Extract data from Salesforce objects defined in the schemas.
        """
        if not self.sf_connection:
            logger.error("No active Salesforce connection. Call connect_to_salesforce() first.")
            return False
        
        try:
            for table_name, schema in self.sql_schemas.items():
                sf_object = schema['source_object']
                field_mapping = schema['source_mapping']
                
                # Build SOQL query
                fields = ', '.join([field for field in field_mapping.values() if field])
                soql = f"SELECT Id, {fields} FROM {sf_object}"
                
                logger.info(f"Extracting data from Salesforce object: {sf_object}")
                
                try:
                    # Execute query with error handling for large result sets
                    result = self.sf_connection.query_all(soql)
                    records = result['records']
                    
                    if not records:
                        logger.warning(f"No records found for {sf_object}")
                        self.dfs[table_name] = pd.DataFrame(columns=schema['columns'])
                        continue
                    
                    # Transform to pandas DataFrame with appropriate column mapping
                    data = []
                    for record in records:
                        row = {}
                        for target_col, source_field in field_mapping.items():
                            if source_field:
                                # Handle nested relationship fields
                                if '.' in source_field:
                                    parts = source_field.split('.')
                                    value = record
                                    for part in parts:
                                        if value and part in value:
                                            value = value[part]
                                        else:
                                            value = None
                                            break
                                else:
                                    value = record.get(source_field)
                                
                                # Remove Salesforce attributes
                                if isinstance(value, dict) and 'attributes' in value:
                                    value = {k: v for k, v in value.items() if k != 'attributes'}
                                
                                row[target_col] = value
                            else:
                                row[target_col] = None
                        
                        data.append(row)
                    
                    # Create DataFrame
                    df = pd.DataFrame(data)
                    
                    # Ensure all columns from schema are present
                    for col in schema['columns']:
                        if col not in df.columns:
                            df[col] = None
                    
                    # Select only columns from schema
                    df = df[schema['columns']]
                    
                    self.dfs[table_name] = df
                    logger.info(f"Extracted {len(df)} records for {table_name}")
                    
                except Exception as e:
                    logger.error(f"Error extracting data from {sf_object}: {e}")
                    self.dfs[table_name] = pd.DataFrame(columns=schema['columns'])
            
            return True
        except Exception as e:
            logger.error(f"Error in Salesforce extraction: {e}")
            return False
    
    def transform_data(self):
        """
        Transform the extracted data to match SQL Server requirements.
        """
        logger.info("Starting data transformation")
        
        try:
            for table_name, df in self.dfs.items():
                if df.empty:
                    logger.warning(f"No data to transform for {table_name}")
                    continue
                
                logger.info(f"Transforming data for {table_name}")
                
                # Data type conversions based on column types
                for col in df.columns:
                    if col in self.column_types:
                        col_type = self.column_types[col]
                        
                        try:
                            if col_type in ('int', 'bigint'):
                                df[col] = pd.to_numeric(df[col], errors='coerce')
                                df[col] = df[col].astype('Int64')  # Nullable integer
                            elif col_type == 'decimal':
                                df[col] = pd.to_numeric(df[col], errors='coerce')
                            elif col_type == 'bit':
                                # Convert various boolean formats to 0/1
                                df[col] = df[col].map(lambda x: 1 if str(x).lower() in ('true', 't', 'yes', 'y', '1') 
                                                      else (0 if str(x).lower() in ('false', 'f', 'no', 'n', '0') else None))
                            elif col_type == 'date':
                                df[col] = pd.to_datetime(df[col], errors='coerce')
                        except Exception as e:
                            logger.error(f"Error converting {col} to {col_type}: {e}")
                
                # Custom transformations for specific tables
                if table_name == 'employees':
                    # Set defaults if null
                    if 'employment_basis' in df.columns:
                        df['employment_basis'].fillna(40.0, inplace=True)
                
                # Handle composite primary keys
                if table_name == 'phases':
                    # Ensure both parts of the composite primary key are present
                    df = df[df['eng_no'].notna() & df['eng_phase'].notna()]
                    logger.info(f"After composite PK validation, {table_name} has {len(df)} records")
                
                # Set NULL for auto-generated columns
                for col in self.auto_generated_columns.get(table_name, []):
                    df[col] = None
                
                # Update the dataframe in the dictionary
                self.dfs[table_name] = df
            
            logger.info("Data transformation completed")
            return True
        except Exception as e:
            logger.error(f"Error in data transformation: {e}")
            return False
    
    def upload_to_sql_server(self):
        """
        Upload transformed data to SQL Server database.
        """
        if not self.sql_connection:
            logger.error("No active SQL Server connection. Call connect_to_sql_server() first.")
            return False
        
        try:
            cursor = self.sql_connection.cursor()
            
            # Process tables in order to handle foreign key constraints
            table_order = [
                'employees', 
                'clients', 
                'engagements', 
                'phases', 
                'timesheets'
            ]
            
            for table_name in table_order:
                if table_name not in self.dfs or self.dfs[table_name].empty:
                    logger.warning(f"Skipping empty table: {table_name}")
                    continue
                
                df = self.dfs[table_name]
                logger.info(f"Uploading {len(df)} records to {table_name}")
                
                # Remove auto-generated columns from INSERT statements
                schema_columns = list(df.columns)
                for col in self.auto_generated_columns.get(table_name, []):
                    if col in schema_columns:
                        schema_columns.remove(col)
                
                # Generate batched INSERT statements
                batch_size = 1000
                total_rows = len(df)
                
                # Enable identity insert if needed
                if table_name in self.auto_generated_columns:
                    cursor.execute(f"SET IDENTITY_INSERT [dbo].[{table_name}] ON")
                
                # Process in batches
                for start_idx in range(0, total_rows, batch_size):
                    end_idx = min(start_idx + batch_size, total_rows)
                    batch = df.iloc[start_idx:end_idx]
                    
                    # Begin transaction for this batch
                    cursor.execute("BEGIN TRANSACTION")
                    
                    try:
                        # For each row in the batch
                        for _, row in batch.iterrows():
                            # Format values based on column types
                            values = []
                            for col in schema_columns:
                                value = row[col]
                                if pd.isna(value) or value is None:
                                    values.append('NULL')
                                else:
                                    col_type = self.column_types.get(col, 'nvarchar')
                                    
                                    if col_type in ('int', 'bigint'):
                                        values.append(str(int(float(value))))
                                    elif col_type == 'decimal':
                                        values.append(f"{float(value):.2f}")
                                    elif col_type == 'bit':
                                        values.append('1' if value else '0')
                                    elif col_type == 'date':
                                        if isinstance(value, pd.Timestamp):
                                            values.append(f"'{value.strftime('%Y-%m-%d')}'")
                                        else:
                                            values.append(f"'{pd.to_datetime(value).strftime('%Y-%m-%d')}'")
                                    elif col_type.startswith('nvarchar'):
                                        escaped_value = str(value).replace("'", "''")
                                        values.append(f"N'{escaped_value}'")
                                    else:
                                        escaped_value = str(value).replace("'", "''")
                                        values.append(f"'{escaped_value}'")
                            
                            # Create and execute INSERT statement
                            columns_str = ', '.join([f"[{col}]" for col in schema_columns])
                            values_str = ', '.join(values)
                            insert_sql = f"INSERT INTO [dbo].[{table_name}] ({columns_str}) VALUES ({values_str})"
                            
                            cursor.execute(insert_sql)
                        
                        # Commit the transaction for this batch
                        cursor.execute("COMMIT TRANSACTION")
                        logger.info(f"Committed batch {start_idx//batch_size + 1} ({start_idx}-{end_idx}) to {table_name}")
                    
                    except Exception as e:
                        # Rollback in case of error
                        cursor.execute("IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION")
                        logger.error(f"Error inserting batch to {table_name}: {e}")
                        raise
                
                # Disable identity insert if it was enabled
                if table_name in self.auto_generated_columns:
                    cursor.execute(f"SET IDENTITY_INSERT [dbo].[{table_name}] OFF")
            
            logger.info("All data uploaded to SQL Server successfully")
            return True
        
        except Exception as e:
            logger.error(f"Error uploading to SQL Server: {e}")
            return False
        finally:
            if hasattr(self, 'sql_connection') and self.sql_connection:
                self.sql_connection.close()
                logger.info("SQL Server connection closed")
    
    def run_pipeline(self):
        """
        Run the complete ETL pipeline.
        """
        start_time = time.time()
        logger.info("Starting Salesforce to SQL Server ETL pipeline")
        
        # Phase 1: Connect to sources
        if not self.connect_to_salesforce():
            return False
        
        if not self.connect_to_sql_server():
            return False
        
        # Phase 2: Extract data from Salesforce
        if not self.extract_from_salesforce():
            return False
        
        # Phase 3: Transform data
        if not self.transform_data():
            return False
        
        # Phase 4: Upload to SQL Server
        if not self.upload_to_sql_server():
            return False
        
        # Calculate runtime
        end_time = time.time()
        runtime = end_time - start_time
        logger.info(f"ETL pipeline completed in {runtime:.2f} seconds")
        
        return True

def main():
    """
    Main function to run the Salesforce to SQL Server pipeline.
    """
    logger.info("Initializing Salesforce to SQL Server pipeline")
    
    try:
        # Create pipeline instance
        pipeline = SalesforceToSQLPipeline()
        
        # Run complete pipeline
        success = pipeline.run_pipeline()
        
        if success:
            logger.info("Pipeline executed successfully!")
        else:
            logger.error("Pipeline execution failed.")
    
    except Exception as e:
        logger.error(f"Unhandled error in pipeline: {e}", exc_info=True)

if __name__ == "__main__":
    main()
