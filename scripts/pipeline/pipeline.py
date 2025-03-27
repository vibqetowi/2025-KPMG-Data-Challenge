#!/usr/bin/env python
"""
KPMG Data Challenge - Unified ETL Pipeline

This script orchestrates the complete ETL process by calling each component in sequence:
1. Excel to CSV conversion
2. Data transformation
3. DML SQL generation

Usage:
    python pipeline.py --excel-file <path_to_excel> --output-dir <path_to_output_dir>
"""

import os
import sys
import argparse
import logging
import time
from pathlib import Path

# Get the absolute path to the current script's directory
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))

# Add the utils directory to the Python path
utils_dir = current_dir / "utils"
sys.path.append(str(utils_dir))

# Now we can import the utility modules
from DML_writer import DMLWriter
from data_transformation import DataTransformer
from excel_to_csv import excel_to_csv  # Correct import for the excel_to_csv utility

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("pipeline.log"),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger("pipeline")

# Default directories
DEFAULT_CSV_DIR = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/raw')
DEFAULT_TRANSFORMED_DIR = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/transformed')
DEFAULT_DML_OUTPUT = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/Database/DML.sql')

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='KPMG Data Challenge ETL Pipeline')
    parser.add_argument('--excel-file', type=str, help='Path to the Excel file to process')
    return parser.parse_args()

def run_excel_to_csv(excel_file, output_dir):
    """Run the Excel to CSV conversion script."""
    if not excel_file:
        logger.error("Excel file path is required for conversion")
        return False
    
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

def run_data_transformation(input_dir, output_dir):
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

def run_dml_generation(input_dir, output_file):
    """Run the DML generation script."""
    logger.info(f"Starting DML generation")
    try:
        # Create DML writer and generate SQL
        writer = DMLWriter()
        writer.process_data()
        
        logger.info(f"DML generation completed. SQL file generated: {output_file}")
        return True
    except Exception as e:
        logger.error(f"Error during DML generation: {str(e)}", exc_info=True)
        return False

def main():
    """Main pipeline execution function."""
    start_time = time.time()
    logger.info("Starting KPMG Data Challenge ETL Pipeline")
    
    args = parse_arguments()
    success = True
    
    # Step 1: Excel to CSV conversion
    if not args.skip_excel:
        if not args.excel_file:
            logger.error("Excel file path is required. Use --excel-file or --skip-excel")
            return False
        success = run_excel_to_csv(args.excel_file, args.output_dir)
        if not success:
            logger.error("Excel to CSV conversion failed. Pipeline stopped.")
            return False
    else:
        logger.info("Skipping Excel to CSV conversion as requested")
    
    # Step 2: Data transformation
    if not args.skip_transform and success:
        success = run_data_transformation(args.output_dir, args.transformed_dir)
        if not success:
            logger.error("Data transformation failed. Pipeline stopped.")
            return False
    else:
        logger.info("Skipping data transformation as requested")
    
    # Step 3: DML generation
    if not args.skip_dml and success:
        success = run_dml_generation(args.transformed_dir, args.dml_output)
        if not success:
            logger.error("DML generation failed. Pipeline stopped.")
            return False
    else:
        logger.info("Skipping DML generation as requested")
    
    # Report completion
    elapsed_time = time.time() - start_time
    if success:
        logger.info(f"Pipeline completed successfully in {elapsed_time:.2f} seconds")
        logger.info(f"DML file generated: {args.dml_output}")
        logger.info("Next step: Execute the DML file in SQL Server")
    else:
        logger.error(f"Pipeline failed after {elapsed_time:.2f} seconds")
    
    return success

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
