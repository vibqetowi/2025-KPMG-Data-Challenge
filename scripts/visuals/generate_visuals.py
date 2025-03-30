#!/usr/bin/env python3

import sys
import os
from pathlib import Path

# Add parent directories to path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
sys.path.append(str(project_root))

from lp_visualization import generate_lp_visualization
from scripts.shared.config import PROJECT_ROOT

def main():
    """Generate all visualization assets for the project"""
    print("Generating Linear Programming visualization for Appendix 2...")
    output_path = generate_lp_visualization()
    
    # Get relative path for README reference
    rel_path = output_path.relative_to(PROJECT_ROOT)
    
    print(f"Successfully generated visualization at {output_path}")
    print(f"Reference in README with: ![Linear Programming Visualization](./{rel_path})")
    print("Done!")

if __name__ == "__main__":
    main()
