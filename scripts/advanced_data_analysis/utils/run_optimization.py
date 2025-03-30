import pandas as pd
import os
import sys
from datetime import datetime, timedelta
from pathlib import Path
import argparse

# Set up path to include shared modules
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
sys.path.append(str(project_root))  # Add project root to path

# Import shared modules using project-root relative imports
from scripts.shared.metric_utils import get_week_start_date, get_latest_work_date
from scripts.advanced_data_analysis.milp_resource_planning_optimizer import MILPResourceOptimizer
from scripts.shared.config import DB_CONFIG
from scripts.advanced_data_analysis.utils.fetcher import DataFetcher
from scripts.advanced_data_analysis.run_batch_optimization import run_batch_optimization

# Import the financial_health module if it exists, otherwise handle gracefully
try:
    from scripts.shared.financial_health import analyze_portfolio_health
except ImportError:
    # Define a simpler version if the module doesn't exist
    def analyze_portfolio_health(df):
        print("Financial health analysis not available")
        return df

def main():
    """
    Run the MILP Resource Optimization as described in Appendix 2 of the README.
    
    1. Determine target week (next Monday after latest timesheet data)
    2. Call MILPResourceOptimizer which handles:
       - Data preparation and calculating engagement status
       - Retrieving consultant availability and calculating ratios
       - Building and solving the optimization model
    3. Save and display results
    """
    # Parse arguments
    parser = argparse.ArgumentParser(description='Resource Optimization Tool')
    parser.add_argument('--all', action='store_true', help='Optimize all active phases')
    parser.add_argument('--eng_no', help='Engagement number to optimize (requires --phase)')
    parser.add_argument('--phase', help='Phase code to optimize (requires --eng_no)')
    args = parser.parse_args()
    
    # Run batch optimization if --all flag is provided
    if args.all:
        print("Running optimization for all active phases...")
        return run_batch_optimization()
    
    # If specific eng_no and phase are provided, optimize just that phase
    if args.eng_no and args.phase:
        print(f"Running optimization for specific engagement: {args.eng_no}, phase: {args.phase}")
        return optimize_specific(args.eng_no, args.phase)
    
    # Default to single optimization for next week
    # Initialize a DataFetcher to get timesheet data
    fetcher = DataFetcher()
    timesheet_data = fetcher.fetch_data(['timesheets'])['timesheets']
    
    # Get the latest timesheet date as the reference date using shared function
    reference_date = get_latest_work_date(timesheet_data)
    
    # Target is next Monday after the reference date using shared function
    next_monday = get_week_start_date(reference_date + timedelta(days=7))
    
    print(f"Latest timesheet data date: {reference_date}")
    print(f"Running optimization for week starting {next_monday}")
    
    # Get database configuration from shared config
    db_connection = DB_CONFIG.get('connection_string', None)
    
    print("Following Appendix 2 optimization strategy:")
    print("1. Preparing data and calculating current engagement status...")
    print("2. Determining consultant availability for target week...")
    print("3. Calculating staffing ratios from previous week...")
    print("4. Retrieving optimization parameters...")
    print("5. Formulating and solving MILP model...")
    
    # Run optimization
    optimizer = MILPResourceOptimizer(target_week_start=next_monday, db_connection_string=db_connection)
    success, results = optimizer.run()
    
    # Create transformed directory - do this regardless of optimization success
    transformed_dir = project_root / "csv-dump" / "transformed"
    os.makedirs(transformed_dir, exist_ok=True)
    
    if success and results is not None:
        # Check if we're using fallback results
        using_fallback = hasattr(optimizer, 'using_fallback') and optimizer.using_fallback
        
        if using_fallback:
            print(f"Optimization returned fallback results with {len(results)} assignments from previous week")
        else:
            print(f"Optimization successful with {len(results)} assignments")
        
        # Save to CSV with proper schema in transformed directory - use a consistent filename without timestamp
        transformed_path = transformed_dir / "staffing_prediction.csv"
        
        # Save with same schema as staffing_prediction table
        if not results.empty:
            # Ensure column order matches the table schema
            column_order = ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours']
            results = results[column_order]
            
            # Convert week_start_date to string in YYYY-MM-DD format if needed
            if not isinstance(results['week_start_date'].iloc[0], str):
                results['week_start_date'] = results['week_start_date'].astype(str)
            
            # Save to CSV
            results.to_csv(transformed_path, index=False)
            print(f"Results saved to {transformed_path}")
        
        # Show summary statistics of the results
        print("\nAssignments by engagement:")
        eng_summary = results.groupby(['eng_no', 'eng_phase'])['planned_hours'].sum().reset_index()
        print(eng_summary)
        
        # Show EVM metrics that influenced the optimization if not using fallback
        if not using_fallback and hasattr(optimizer, 'evm_metrics') and optimizer.evm_metrics is not None:
            evm_display = optimizer.evm_metrics[['eng_no', 'eng_phase', 'spi', 'vec', 'burn']].copy()
            evm_display = evm_display.round(2)
            print("\nEVM Metrics used for optimization:")
            print(evm_display)
            
            # Show financial health analysis using the new shared utility
            if 'vec' in evm_display.columns and 'burn' in evm_display.columns:
                health_analysis = analyze_portfolio_health(evm_display)
                print("\nHealth Status by Engagement:")
                print(health_analysis[['eng_no', 'eng_phase', 'vec', 'burn', 'health_status']])
        return True
    else:
        print("Optimization failed or produced no results")
        print("Please check the log files for details on the failure.")
        print(f"If a previous week's data was used as a fallback, it should be saved in the {transformed_dir} directory.")
        return False

