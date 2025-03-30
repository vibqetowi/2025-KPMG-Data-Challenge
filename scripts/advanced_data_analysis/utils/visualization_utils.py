"""
Visualization Utilities for Resource Optimization

This module provides functions to visualize the optimization space
and constraints to help understand model feasibility.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.colors import LinearSegmentedColormap
import pandas as pd
import pulp
import os
from pathlib import Path
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("visualization_utils")

def verify_visualization_paths():
    """
    Verify that all necessary directories for visualizations exist and are writable.
    Creates them if they don't exist.
    
    Returns:
        bool: True if all paths are verified, False otherwise
    """
    try:
        # Get project root path
        current_file = Path(__file__)
        project_root = current_file.parent.parent.parent.parent
        
        # List of directories to verify
        dirs_to_check = [
            project_root / "Documentation",
            project_root / "logs",
            project_root / "csv-dump" / "transformed"
        ]
        
        # Check and create each directory
        for directory in dirs_to_check:
            if not directory.exists():
                logger.info(f"Creating directory: {directory}")
                os.makedirs(directory, exist_ok=True)
            
            # Check if directory is writable
            if not os.access(directory, os.W_OK):
                logger.error(f"Directory is not writable: {directory}")
                return False
                
            logger.info(f"Verified directory: {directory}")
        
        # Check specific files we need to be able to write
        test_files = [
            project_root / "Documentation" / "test_write.tmp",
            project_root / "logs" / "test_write.tmp"
        ]
        
        for test_file in test_files:
            try:
                # Try to write a test file
                with open(test_file, 'w') as f:
                    f.write('test')
                
                # Clean up
                if test_file.exists():
                    os.remove(test_file)
            except Exception as e:
                logger.error(f"Cannot write to location: {test_file}. Error: {e}")
                return False
        
        return True
    except Exception as e:
        logger.error(f"Error verifying visualization paths: {e}")
        return False

def visualize_optimization_space(model, key_vars, filepath=None, title="Optimization Space Visualization", 
                                 highlight_infeasible=True, dpi=300):
    """
    Creates a 2D visualization of the optimization space focusing on two key variables.
    
    Args:
        model: PuLP model to visualize
        key_vars: List of two variable names to use for x and y axes
        filepath: Path to save the visualization image
        title: Title for the plot
        highlight_infeasible: Whether to highlight infeasible regions
        dpi: DPI for the saved image
    
    Returns:
        path: Path to the saved visualization file
    """
    # Verify paths before proceeding
    verify_visualization_paths()
    
    try:
        # Configure matplotlib to use non-interactive backend
        import matplotlib
        matplotlib.use('Agg')
        
        if not isinstance(key_vars, list) or len(key_vars) != 2:
            logger.error("key_vars must be a list of exactly two variable names")
            return None
        
        # Extract variables from model
        all_vars = model.variables()
        var_names = [v.name for v in all_vars]
        
        # Find the requested variables
        x_var_name, y_var_name = key_vars
        
        if x_var_name not in var_names or y_var_name not in var_names:
            logger.error(f"Variables {x_var_name} and/or {y_var_name} not found in model")
            return None
        
        x_var = [v for v in all_vars if v.name == x_var_name][0]
        y_var = [v for v in all_vars if v.name == y_var_name][0]
        
        # Get variable bounds
        x_min = x_var.lowBound if x_var.lowBound is not None else 0
        x_max = x_var.upBound if x_var.upBound is not None else 100
        y_min = y_var.lowBound if y_var.lowBound is not None else 0
        y_max = y_var.upBound if y_var.upBound is not None else 100
        
        # Add some padding
        x_range = x_max - x_min
        y_range = y_max - y_min
        
        x_min = max(0, x_min - 0.1 * x_range)
        x_max = x_max + 0.1 * x_range
        y_min = max(0, y_min - 0.1 * y_range)
        y_max = y_max + 0.1 * y_range
        
        # Set up grid for evaluation
        x_grid = np.linspace(x_min, x_max, 100)
        y_grid = np.linspace(y_min, y_max, 100)
        X, Y = np.meshgrid(x_grid, y_grid)
        
        # Prepare to evaluate constraints
        constraints = list(model.constraints.items())
        n_constraints = len(constraints)
        
        # Create a color map for constraint violations
        colors = [(0, 0.5, 0), (0.5, 1, 0.5), (1, 0, 0)]  # green -> light green -> red
        cmap = LinearSegmentedColormap.from_list('constraint_cmap', colors, N=100)
        
        # We'll create a matrix for each point in the grid counting how many constraints are violated
        violation_matrix = np.zeros_like(X)
        
        # Process each constraint to build the violation matrix
        for i, (name, constraint) in enumerate(constraints):
            try:
                # Try to get constraint data safely
                constraint_dict = {}
                rhs = 0
                
                # Try method 1: Use toDict with safe key access
                if hasattr(constraint, 'toDict'):
                    try:
                        dict_result = constraint.toDict()
                        if isinstance(dict_result, dict):
                            constraint_dict = dict_result.get(0, {})
                            rhs = dict_result.get(1, 0)
                        elif isinstance(dict_result, tuple) and len(dict_result) == 2:
                            constraint_dict, rhs = dict_result
                    except Exception as dict_err:
                        logger.warning(f"Error extracting constraint using toDict: {dict_err}")
                
                # If first method failed, try method 2
                if not constraint_dict and hasattr(constraint, 'expr'):
                    try:
                        expr = constraint.expr
                        constraint_dict = {}
                        
                        # Extract variables and coefficients from the expression
                        if hasattr(expr, 'items'):
                            for var, coef in expr.items():
                                if hasattr(var, 'name'):
                                    constraint_dict[var.name] = coef
                        
                        # Get the constant term if available
                        constant = getattr(expr, 'constant', 0)
                        
                        # Get RHS (usually 0 since the constant is on the LHS)
                        rhs = -constant  # Adjust sign as needed
                    except Exception as expr_err:
                        logger.warning(f"Error extracting constraint using expr: {expr_err}")
                
                # Get coefficients for our variables (if they appear in this constraint)
                x_coef = constraint_dict.get(x_var_name, 0)
                y_coef = constraint_dict.get(y_var_name, 0)
                
                # Skip if neither variable is involved
                if abs(x_coef) < 1e-10 and abs(y_coef) < 1e-10:
                    continue
                
                # Adjust RHS for other variables at their bounds (assuming worst case)
                for var_name, coef in constraint_dict.items():
                    if var_name != x_var_name and var_name != y_var_name:
                        # Find the variable
                        var_matches = [v for v in all_vars if v.name == var_name]
                        if var_matches:
                            var = var_matches[0]
                            
                            # For other variables, assume worst case bound based on coefficient sign
                            # and constraint sense
                            if coef > 0:  # Positive coefficient
                                if getattr(constraint, 'sense', None) == pulp.LpConstraintGE:
                                    rhs -= coef * (var.lowBound if var.lowBound is not None else 0)
                                else:  # <= constraint or equality
                                    rhs -= coef * (var.upBound if var.upBound is not None else 100)
                            else:  # Negative coefficient
                                if getattr(constraint, 'sense', None) == pulp.LpConstraintGE:
                                    rhs -= coef * (var.upBound if var.upBound is not None else 100)
                                else:  # <= constraint or equality
                                    rhs -= coef * (var.lowBound if var.lowBound is not None else 0)
                
                # Now we have a simplified constraint: x_coef*X + y_coef*Y ≤/≥ rhs
                # Evaluate at each grid point
                lhs_value = x_coef * X + y_coef * Y
                
                sense = getattr(constraint, 'sense', None)
                
                if sense == pulp.LpConstraintEQ:  # Equality constraint
                    violation_matrix += np.abs(lhs_value - rhs) > 1e-6  # Small tolerance for floating point
                elif sense == pulp.LpConstraintGE:  # >= constraint
                    violation_matrix += (lhs_value < rhs)
                else:  # <= constraint (default assumption)
                    violation_matrix += (lhs_value > rhs)
            
            except Exception as constraint_err:
                logger.warning(f"Error processing constraint {name}: {str(constraint_err)}")
                # Skip this constraint for visualization
        
        # Normalize the violation matrix for visualization
        # We'll use 0 for feasible (no violations) and 1 for highest number of violations
        max_violations = violation_matrix.max()
        if max_violations > 0:
            violation_matrix = violation_matrix / max_violations
        
        # Create visualization
        plt.figure(figsize=(10, 8))
        
        # Plot feasible/infeasible regions
        if highlight_infeasible:
            plt.imshow(violation_matrix, extent=[x_min, x_max, y_min, y_max], 
                      origin='lower', cmap=cmap, alpha=0.7)
            plt.colorbar(label='Constraint Violations')
        
        # Add constraint lines for key constraints (those involving our two variables)
        for name, constraint in constraints:
            lhs_terms = constraint.toDict()[0]
            rhs = constraint.toDict()[1]
            
            # Only handle constraints with both our variables
            x_coef = lhs_terms.get(x_var_name, 0)
            y_coef = lhs_terms.get(y_var_name, 0)
            
            if abs(x_coef) > 1e-6 and abs(y_coef) > 1e-6:
                # We can visualize this as a line: y = (rhs - x_coef*x) / y_coef
                x_vals = np.linspace(x_min, x_max, 100)
                y_vals = (rhs - x_coef * x_vals) / y_coef
                
                # Only plot if some points are within our viewing range
                if np.any((y_vals >= y_min) & (y_vals <= y_max)):
                    plt.plot(x_vals, y_vals, 'k-', linewidth=1.5, alpha=0.6)
                    
                    # Add annotation at midpoint
                    mid_idx = len(x_vals) // 2
                    mid_x = x_vals[mid_idx]
                    mid_y = y_vals[mid_idx]
                    
                    # Shorten constraint name if needed
                    short_name = name
                    if len(short_name) > 20:
                        short_name = short_name[:17] + "..."
                    
                    plt.annotate(short_name, (mid_x, mid_y), 
                                xytext=(5, 5), textcoords='offset points',
                                fontsize=8, alpha=0.7)
        
        # Add variable bounds
        plt.xlim(x_min, x_max)
        plt.ylim(y_min, y_max)
        
        # Format the plot
        plt.xlabel(f"Variable: {x_var_name}")
        plt.ylabel(f"Variable: {y_var_name}")
        plt.title(title)
        plt.grid(True, linestyle='--', alpha=0.6)
        
        # Add feasible/infeasible legend
        if highlight_infeasible:
            legend_elements = [
                patches.Patch(facecolor=cmap(0), alpha=0.7, label='Feasible Region'),
                patches.Patch(facecolor=cmap(0.5), alpha=0.7, label='Partially Infeasible'),
                patches.Patch(facecolor=cmap(1), alpha=0.7, label='Highly Infeasible')
            ]
            plt.legend(handles=legend_elements, loc='best')
        
        # Highlight the origin
        plt.plot(0, 0, 'ko', markersize=8)
        plt.annotate('Origin (0,0)', (0, 0), xytext=(10, 10), textcoords='offset points')
        
        plt.tight_layout()
        
        # Make sure the output directory exists
        if filepath:
            output_dir = Path(filepath).parent
            os.makedirs(output_dir, exist_ok=True)
            logger.info(f"Ensuring output directory exists: {output_dir}")
        else:
            # Use a more specific default path - ensure Documentation directory exists
            docs_dir = Path(os.path.dirname(os.path.abspath(__file__))).parent.parent.parent / "Documentation"
            os.makedirs(docs_dir, exist_ok=True)
            logger.info(f"Using default output directory: {docs_dir}")
            filepath = docs_dir / "optimization-space-demo.png"
        
        # Save with explicit error handling
        try:
            plt.savefig(filepath, dpi=dpi, bbox_inches='tight')
            logger.info(f"Visualization saved to {filepath}")
        except Exception as e:
            logger.error(f"Failed to save visualization to {filepath}: {str(e)}")
            # Try alternative location if original fails
            try:
                alt_path = Path.home() / "optimization-space-demo.png"
                plt.savefig(alt_path, dpi=dpi, bbox_inches='tight')
                logger.info(f"Visualization saved to alternative location: {alt_path}")
                filepath = alt_path
            except Exception as alt_e:
                logger.error(f"Failed to save to alternative location: {str(alt_e)}")
        
        plt.close()
        return filepath
    except Exception as e:
        logger.error(f"Error in visualization: {str(e)}")
        import traceback
        traceback.print_exc()
        return None

def visualize_engagement_allocation(results_df, target_week=None, filepath=None):
    """
    Creates a visualization of resource allocation across engagements
    
    Args:
        results_df: DataFrame with optimization results
        target_week: The week being visualized
        filepath: Path to save the visualization
        
    Returns:
        path: Path to the saved visualization file
    """
    if results_df is None or results_df.empty:
        logger.error("No results to visualize")
        return None
        
    # Group results by engagement and staff level
    eng_summary = results_df.groupby(['eng_no', 'eng_phase', 'staff_level'])['planned_hours'].sum().reset_index()
    
    # Pivot to get staff levels as columns
    pivot_data = eng_summary.pivot_table(
        index=['eng_no', 'eng_phase'], 
        columns='staff_level', 
        values='planned_hours',
        fill_value=0
    ).reset_index()
    
    # Calculate total hours per engagement and sort
    pivot_data['Total'] = pivot_data.sum(axis=1, numeric_only=True)
    pivot_data = pivot_data.sort_values('Total', ascending=False)
    
    # Prepare for stacked bar chart
    engagements = [f"{en}-{ph}" for en, ph in zip(pivot_data['eng_no'], pivot_data['eng_phase'])]
    staff_levels = [col for col in pivot_data.columns if col not in ['eng_no', 'eng_phase', 'Total']]
    
    # Create visualization
    plt.figure(figsize=(12, 8))
    
    # Create stacked bars
    bottom = np.zeros(len(engagements))
    for level in staff_levels:
        if level in pivot_data.columns:
            values = pivot_data[level].values
            plt.bar(engagements, values, bottom=bottom, label=level)
            bottom += values
    
    # Format the plot
    week_info = f" for week of {target_week}" if target_week else ""
    plt.title(f"Resource Allocation by Engagement{week_info}")
    plt.xlabel("Engagement-Phase")
    plt.ylabel("Allocated Hours")
    plt.legend(title="Staff Level")
    plt.xticks(rotation=45, ha='right')
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    
    # Add totals as text
    for i, total in enumerate(pivot_data['Total']):
        plt.text(i, total + 2, f"{total:.0f}", ha='center', va='bottom', fontweight='bold')
    
    plt.tight_layout()
    
    # Save the visualization
    if filepath:
        plt.savefig(filepath, dpi=300, bbox_inches='tight')
        logger.info(f"Visualization saved to {filepath}")
    else:
        # Default location
        docs_dir = Path(os.getcwd()).parent.parent / "Documentation"
        os.makedirs(docs_dir, exist_ok=True)
        default_path = docs_dir / "engagement-allocation.png"
        plt.savefig(default_path, dpi=300, bbox_inches='tight')
        logger.info(f"Visualization saved to {default_path}")
        filepath = default_path
    
    plt.close()
    return filepath

def create_textual_visualization(model, key_vars, filepath):
    """
    Creates a text-based visualization of the optimization space as a fallback.
    
    Args:
        model: PuLP model to visualize
        key_vars: List of two variable names to analyze
        filepath: Path to save the text file
        
    Returns:
        path: Path to the saved text file
    """
    if not isinstance(key_vars, list) or len(key_vars) < 1:
        logger.error("key_vars must be a list of at least one variable name")
        return None
    
    try:
        # Extract variables from model
        all_vars = model.variables()
        var_names = [v.name for v in all_vars]
        
        # Create a text file with variable and constraint information
        with open(filepath, 'w') as f:
            f.write(f"=== OPTIMIZATION SPACE ANALYSIS ===\n\n")
            f.write(f"Model has {len(model.constraints)} constraints and {len(model.variables())} variables\n\n")
            
            # Analyze key variables
            f.write("=== KEY VARIABLES ===\n\n")
            for var_name in key_vars:
                if var_name in var_names:
                    var = [v for v in all_vars if v.name == var_name][0]
                    f.write(f"Variable: {var_name}\n")
                    f.write(f"  Lower bound: {var.lowBound}\n")
                    f.write(f"  Upper bound: {var.upBound}\n")
                    f.write(f"  Category: {var.cat}\n\n")
            
            # Analyze constraints affecting key variables
            f.write("=== CONSTRAINTS AFFECTING KEY VARIABLES ===\n\n")
            for name, constraint in model.constraints.items():
                lhs_terms = constraint.toDict()[0]
                rhs = constraint.toDict()[1]
                
                # Check if any key variable is in this constraint
                involves_key_var = any(var_name in lhs_terms for var_name in key_vars)
                
                if involves_key_var:
                    f.write(f"Constraint: {name}\n")
                    f.write(f"  Right-hand side: {rhs}\n")
                    f.write("  Left-hand side terms:\n")
                    
                    # List coefficients of variables in this constraint
                    for var_name, coef in lhs_terms.items():
                        if var_name in key_vars:
                            f.write(f"    * {var_name}: {coef} (KEY VARIABLE)\n")
                        else:
                            f.write(f"    * {var_name}: {coef}\n")
                    
                    f.write("\n")
            
            # Summary analysis
            f.write("=== FEASIBILITY ANALYSIS ===\n\n")
            f.write("This text representation provides insight into the optimization space.\n")
            f.write("Check if constraints are compatible with variable bounds.\n")
        
        logger.info(f"Text visualization saved to {filepath}")
        return filepath
    except Exception as e:
        logger.error(f"Error creating text visualization: {str(e)}")
        return None
