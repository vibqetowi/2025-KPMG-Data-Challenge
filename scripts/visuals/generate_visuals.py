#!/usr/bin/env python3

from lp_visualization import generate_lp_visualization

def main():
    """Generate all visualization assets for the project"""
    print("Generating Linear Programming visualization for README...")
    output_path = generate_lp_visualization()
    print(f"Successfully generated visualization at {output_path}")
    print("Done!")

if __name__ == "__main__":
    main()
