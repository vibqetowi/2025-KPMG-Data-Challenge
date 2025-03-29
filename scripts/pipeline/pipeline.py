#!/usr/bin/env python
"""
KPMG Data Challenge - Unified ETL Pipeline

This script orchestrates the complete ETL process by:
1. Loading environment variables from .env
2. Testing database connection
3. Converting Excel to CSV
4. Transforming data
5. Generating DML SQL
6. Executing DDL SQL script against the database
7. Executing DML SQL script against the database

Usage:
    python pipeline.py [--skip-excel] [--skip-transform] [--skip-dml] [--skip-db-execution]
"""

import os
import sys
import argparse
import logging
import time
import pyodbc
from pathlib import Path
from dotenv import load_dotenv

# Get the absolute path to the current script's directory and project root
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge')

# Add the utils directory to the Python path
utils_dir = current_dir / "utils"
sys.path.append(str(utils_dir))
sys.path.append(str(project_root))

# Load environment variables from .env file in root directory
load_dotenv(project_root / '.env')

# Now we can import the utility modules
from utils.DML_writer import DMLWriter
from utils.data_transformation import DataTransformer
from utils.excel_to_csv import excel_to_csv

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(project_root / "pipeline.log"),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger("pipeline")

# Default directories
EXCEL_FILE = project_root / 'Documentation/KPMG Case Data.xlsx'
CSV_DUMP_DIR = project_root / 'csv-dump'
TRANSFORMED_DIR = project_root / 'csv-dump/transformed'
DATABASE_DIR = project_root / 'Database'
DDL_FILE = DATABASE_DIR / 'DDL.sql'
DML_FILE = DATABASE_DIR / 'DML.sql'

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='KPMG Data Challenge ETL Pipeline')
    parser.add_argument('--skip-excel', action='store_true', help='Skip Excel to CSV conversion')
    parser.add_argument('--skip-transform', action='store_true', help='Skip data transformation')
    parser.add_argument('--skip-dml', action='store_true', help='Skip DML generation')
    parser.add_argument('--skip-db-execution', action='store_true', help='Skip database execution')
    return parser.parse_args()

def test_db_connection():
    """Test the connection to the SQL Server database."""
    logger.info("Testing database connection...")
    
    # Get database connection details from environment variables
    server = os.getenv('SQL_SERVER')
    database = os.getenv('SQL_DATABASE')
    username = os.getenv('SQL_USERNAME')
    password = os.getenv('SQL_PASSWORD')
    driver = os.getenv('SQL_DRIVER')
    
    if not all([server, database, username, password, driver]):
        logger.error("Database connection details missing in .env file")
        return False
    
    connection_string = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}"
    
    try:
        # Try to connect to the database
        conn = pyodbc.connect(connection_string)
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.close()
        conn.close()
        
        logger.info("Database connection successful")
        return True
    except Exception as e:
        logger.error(f"Database connection failed: {str(e)}")
        return False

def run_excel_to_csv(excel_file, output_dir):
    """Run the Excel to CSV conversion script."""
    logger.info(f"Starting Excel to CSV conversion: {excel_file} -> {output_dir}")
    try:
        # Ensure output directory exists
        Path(output_dir).mkdir(exist_ok=True, parents=True)
        
        # Call the excel_to_csv function directly
        excel_to_csv(excel_file, output_dir)
        
        logger.info(f"Excel to CSV conversion completed successfully")
        return True
    except Exception as e:
        logger.error(f"Error during Excel to CSV conversion: {str(e)}", exc_info=True)
        return False

def run_data_transformation():
    """Run the data transformation script."""
    logger.info(f"Starting data transformation process")
    try:
        # Create transformer and run transformation
        transformer = DataTransformer()
        transformer.transform_all_data()
        
        logger.info(f"Data transformation completed successfully")
        return True
    except Exception as e:
        logger.error(f"Error during data transformation: {str(e)}", exc_info=True)
        return False

def run_dml_generation():
    """Run the DML generation script."""
    logger.info(f"Starting DML generation")
    try:
        # Create DML writer and generate SQL
        writer = DMLWriter()
        writer.process_data()
        
        logger.info(f"DML generation completed. SQL file generated: {DML_FILE}")
        return True
    except Exception as e:
        logger.error(f"Error during DML generation: {str(e)}", exc_info=True)
        return False

def execute_sql_file(sql_file):
    """Execute a SQL file against the database."""
    logger.info(f"Executing SQL file: {sql_file}")
    
    # Get database connection details from environment variables
    server = os.getenv('SQL_SERVER')
    database = os.getenv('SQL_DATABASE')
    username = os.getenv('SQL_USERNAME')
    password = os.getenv('SQL_PASSWORD')
    driver = os.getenv('SQL_DRIVER')
    
    connection_string = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}"
    
    try:
        # Read the SQL file
        with open(sql_file, 'r', encoding='utf-8') as f:
            sql = f.read()
        
        # Split the script on GO statements (T-SQL batch separator)
        batches = sql.split('GO')
        
        # Connect to the database
        conn = pyodbc.connect(connection_string)
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
        logger.error(f"SQL file execution failed: {str(e)}", exc_info=True)
        return False

def main():
    """Main pipeline execution function."""
    start_time = time.time()
    logger.info("Starting KPMG Data Challenge ETL Pipeline")
    
    args = parse_arguments()
    success = True
    
    # Step 0: Test database connection
    if not test_db_connection():
        logger.error("Database connection test failed. Pipeline stopped.")
        return False
    
    # Step 1: Excel to CSV conversion
    if not args.skip_excel and success:
        success = run_excel_to_csv(EXCEL_FILE, CSV_DUMP_DIR)
        if not success:
            logger.error("Excel to CSV conversion failed. Pipeline stopped.")
            return False
    else:
        logger.info("Skipping Excel to CSV conversion as requested")
    
    # Step 2: Data transformation
    if not args.skip_transform and success:
        success = run_data_transformation()
        if not success:
            logger.error("Data transformation failed. Pipeline stopped.")
            return False
    else:
        logger.info("Skipping data transformation as requested")
    
    # Step 3: DML generation
    if not args.skip_dml and success:
        success = run_dml_generation()
        if not success:
            logger.error("DML generation failed. Pipeline stopped.")
            return False
    else:
        logger.info("Skipping DML generation as requested")
    
    # Step 4: Execute DDL and DML SQL scripts
    if not args.skip_db_execution and success:
        # Execute DDL SQL script
        logger.info("Executing DDL SQL script...")
        success = execute_sql_file(DDL_FILE)
        if not success:
            logger.error("DDL SQL script execution failed. Pipeline stopped.")
            return False
        
        # Execute DML SQL script
        logger.info("Executing DML SQL script...")
        success = execute_sql_file(DML_FILE)
        if not success:
            logger.error("DML SQL script execution failed. Pipeline stopped.")
            return False
    else:
        logger.info("Skipping database execution as requested")
    
    # Report completion
    elapsed_time = time.time() - start_time
    if success:
        logger.info(f"Pipeline completed successfully in {elapsed_time:.2f} seconds")
        if not args.skip_db_execution:
            logger.info(f"Database has been populated with the transformed data")
        else:
            logger.info(f"Generated SQL files:")
            logger.info(f"  - DDL: {DDL_FILE}")
            logger.info(f"  - DML: {DML_FILE}")
    else:
        logger.error(f"Pipeline failed after {elapsed_time:.2f} seconds")
    
    return success

if __name__ == "__main__":
    # success = main()
    # sys.exit(0 if success else 1)
    test_db_connection()
