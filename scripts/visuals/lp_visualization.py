import matplotlib.pyplot as plt
import numpy as np
import os
from pathlib import Path

def generate_lp_visualization():
    """
    Generates a visualization of a simplified 2D linear programming problem
    to illustrate the resource optimization concept for stakeholders.
    """
    # Create figure and axis
    plt.figure(figsize=(12, 8))
    
    # Set up the plot
    ax = plt.gca()
    ax.set_xlim(0, 12)
    ax.set_ylim(0, 10)
    
    # Title and labels
    plt.title('Resource Optimization using Linear Programming (MILP)', fontsize=16, fontweight='bold')
    plt.xlabel('Hours allocated to Engagement A', fontsize=14)
    plt.ylabel('Hours allocated to Engagement B', fontsize=14)
    
    # Create constraint lines
    x = np.linspace(0, 12, 1000)
    
    # Consultant capacity constraint: x + y <= 10 (total hours)
    y1 = 10 - x
    plt.plot(x, y1, 'r-', linewidth=2, label='Consultant Capacity Constraint')
    
    # Engagement A minimum hours: x >= 3
    y2 = np.ones_like(x) * 10
    engagement_a_min = 3
    plt.axvline(x=engagement_a_min, color='g', linestyle='-', linewidth=2, 
                label='Engagement A Minimum Requirement')
    
    # Engagement B minimum hours: y >= 2
    engagement_b_min = 2
    plt.axhline(y=engagement_b_min, color='b', linestyle='-', linewidth=2,
                label='Engagement B Minimum Requirement')
    
    # Staffing ratio constraint: y = 0.7x (practice ratio)
    y3 = 0.7 * x
    plt.plot(x, y3, 'purple', linestyle='--', linewidth=2, label='Staffing Ratio Constraint')
    
    # Fill feasible region
    feasible_x = np.linspace(engagement_a_min, 12, 100)
    
    # Upper boundary based on capacity constraint
    upper_y = np.minimum(10 - feasible_x, 10)
    # Lower boundary based on minimum requirement and ratio constraint
    lower_y = np.maximum(0.7 * feasible_x, engagement_b_min)
    
    # Only keep points where lower_y <= upper_y
    valid_indices = lower_y <= upper_y
    if any(valid_indices):
        feasible_x = feasible_x[valid_indices]
        upper_y = upper_y[valid_indices]
        lower_y = lower_y[valid_indices]
        
        plt.fill_between(feasible_x, lower_y, upper_y, color='lightgreen', alpha=0.5, label='Feasible Region')
    
    # Optimal solution
    optimal_x = 5.9  # Based on objective function with higher weight on engagement A
    optimal_y = 4.1  # Corresponding y value
    
    plt.scatter(optimal_x, optimal_y, s=200, c='gold', edgecolor='black', zorder=5, label='Optimal Solution')
    
    # Add an arrow towards the optimal solution
    plt.annotate('Maximize: 0.6x + 0.4y\n(weighted by engagement priorities)',
                xy=(optimal_x, optimal_y), xytext=(3, 8),
                fontsize=12, fontweight='bold',
                arrowprops=dict(facecolor='black', shrink=0.05, width=1.5))
    
    # Additional annotations
    plt.text(1, 9, 'Total capacity constraint:\nConsultant can work max 10 hours', 
             fontsize=11, color='red', fontweight='bold')
    
    plt.text(7.5, 2, 'Staffing mix constraint:\nMaintain certain ratio between practices', 
             fontsize=11, color='purple', fontweight='bold')
    
    # Add legend
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=3, fontsize=12)
    
    # Grid for better readability
    plt.grid(True, linestyle='--', alpha=0.7)
    
    # Save the figure
    project_root = Path(os.path.dirname(os.path.abspath(__file__))).parent.parent
    img_dir = project_root / "img"
    os.makedirs(img_dir, exist_ok=True)
    
    output_path = img_dir / "lp_optimization_visualization.png"
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    
    print(f"Linear programming visualization saved to {output_path}")
    
    # Close the plot to free memory
    plt.close()
    
    return output_path

if __name__ == "__main__":
    generate_lp_visualization()
