import pandas as pd
import os
import sys
from datetime import datetime, timedelta
from pathlib import Path

# Set up path to include shared modules
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
shared_dir = project_root / "scripts" / "shared"
sys.path.append(str(shared_dir))

# Import shared modules for date handling and configuration
from metric_utils import get_week_start_date
from milp_resource_planning_optimizer import MILPResourceOptimizer
from config import DB_CONFIG  # Import database configuration from shared config

def main():
    """
    Run the MILP Resource Optimization without command line arguments.
    Uses configuration from shared modules and runs for the current date.
    """
    # Get today's date
    today = datetime.now().date()
    
    # Target is next Monday (for weekly planning)
    next_monday = get_week_start_date(today + timedelta(days=7))
    
    print(f"Running optimization for week starting {next_monday}")
    
    # Get database configuration from shared config
    db_connection = DB_CONFIG.get('connection_string', None)
    
    # Run optimization
    optimizer = MILPResourceOptimizer(target_week_start=next_monday, db_connection_string=db_connection)
    success, results = optimizer.run()
    
    if success and results is not None:
        print(f"Optimization successful with {len(results)} assignments")
        
        # Save to CSV with proper schema in transformed directory
        transformed_dir = project_root / "csv-dump" / "transformed"
        os.makedirs(transformed_dir, exist_ok=True)
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
        
        # Show summary
        print("\nAssignments by engagement:")
        eng_summary = results.groupby(['eng_no', 'eng_phase'])['planned_hours'].sum().reset_index()
        print(eng_summary)
        
        # Show EVM metrics that influenced the optimization
        print("\nEVM Metrics used for optimization:")
        if hasattr(optimizer, 'evm_metrics') and optimizer.evm_metrics is not None:
            evm_display = optimizer.evm_metrics[['eng_no', 'eng_phase', 'spi', 'vec', 'burn']].copy()
            # Format metrics for display
            evm_display['spi'] = evm_display['spi'].round(2)
            evm_display['vec'] = evm_display['vec'].round(2)
            evm_display['burn'] = evm_display['burn'].round(2)
            print(evm_display)
        else:
            print("No EVM metrics available")
        
        print("\nAssignments by consultant (top 10):")
        cons_summary = results.groupby('personnel_no')['planned_hours'].sum().reset_index()
        cons_summary = cons_summary.sort_values('planned_hours', ascending=False).head(10)
        print(cons_summary)
    else:
        print("Optimization failed or produced no results")

if __name__ == "__main__":
    main()
