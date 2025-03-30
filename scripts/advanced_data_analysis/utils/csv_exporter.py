"""
CSV Exporter Utility

This module provides functions to export resource planning data directly to CSV
without requiring a database connection. This is useful for standalone operation
or when database connections fail.
"""

import pandas as pd
import os
from pathlib import Path
import logging
from datetime import datetime

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("csv_exporter")

def save_allocations_to_csv(allocations_df, target_week, output_dir=None):
    """
    Save resource allocations to a CSV file.
    
    Args:
        allocations_df (DataFrame): DataFrame containing allocation data
        target_week (datetime): The week these allocations are for
        output_dir (Path, optional): Directory to save the CSV in. Defaults to the 
                                    transformed directory in csv-dump.
    
    Returns:
        bool: True if successful, False otherwise
    """
    if allocations_df is None or allocations_df.empty:
        logger.warning("No allocations to save")
        return False
    
    try:
        # Handle output directory
        if output_dir is None:
            # Get project root
            current_file = Path(__file__)  # Current file path
            current_dir = current_file.parent  # utils directory
            project_root = current_dir.parent.parent.parent  # Project root
            
            # Default to csv-dump/transformed
            output_dir = project_root / "csv-dump" / "transformed"
        
        # Create directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)
        
        # Use a consistent filename without timestamp
        output_path = output_dir / "staffing_prediction.csv"
        
        # Ensure dataframe has the right columns
        required_columns = ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours']
        
        # Add any missing columns with default values
        for col in required_columns:
            if col not in allocations_df.columns:
                if col == 'week_start_date':
                    allocations_df[col] = target_week
                else:
                    allocations_df[col] = ""
        
        # Select only the required columns in the right order
        result_df = allocations_df[required_columns].copy()
        
        # Ensure week_start_date is a string
        if not pd.api.types.is_string_dtype(result_df['week_start_date']):
            result_df['week_start_date'] = result_df['week_start_date'].astype(str)
        
        # Save to CSV
        result_df.to_csv(output_path, index=False)
        logger.info(f"Successfully saved {len(result_df)} allocations to {output_path}")
        return True
        
    except Exception as e:
        logger.error(f"Error saving allocations to CSV: {e}")
        return False

def load_allocations_from_csv(target_week=None, input_dir=None):
    """
    Load resource allocations from a CSV file.
    
    Args:
        target_week (datetime, optional): Not used with consistent naming, kept for API compatibility
        input_dir (Path, optional): Directory to load the CSV from. Defaults to the 
                                   transformed directory in csv-dump.
    
    Returns:
        DataFrame: DataFrame containing allocation data, or None if file not found
    """
    try:
        # Handle input directory
        if input_dir is None:
            # Get project root
            current_file = Path(__file__)  # Current file path
            current_dir = current_file.parent  # utils directory
            project_root = current_dir.parent.parent.parent  # Project root
            
            # Default to csv-dump/transformed
            input_dir = project_root / "csv-dump" / "transformed"
        
        # Use consistent filename without timestamp
        input_path = input_dir / "staffing_prediction.csv"
        
        # Check if file exists
        if not os.path.exists(input_path):
            logger.warning(f"Allocations file not found: {input_path}")
            return None
        
        # Load CSV
        allocations_df = pd.read_csv(input_path)
        logger.info(f"Successfully loaded {len(allocations_df)} allocations from {input_path}")
        return allocations_df
        
    except Exception as e:
        logger.error(f"Error loading allocations from CSV: {e}")
        return None

# Example usage
if __name__ == "__main__":
    # Test saving and loading
    test_df = pd.DataFrame({
        'personnel_no': ['1001', '1002', '1003'],
        'eng_no': ['E001', 'E001', 'E002'],
        'eng_phase': [1, 1, 2],
        'week_start_date': ['2025-01-01', '2025-01-01', '2025-01-01'],
        'planned_hours': [20, 30, 40]
    })
    
    today = datetime.now()
    
    success = save_allocations_to_csv(test_df, today)
    if success:
        print("Test save successful")
        
        # Try loading it back
        loaded_df = load_allocations_from_csv(today)
        if loaded_df is not None:
            print("Test load successful")
            print(loaded_df)
