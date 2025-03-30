"""
Shared configuration for KPMG Data Challenge.

This module provides centralized configuration and path definitions
used across the project.
"""
import os
from pathlib import Path
from dotenv import load_dotenv
import logging
import threading
import time
import pyodbc
from sqlalchemy import create_engine

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("config")

# Get project root path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
PROJECT_ROOT = current_dir.parent.parent

# Load environment variables from .env file
load_dotenv(PROJECT_ROOT / '.env')

# Define common paths
EXCEL_FILE = PROJECT_ROOT / 'Documentation/KPMG Case Data.xlsx'
CSV_DUMP_DIR = PROJECT_ROOT / 'csv-dump'
TRANSFORMED_DIR = PROJECT_ROOT / 'csv-dump/transformed'
DATABASE_DIR = PROJECT_ROOT / 'Database'
DDL_FILE = DATABASE_DIR / 'DDL.sql'
DML_FILE = DATABASE_DIR / 'DML.sql'

# Define raw file mappings
RAW_FILE_MAP = {
    "timesheets": "KPMG Case Data_TIME.csv",
    "employees": "KPMG Case Data_Staffing___2024.csv", 
    "clients": "KPMG Case Data_Staffing___2024.csv",
    "engagements": "KPMG Case Data_Budget.csv",
    "phases": "KPMG Case Data_Budget.csv",
    "budget": "KPMG Case Data_Budget.csv",
    "staffing": "KPMG Case Data_Staffing___2024.csv",
    "practices": None,  # Generated internally
    "dictionary": "KPMG Case Data_Dictionnaire___Dictionary_.csv",
    "vacations": None,  # Generated internally
    "charge_out_rates": None,  # Generated internally
    "optimization_parameters": None  # Generated internally
}

# Column mapping definitions for transformations
COLUMN_MAPPINGS = {
    "timesheets": {
        "Personnel No.": "personnel_no",
        "Work Date": "work_date",
        "Hours": "hours",
        "Eng. No.": "eng_no",
        "Eng. Phase": "eng_phase",
        "Time Entry Date": "time_entry_date",
        "Posting Date": "posting_date",
        "Charge-Out Rate": "charge_out_rate",
        "Std. Price": "std_price",
        "Adm. Surcharge": "adm_surcharge"
    },
    "employees": {
        "Personnel No.": "personnel_no",
        "Employee Name": "employee_name",
        "Staff Level": "staff_level"
    },
    "clients": {
        "Client No.": "client_no",
        "Client Name": "client_name"
    },
    "phases": {
        "Code projet": "eng_no",
        "Code phase": "eng_phase",
        "Phase Projet": "phase_description",
        "Budget": "budget"
    },
    "engagements": {
        "Code projet": "eng_no",
        "Nom de projet": "eng_description",
        "Client No.": "client_no"
    },
    "dictionary": {
        "Clé": "key",
        "Description": "description"
    }
}

# Database configuration
DB_CONFIG = {
    "server": os.getenv("SQL_SERVER", "localhost"),
    "database": os.getenv("SQL_DATABASE", "KPMG_Data_Challenge"),
    "username": os.getenv("SQL_USERNAME", ""),
    "password": os.getenv("SQL_PASSWORD", ""),
    "driver": os.getenv("SQL_DRIVER", "{ODBC Driver 17 for SQL Server}"),
}

# Build connection string
if all([DB_CONFIG["server"], DB_CONFIG["database"]]):
    if DB_CONFIG["username"] and DB_CONFIG["password"]:
        # Username/password authentication
        DB_CONFIG["connection_string"] = (
            f"DRIVER={DB_CONFIG['driver']};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"UID={DB_CONFIG['username']};"
            f"PWD={DB_CONFIG['password']}"
        )
    else:
        # Windows authentication
        DB_CONFIG["connection_string"] = (
            f"DRIVER={DB_CONFIG['driver']};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"Trusted_Connection=yes"
        )
else:
    DB_CONFIG["connection_string"] = None

# Optimization parameters (default values)
OPT_PARAMS = {
    'alpha': 0.7,     # Weight for SPI contribution
    'beta': 0.3,      # Weight for VEC contribution
    'pse': 5.0,       # Penalty for switching engagements
    'delta': 0.2      # Ratio deviation tolerance (20%)
}

# Define TimeoutError for database connections
class TimeoutError(Exception):
    pass

# Database utility functions moved from db_utils.py
def test_db_connection(timeout=5):
    """
    Test the connection to the SQL Server database with timeout.
    
    Args:
        timeout (int): Connection timeout in seconds
        
    Returns:
        bool: True if connection successful, False otherwise
    """
    logger.info(f"Testing database connection with {timeout}s timeout...")
    
    conn_str = DB_CONFIG.get("connection_string")
    if not conn_str:
        logger.error("No connection string available")
        return False
    
    # Define a function to test the connection
    def test_connection():
        try:
            # Try to connect to the database
            conn = pyodbc.connect(conn_str, timeout=timeout)
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            cursor.close()
            conn.close()
            return True
        except Exception as e:
            logger.error(f"Database connection test failed: {str(e)}")
            return False

    # Use threading with a timeout
    result = [False]  # Use list to allow modification in the thread
    connection_thread = threading.Thread(
        target=lambda: result.__setitem__(0, test_connection())
    )
    connection_thread.daemon = True

    start_time = time.time()
    connection_thread.start()
    connection_thread.join(timeout=timeout)

    # Check if the thread completed within the timeout
    if connection_thread.is_alive():
        logger.error(f"Database connection timed out after {timeout} seconds")
        return False

    elapsed = time.time() - start_time
    
    if result[0]:
        logger.info(f"Database connection successful in {elapsed:.2f} seconds")
        return True
    else:
        logger.error("Database connection failed")
        return False

def create_sqlalchemy_engine():
    """Create and return a SQLAlchemy engine for the database."""
    conn_str = DB_CONFIG.get("connection_string")
    if not conn_str:
        logger.error("No connection string available")
        return None
        
    try:
        engine = create_engine(f"mssql+pyodbc:///?odbc_connect={conn_str}")
        return engine
    except Exception as e:
        logger.error(f"Error creating SQLAlchemy engine: {e}")
        return None

def execute_sql_file(sql_file):
    """
    Execute a SQL file against the database.
    
    Args:
        sql_file (str or Path): Path to the SQL file to execute
        
    Returns:
        bool: True if execution successful, False otherwise
    """
    logger.info(f"Executing SQL file: {sql_file}")
    
    conn_str = DB_CONFIG.get("connection_string")
    if not conn_str:
        logger.error("No connection string available")
        return False
    
    try:
        # Read the SQL file
        with open(sql_file, 'r', encoding='utf-8') as f:
            sql = f.read()
        
        # Split the script on GO statements (T-SQL batch separator)
        batches = sql.split('GO')
        
        # Connect to the database
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        
        # Execute each batch
        for batch in batches:
            batch = batch.strip()
            if batch:  # Skip empty batches
                cursor.execute(batch)
                conn.commit()
        
        cursor.close()
        conn.close()
        
        logger.info(f"SQL file execution completed: {sql_file}")
        return True
    except Exception as e:
        logger.error(f"SQL file execution failed: {str(e)}")
        return False
