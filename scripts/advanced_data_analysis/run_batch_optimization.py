"""
Batch Optimization Script

This script runs resource optimizations for all available phases in the system.
It handles:
- Fetching all active phases
- Running optimization for each phase
- Aggregating and saving results
"""

import pandas as pd
import os
import sys
from datetime import datetime, timedelta
from pathlib import Path
import logging

# Set up path to include shared modules
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
sys.path.append(str(project_root))  # Add project root to path

# Import shared modules using project-root relative imports
from scripts.shared.metric_utils import get_week_start_date, get_latest_work_date
from scripts.advanced_data_analysis.milp_resource_planning_optimizer import MILPResourceOptimizer
from scripts.shared.config import DB_CONFIG
from scripts.advanced_data_analysis.utils.fetcher import DataFetcher
from scripts.advanced_data_analysis.utils.csv_exporter import save_allocations_to_csv

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("batch_optimization")

def run_batch_optimization():
    """
    Run optimization for all active phases and aggregate results.
    """
    # Initialize a DataFetcher to get data
    logger.info("Initializing data fetcher and retrieving latest timesheet data")
    fetcher = DataFetcher()
    timesheet_data = fetcher.fetch_data(['timesheets'])['timesheets']
    
    # Get the latest timesheet date as the reference date using shared function
    reference_date = get_latest_work_date(timesheet_data)
    
    # Target is next Monday after the reference date using shared function
    next_monday = get_week_start_date(reference_date + timedelta(days=7))
    
    logger.info(f"Latest timesheet data date: {reference_date}")
    logger.info(f"Running optimization for week starting {next_monday}")
    
    # Get database configuration from shared config
    db_connection = DB_CONFIG.get('connection_string', None)
    
    # Fetch all active phases
    logger.info("Retrieving all active phases")
    phases_filter = {
        'where_clause': f"""
            (end_date >= '{next_monday}' OR end_date IS NULL OR actual_end_date IS NULL OR actual_end_date >= '{next_monday}')
        """
    }
    
    # Fetch active phases
    try:
        phases_data = fetcher.fetch_data(['phases'], {'phases': phases_filter})['phases']
        if phases_data.empty:
            logger.error("No active phases found")
            return False
        
        # Get unique engagements with phases
        unique_phases = phases_data[['eng_no', 'eng_phase']].drop_duplicates()
        logger.info(f"Found {len(unique_phases)} active phases to optimize")
        
        # Initialize optimizer once
        logger.info("Initializing resource optimizer")
        optimizer = MILPResourceOptimizer(target_week_start=next_monday, db_connection_string=db_connection)
        
        # Load all necessary data for optimization (shared across all phases)
        logger.info("Loading common data for all phase optimizations")
        optimizer.load_data()
        
        # Prepare for results
        all_results = []
        success_count = 0
        fallback_count = 0
        failed_count = 0
        
        # Process each engagement-phase combination
        for idx, (_, row) in enumerate(unique_phases.iterrows(), 1):
            eng_no = row['eng_no']
            eng_phase = row['eng_phase']
            
            logger.info(f"Processing phase {idx}/{len(unique_phases)}: Eng {eng_no}, Phase {eng_phase}")
            
            # Run optimization for this phase
            try:
                # Filter data to this phase
                phase_optimizer = MILPResourceOptimizer(target_week_start=next_monday, db_connection_string=db_connection)
                phase_optimizer.target_engagements = [(eng_no, eng_phase)]  # Flag to filter to just this engagement
                
                # Run optimization
                success, results = phase_optimizer.run()
                
                if success and results is not None:
                    # Check if using fallback
                    using_fallback = hasattr(phase_optimizer, 'using_fallback') and phase_optimizer.using_fallback
                    
                    if using_fallback:
                        logger.info(f"Using fallback for Eng {eng_no}, Phase {eng_phase} with {len(results)} assignments")
                        fallback_count += 1
                    else:
                        logger.info(f"Optimization successful for Eng {eng_no}, Phase {eng_phase} with {len(results)} assignments")
                        success_count += 1
                    
                    # Add results to overall results
                    all_results.append(results)
                else:
                    logger.warning(f"Failed to optimize Eng {eng_no}, Phase {eng_phase}")
                    failed_count += 1
            
            except Exception as e:
                logger.error(f"Error processing Eng {eng_no}, Phase {eng_phase}: {str(e)}")
                failed_count += 1
        
        # Create transformed directory for outputs
        transformed_dir = project_root / "csv-dump" / "transformed"
        os.makedirs(transformed_dir, exist_ok=True)
        
        # Combine all results and save
        if all_results:
            combined_results = pd.concat(all_results, ignore_index=True)
            logger.info(f"Combined {len(combined_results)} assignments from all phases")
            
            # Ensure column order matches the table schema
            column_order = ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours']
            combined_results = combined_results[column_order]
            
            # Convert week_start_date to string in YYYY-MM-DD format if needed
            if not isinstance(combined_results['week_start_date'].iloc[0], str):
                combined_results['week_start_date'] = combined_results['week_start_date'].astype(str)
            
            # Save to CSV
            csv_path = transformed_dir / "staffing_prediction.csv"
            combined_results.to_csv(csv_path, index=False)
            logger.info(f"Saved combined results to {csv_path}")
            
            # Print summary statistics
            print("\n=== Batch Optimization Results ===")
            print(f"Target week: {next_monday}")
            print(f"Total phases processed: {len(unique_phases)}")
            print(f"Successfully optimized: {success_count}")
            print(f"Using fallback allocations: {fallback_count}")
            print(f"Failed phases: {failed_count}")
            print(f"Total assignments created: {len(combined_results)}")
            
            # Show summary by engagement
            eng_summary = combined_results.groupby(['eng_no', 'eng_phase'])['planned_hours'].sum().reset_index()
            print("\nAssignments by engagement:")
            print(eng_summary)
            
            # Show summary by consultant
            consultant_summary = combined_results.groupby('personnel_no')['planned_hours'].sum().reset_index()
            consultant_summary = consultant_summary.sort_values('planned_hours', ascending=False)
            print("\nTop consultant allocations:")
            print(consultant_summary.head(10))
            
            return True
        else:
            logger.error("No results generated from any phase")
            return False
            
    except Exception as e:
        logger.error(f"Error in batch optimization: {str(e)}")
        return False

if __name__ == "__main__":
    print("Starting batch optimization for all active phases...")
    success = run_batch_optimization()
    
    if success:
        print("\nBatch optimization completed successfully.")
    else:
        print("\nBatch optimization encountered errors. Check logs for details.")