def optimize_specific(eng_no, phase_code):
    """Run optimization for a specific engagement and phase"""
    # Initialize a DataFetcher to get timesheet data
    fetcher = DataFetcher()
    timesheet_data = fetcher.fetch_data(['timesheets'])['timesheets']
    
    # Get the latest timesheet date as the reference date using shared function
    reference_date = get_latest_work_date(timesheet_data)
    
    # Target is next Monday after the reference date using shared function
    next_monday = get_week_start_date(reference_date + timedelta(days=7))
    
    print(f"Latest timesheet data date: {reference_date}")
    print(f"Running optimization for week starting {next_monday}")
    print(f"Targeting engagement {eng_no}, phase {phase_code}")
    
    # Get database configuration from shared config
    db_connection = DB_CONFIG.get('connection_string', None)
    
    # Run optimization with target engagement filter
    optimizer = MILPResourceOptimizer(target_week_start=next_monday, db_connection_string=db_connection)
    optimizer.target_engagements = [(eng_no, phase_code)]
    success, results = optimizer.run()
    
    # Create transformed directory
    transformed_dir = project_root / "csv-dump" / "transformed"
    os.makedirs(transformed_dir, exist_ok=True)
    
    if success and results is not None:
        # Check if we're using fallback results
        using_fallback = hasattr(optimizer, 'using_fallback') and optimizer.using_fallback
        
        if using_fallback:
            print(f"Optimization returned fallback results with {len(results)} assignments")
        else:
            print(f"Optimization successful with {len(results)} assignments")
        
        # Save to CSV
        transformed_path = transformed_dir / "staffing_prediction.csv"
        
        # Save with same schema
        if not results.empty:
            # Ensure column order matches the table schema
            column_order = ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours']
            results = results[column_order]
            
            # Convert week_start_date to string in YYYY-MM-DD format if needed
            if not isinstance(results['week_start_date'].iloc[0], str):
                results['week_start_date'] = results['week_start_date'].astype(str)
            
            # Save to CSV
            results.to_csv(transformed_path, index=False)
            print(f"Results saved to {transformed_path}")
        
        return True
    else:
        print(f"Optimization failed for engagement {eng_no}, phase {phase_code}")
        return False

if __name__ == "__main__":
    main()
