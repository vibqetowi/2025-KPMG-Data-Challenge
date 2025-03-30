import pandas as pd
import os
import sys
from datetime import datetime, timedelta
from pathlib import Path
import argparse
import matplotlib.pyplot as plt  # Added for visualizations
import numpy as np  # Added for visualizations
import pulp  # Added for solver status checking

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
    # Verify path configuration before proceeding
    from scripts.advanced_data_analysis.utils.visualization_utils import verify_visualization_paths
    if not verify_visualization_paths():
        print("Error: Unable to verify output directories. Check permissions and paths.")
        return False
    
    # Parse arguments
    parser = argparse.ArgumentParser(description='Resource Optimization Tool')
    parser.add_argument('--all', action='store_true', help='Optimize all active phases')
    parser.add_argument('--eng_no', help='Engagement number to optimize (requires --phase)')
    parser.add_argument('--phase', help='Phase code to optimize (requires --eng_no)')
    parser.add_argument('--visualize', action='store_true', help='Visualize the MILP model for debugging')
    args = parser.parse_args()
    
    # If no arguments provided, run batch optimization (default behavior)
    if not (args.all or (args.eng_no and args.phase) or args.visualize):
        print("No specific optimization target provided. Running batch optimization by default...")
        return run_batch_optimization()
    
    # Run batch optimization if --all flag is provided
    if args.all and not args.visualize:
        print("Running optimization for all active phases...")
        return run_batch_optimization()
    
    # For visualization, we need specific engagement and phase
    if args.visualize:
        if not (args.eng_no and args.phase):
            print("Error: Visualization requires specifying both --eng_no and --phase")
            return False
        print(f"Visualizing MILP model for engagement {args.eng_no}, phase {args.phase}...")
        return visualize_milp_model(args.eng_no, args.phase)
    
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

