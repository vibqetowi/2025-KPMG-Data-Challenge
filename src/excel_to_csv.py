import pandas as pd
import os
import argparse

def excel_to_csv(excel_file, output_dir=None):
    """
    Extract all sheets from an Excel file and save each as a CSV file.
    
    Parameters:
    excel_file (str): Path to the Excel file
    output_dir (str): Directory to save CSV files, defaults to same directory as Excel file
    """
    # If no output directory specified, use the same directory as the Excel file
    if output_dir is None:
        output_dir = os.path.dirname(os.path.abspath(excel_file))
    
    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # Get the base name of the Excel file without extension
    base_name = os.path.splitext(os.path.basename(excel_file))[0]
    
    # Read the Excel file
    excel = pd.ExcelFile(excel_file)
    
    # Extract each sheet
    for sheet_name in excel.sheet_names:
        # Read the sheet
        df = excel.parse(sheet_name)
        
        # Clean the sheet name for use as a filename
        clean_sheet_name = "".join(c if c.isalnum() else "_" for c in sheet_name)
        
        # Create CSV filename
        csv_filename = f"{base_name}_{clean_sheet_name}.csv"
        csv_path = os.path.join(output_dir, csv_filename)
        
        # Save to CSV
        df.to_csv(csv_path, index=False)
        print(f"Sheet '{sheet_name}' saved as '{csv_path}'")

def main():
    parser = argparse.ArgumentParser(description='Convert Excel sheets to CSV files')
    parser.add_argument('excel_file', help='Path to the Excel file')
    parser.add_argument('--output-dir', help='Directory to save CSV files')
    
    args = parser.parse_args()
    
    excel_to_csv(args.excel_file, args.output_dir)

if __name__ == "__main__":
    main()
