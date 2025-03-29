"""
Shared database utilities for KPMG Data Challenge.

This module provides database connection and execution functions
used across the project.
"""
import os
import logging
import pyodbc
import threading
import time
from dotenv import load_dotenv
from pathlib import Path
from sqlalchemy import create_engine

# Get project root using relative path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("db_utils")

class TimeoutError(Exception):
    pass

def get_db_connection_params():
    """Get database connection parameters from environment variables."""
    # Load environment variables if not already loaded
    load_dotenv(project_root / '.env')
    
    return {
        'server': os.getenv('SQL_SERVER'),
        'database': os.getenv('SQL_DATABASE', 'KPMG_Data_Challenge'),
        'username': os.getenv('SQL_USERNAME'),
        'password': os.getenv('SQL_PASSWORD'),
        'driver': os.getenv('SQL_DRIVER', '{ODBC Driver 17 for SQL Server}')
    }

def get_connection_string():
    """Build and return the database connection string."""
    params = get_db_connection_params()
    
    if not all([params['server'], params['database'], params['username'], params['password'], params['driver']]):
        logger.error("Database connection details missing in .env file")
        return None
        
    return f"DRIVER={params['driver']};SERVER={params['server']};DATABASE={params['database']};UID={params['username']};PWD={params['password']}"

def test_db_connection(timeout=5):
    """
    Test the connection to the SQL Server database with timeout.
    
    Args:
        timeout (int): Connection timeout in seconds
        
    Returns:
        bool: True if connection successful, False otherwise
    """
    logger.info(f"Testing database connection with {timeout}s timeout...")
    
    conn_str = get_connection_string()
    if not conn_str:
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
    conn_str = get_connection_string()
    if not conn_str:
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
    
    conn_str = get_connection_string()
    if not conn_str:
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