def visualize_milp_model(eng_no, phase_code):
    """Visualize the MILP model to diagnose infeasibility issues"""
    # Initialize a DataFetcher to get timesheet data
    fetcher = DataFetcher()
    timesheet_data = fetcher.fetch_data(['timesheets'])['timesheets']
    
    # Get the latest timesheet date as the reference date using shared function
    reference_date = get_latest_work_date(timesheet_data)
    
    # Target is next Monday after the reference date using shared function
    next_monday = get_week_start_date(reference_date + timedelta(days=7))
    
    print(f"Latest timesheet data date: {reference_date}")
    print(f"Visualizing MILP model for week starting {next_monday}")
    print(f"Target: Engagement {eng_no}, Phase {phase_code}")
    
    # Get database configuration from shared config
    db_connection = DB_CONFIG.get('connection_string', None)
    
    # Run optimizer with visualization flag
    optimizer = MILPResourceOptimizer(target_week_start=next_monday, db_connection_string=db_connection)
    optimizer.target_engagements = [(eng_no, phase_code)]
    optimizer.visualize_model = True  # Enable visualization
    
    # Load data but don't solve yet - we want to diagnose the model
    optimizer.load_data()
    
    # Build model and analyze constraints
    model, hours_vars = optimizer.build_optimization_model()
    
    if model is None:
        print("Failed to build optimization model - check the logs for details")
        return False
    
    # Create directories for outputs
    log_dir = project_root / "logs"
    os.makedirs(log_dir, exist_ok=True)
    
    doc_dir = project_root / "Documentation"
    os.makedirs(doc_dir, exist_ok=True)
    
    # Save model visualization to a file
    visualization_path = log_dir / f"model_visualization_{eng_no}_{phase_code}.txt"
    
    try:
        # Import visualization utilities
        from scripts.advanced_data_analysis.utils.visualization_utils import (
            visualize_optimization_space, 
            visualize_engagement_allocation,
            create_textual_visualization
        )
        
        # Analyze model constraints
        print(f"\n=== MILP Model for Engagement {eng_no}, Phase {phase_code} ===")
        print(f"Model has {len(model.constraints)} constraints and {len(model.variables())} variables")
        
        # Try to detect sources of infeasibility
        print("\nChecking for potential sources of infeasibility...")
        
        # Check if there are any obviously infeasible constraints
        try:
            infeasible_constraints = optimizer.analyze_constraints(model)
            
            # Export text visualization to file
            optimizer.export_model_visualization(model, hours_vars, visualization_path)
            print(f"\nDetailed model visualization saved to: {visualization_path}")
            
            # Show recommended fixes
            print("\nRecommended actions to resolve infeasibility:")
            if infeasible_constraints:
                for constraint_name, details in infeasible_constraints.items():
                    print(f" - {constraint_name}: {details['reason']}")
                    print(f"   Suggestion: {details['suggestion']}")
            else:
                print(" - No obvious infeasible constraints detected")
                print(" - Try relaxing staff ratio constraints (--delta parameter)")
                print(" - Increase available capacity or reduce required workload")
                print(" - Check if all required staff levels are available for this engagement")
        except Exception as constraint_err:
            print(f"Error analyzing constraints: {constraint_err}")
            import traceback
            traceback.print_exc()
            print("\nSkipping constraint analysis due to error")
            
            # Try to save basic model details even if detailed analysis fails
            try:
                # Create a simple text visualization manually
                with open(visualization_path, 'w') as f:
                    f.write("=== BASIC MODEL ANALYSIS ===\n\n")
                    f.write(f"Model has {len(model.constraints)} constraints and {len(model.variables())} variables\n\n")
                    f.write("Analysis skipped due to error in constraint analyzer\n")
                print(f"\nBasic model visualization saved to: {visualization_path}")
            except Exception as basic_err:
                print(f"Error creating basic visualization: {basic_err}")
        
        # Create graphical visualization of optimization space
        # Find two key variables to visualize (try to pick hours variables for the target engagement)
        key_vars = []
        for var_name in [v.name for v in model.variables()]:
            if var_name.startswith(f"Hours_") and eng_no in var_name and str(phase_code) in var_name:
                key_vars.append(var_name)
                if len(key_vars) >= 2:
                    break
        
        # If we don't have enough variables for this specific engagement, just take the first two hours variables
        if len(key_vars) < 2:
            key_vars = [v.name for v in model.variables() if v.name.startswith("Hours_")][:2]
        
        # Create optimization space visualization 
        if len(key_vars) >= 2:
            # Create specific directory for this visualization
            opt_space_path = doc_dir / f"optimization-space-{eng_no}-{phase_code}.png"
            
            print(f"\nAttempting to create visualization at: {opt_space_path}")
            
            try:
                vis_path = visualize_optimization_space(
                    model=model,
                    key_vars=key_vars[:2],
                    filepath=opt_space_path,
                    title=f"Optimization Space: Eng {eng_no}, Phase {phase_code}"
                )
                
                if vis_path and os.path.exists(vis_path):
                    print(f"\nOptimization space visualization saved to: {vis_path}")
                else:
                    print("\nCouldn't save graphical visualization. Trying text-based visualization...")
                    text_path = doc_dir / f"optimization-space-{eng_no}-{phase_code}.txt"
                    text_vis_path = create_textual_visualization(model, key_vars, text_path)
                    if text_vis_path:
                        print(f"\nText-based visualization saved to: {text_vis_path}")
            except Exception as viz_error:
                print(f"\nError creating optimization visualization: {str(viz_error)}")
                print("Falling back to text-based visualization...")
                text_path = doc_dir / f"optimization-space-{eng_no}-{phase_code}.txt"
                text_vis_path = create_textual_visualization(model, key_vars, text_path)
                if text_vis_path:
                    print(f"\nText-based visualization saved to: {text_vis_path}")
        else:
            print("\nCouldn't create optimization space visualization: not enough variables")
        
        # Create allocation visualization if we have results
        try:
            # Try to solve to get actual allocation
            solver = pulp.PULP_CBC_CMD(msg=False, timeLimit=10)  # Quick solve attempt
            model.solve(solver)
            
            if model.status == pulp.LpStatusOptimal:
                # Process results to visualize allocation
                results = optimizer.process_results(hours_vars, model)
                alloc_path = doc_dir / "engagement-allocation.png"
                visualize_engagement_allocation(
                    results_df=results,
                    target_week=next_monday,
                    filepath=alloc_path
                )
                print(f"\nAllocation visualization saved to: {alloc_path}")
        except Exception as e:
            print(f"\nCouldn't create allocation visualization: {str(e)}")
        
        return True
    except Exception as e:
        print(f"Error in model visualization: {e}")
        import traceback
        traceback.print_exc()  # Print the full stack trace for debugging
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
                
        return True
    else:
        print(f"Optimization failed for engagement {eng_no}, phase {phase_code}")
        return False

if __name__ == "__main__":
    main()
