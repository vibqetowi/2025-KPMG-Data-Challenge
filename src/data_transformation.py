import os
import pandas as pd
from pathlib import Path

# Hardcoded file paths
BUDGET_CSV = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/KPMG Case Data_Budget.csv')
STAFFING_2024_CSV = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/KPMG Case Data_Staffing___2024.csv')
STAFFING_2025_CSV = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/KPMG Case Data_Staffing___2025.csv')
TIME_CSV = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/KPMG Case Data_TIME.csv')
DICTIONARY_CSV = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/KPMG Case Data_Dictionnaire___Dictionary_.csv')

# Output directory
OUTPUT_DIR = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/transformed')

class DataTransformer:
    def __init__(self):
        """
        Initialize the data transformer with hardcoded file paths and output directory.
        """
        # Ensure output directory exists
        OUTPUT_DIR.mkdir(exist_ok=True, parents=True)
        
        # Define table schemas based on DDL with proper primary keys
        self.schemas = {
            'employees': ['personnel_no', 'employee_name', 'staff_level', 'is_external'],  # PK: personnel_no
            'clients': ['client_no', 'client_name'],  # PK: client_no
            'engagements': ['eng_no', 'eng_description', 'client_no'],  # PK: eng_no
            'phases': ['eng_no', 'eng_phase', 'phase_description', 'budget'],  # Composite PK: (eng_no, eng_phase)
            'staffing': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'],  # PK: id
            'timesheets': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'work_date', 'hours', 
                          'time_entry_date', 'posting_date', 'charge_out_rate', 'std_price', 'adm_surcharge'],  # PK: id
            'dictionary': ['key', 'description']  # PK: key - matching DDL schema
        }
        
        # Define primary keys for each table
        self.primary_keys = {
            'employees': ['personnel_no'],
            'clients': ['client_no'],
            'engagements': ['eng_no'],
            'phases': ['eng_no', 'eng_phase'],  # Composite primary key
            'staffing': ['id'],
            'timesheets': ['id'],
            'dictionary': ['key']
        }
        
        # Initialize DataFrames for each table
        self.dfs = {
            'employees': pd.DataFrame(columns=self.schemas['employees']),
            'clients': pd.DataFrame(columns=self.schemas['clients']),
            'engagements': pd.DataFrame(columns=self.schemas['engagements']),
            'phases': pd.DataFrame(columns=self.schemas['phases']),
            'staffing': pd.DataFrame(columns=self.schemas['staffing']),
            'timesheets': pd.DataFrame(columns=self.schemas['timesheets']),
            'dictionary': pd.DataFrame(columns=self.schemas['dictionary'])
        }
    
    def process_budget_data(self):
        """
        Process the budget CSV to populate engagements and phases DataFrames.
        """
        if not os.path.exists(BUDGET_CSV):
            print(f"Warning: Budget CSV file not found at {BUDGET_CSV}")
            return
        
        try:
            # Read budget CSV
            df_budget = pd.read_csv(BUDGET_CSV, encoding='utf-8-sig')
            
            # Process engagements table
            df_engagements = pd.DataFrame()
            df_engagements['eng_no'] = df_budget['Code projet'].astype(str)
            df_engagements['eng_description'] = df_budget['Nom de projet']
            df_engagements['client_no'] = None  # Will be updated from staffing data
            
            # Remove duplicates based on primary key
            df_engagements = df_engagements.drop_duplicates('eng_no')
            
            # Update the engagements DataFrame
            self.dfs['engagements'] = pd.concat([self.dfs['engagements'], df_engagements])
            self.dfs['engagements'] = self.dfs['engagements'].drop_duplicates(subset=['eng_no'], keep='last')
            
            # Process phases table - respecting composite primary key
            df_phases = pd.DataFrame()
            df_phases['eng_no'] = df_budget['Code projet'].astype(str)
            df_phases['eng_phase'] = df_budget['Code phase'].astype(int)
            df_phases['phase_description'] = df_budget['Phase Projet']
            df_phases['budget'] = df_budget['Budget']
            
            # Remove duplicates based on composite primary key
            df_phases = df_phases.drop_duplicates(subset=['eng_no', 'eng_phase'])
            
            # Update the phases DataFrame
            self.dfs['phases'] = pd.concat([self.dfs['phases'], df_phases])
            self.dfs['phases'] = self.dfs['phases'].drop_duplicates(subset=['eng_no', 'eng_phase'], keep='last')
            
            print(f"Processed budget data: {len(df_engagements)} engagements, {len(df_phases)} phases")
        
        except Exception as e:
            print(f"Error processing budget CSV: {e}")
    
    def process_staffing_data(self):
        """
        Process the staffing CSVs to populate employees, clients, and staffing DataFrames.
        """
        staffing_files = [STAFFING_2024_CSV, STAFFING_2025_CSV]
        staffing_id = 1
        engagement_client_map = {}  # To store the mapping of engagements to clients
        
        # Create an empty staffing DataFrame with correct types
        staffing_df = pd.DataFrame(columns=self.schemas['staffing'])
        
        # Process each staffing file
        for staffing_file in staffing_files:
            if not os.path.exists(staffing_file):
                print(f"Warning: Staffing file not found at {staffing_file}")
                continue
                
            try:
                print(f"Processing staffing file: {staffing_file}")
                df_staff = pd.read_csv(staffing_file, encoding='utf-8-sig')
                
                # Extract unique employees
                temp_employees = df_staff[['Personnel No.', 'Employee Name', 'Staff Level']].copy()
                temp_employees.columns = ['personnel_no', 'employee_name', 'staff_level']
                temp_employees['is_external'] = 0  # Assume internal by default
                temp_employees = temp_employees.drop_duplicates('personnel_no')
                
                # Update the employees DataFrame - respecting primary key
                self.dfs['employees'] = pd.concat([self.dfs['employees'], temp_employees])
                self.dfs['employees'] = self.dfs['employees'].drop_duplicates(subset=['personnel_no'], keep='last')
                
                # Extract unique clients
                temp_clients = df_staff[['Client No.', 'Client Name']].copy()
                temp_clients.columns = ['client_no', 'client_name']
                temp_clients = temp_clients.drop_duplicates('client_no')
                
                # Update the clients DataFrame - respecting primary key
                self.dfs['clients'] = pd.concat([self.dfs['clients'], temp_clients])
                self.dfs['clients'] = self.dfs['clients'].drop_duplicates(subset=['client_no'], keep='last')
                
                # Build engagement to client mapping
                for _, row in df_staff.iterrows():
                    engagement_client_map[str(row['Eng. No.'])] = row['Client No.']
                
                # Process staffing data - columns after 'Staff Level' are week dates
                for _, row in df_staff.iterrows():
                    for col in df_staff.columns[9:]:  # Week dates start from column 10
                        try:
                            planned_hours = float(row[col])
                            if planned_hours > 0:
                                week_date = pd.to_datetime(col.replace(' 00:00:00', ''))
                                
                                # Create new row dictionary
                                new_row_data = {
                                    'id': staffing_id,
                                    'personnel_no': row['Personnel No.'],
                                    'eng_no': row['Eng. No.'],
                                    'eng_phase': row['Eng. Phase'],
                                    'week_start_date': week_date,
                                    'planned_hours': planned_hours
                                }
                                
                                # Append to the staffing DataFrame, ensuring unique ID (primary key)
                                staffing_df = pd.concat([staffing_df, pd.DataFrame([new_row_data])], ignore_index=True)
                                staffing_id += 1
                        except Exception as e:
                            # Skip problematic entries
                            continue
            
            except Exception as e:
                print(f"Error processing staffing file {staffing_file}: {e}")
        
        # Update staffing DataFrame - should already have unique IDs
        self.dfs['staffing'] = staffing_df
        
        # Update engagements with client information
        if not self.dfs['engagements'].empty:
            for idx, row in self.dfs['engagements'].iterrows():
                eng_no = str(row['eng_no'])
                if eng_no in engagement_client_map:
                    self.dfs['engagements'].at[idx, 'client_no'] = engagement_client_map[eng_no]
            
            # Make sure engagements respect primary key
            self.dfs['engagements'] = self.dfs['engagements'].drop_duplicates(subset=['eng_no'], keep='last')
    
    def process_timesheet_data(self):
        """
        Process the timesheet CSV to populate the timesheets DataFrame.
        """
        if not os.path.exists(TIME_CSV):
            print(f"Warning: Timesheet file not found at {TIME_CSV}")
            return
            
        try:
            print(f"Processing timesheet file: {TIME_CSV}")
            # Skip empty files
            if os.path.getsize(TIME_CSV) == 0:
                print(f"Warning: Timesheet file {TIME_CSV} is empty")
                return
            
            # Try different encodings
            try:
                df_time = pd.read_csv(TIME_CSV, encoding='utf-8-sig')
            except:
                try:
                    df_time = pd.read_csv(TIME_CSV, encoding='latin1')
                except:
                    df_time = pd.read_csv(TIME_CSV, encoding='cp1252')
            
            # Check if file has content
            if df_time.empty:
                print(f"Warning: No data in timesheet file {TIME_CSV}")
                return
            
            # Map column names based on the actual columns in the file
            column_mapping = {
                'Personnel No.': 'personnel_no',
                'Work Date': 'work_date',
                'Hours': 'hours',
                'Eng. No.': 'eng_no',
                'Eng. Phase': 'eng_phase',
                'Time Entry Date': 'time_entry_date',
                'Posting Date': 'posting_date',
                'Charge-Out Rate': 'charge_out_rate',
                'Std. Price': 'std_price',
                'Adm. Surcharge': 'adm_surcharge'
            }
            
            # Check for required columns
            missing_columns = [col for col in column_mapping.keys() if col not in df_time.columns]
            if missing_columns:
                print(f"Warning: Missing columns in {TIME_CSV}: {missing_columns}")
                print(f"Available columns: {df_time.columns.tolist()}")
                return
            
            # Rename columns
            df_time_mapped = df_time.rename(columns=column_mapping)
            
            # Add ID column - ensuring it's unique
            df_time_mapped['id'] = range(1, len(df_time_mapped) + 1)
            
            # Initialize missing columns with None
            for col in self.schemas['timesheets']:
                if col not in df_time_mapped.columns:
                    df_time_mapped[col] = None
            
            # Select only columns in our schema
            df_time_mapped = df_time_mapped[self.schemas['timesheets']]
            
            # Append to timesheets DataFrame
            self.dfs['timesheets'] = pd.concat([self.dfs['timesheets'], df_time_mapped])
            
            # Ensure id is unique (primary key)
            self.dfs['timesheets'] = self.dfs['timesheets'].drop_duplicates(subset=['id'], keep='last')
            
            print(f"Processed {len(df_time_mapped)} timesheet records")
            
        except Exception as e:
            print(f"Error processing timesheet file {TIME_CSV}: {e}")
    
    def process_dictionary_data(self):
        """
        Process the dictionary CSV to populate the dictionary DataFrame.
        """
        if not os.path.exists(DICTIONARY_CSV):
            print(f"Warning: Dictionary file not found at {DICTIONARY_CSV}")
            return
        
        try:
            # Read dictionary CSV
            df_dict = pd.read_csv(DICTIONARY_CSV, encoding='utf-8-sig')
            
            # Create dictionary DataFrame
            dict_rows = []
            
            for _, row in df_dict.iterrows():
                key = row.get('Key', '').strip()
                description = row.get(' Description', '').strip() if ' Description' in df_dict.columns else row.get('Description', '').strip()
                
                if key and description:
                    dict_rows.append({
                        'key': key,
                        'description': description
                    })
            
            # Update dictionary DataFrame
            dict_df = pd.DataFrame(dict_rows)
            
            # Ensure key is unique (primary key)
            dict_df = dict_df.drop_duplicates(subset=['key'], keep='last')
            
            self.dfs['dictionary'] = pd.concat([self.dfs['dictionary'], dict_df])
            self.dfs['dictionary'] = self.dfs['dictionary'].drop_duplicates(subset=['key'], keep='last')
            
            print(f"Processed {len(dict_rows)} dictionary entries")
            
        except Exception as e:
            print(f"Error processing dictionary file: {e}")
    
    def save_transformed_data(self):
        """
        Save all DataFrames to CSV files in the output directory.
        """
        for table_name, df in self.dfs.items():
            if not df.empty:
                # Final check to ensure primary keys are respected
                pk_columns = self.primary_keys.get(table_name, [])
                if pk_columns:
                    df = df.drop_duplicates(subset=pk_columns, keep='last')
                    self.dfs[table_name] = df
                
        
        # Save all transformed CSVs
        self.save_transformed_data()
        
        print("Data transformation complete!")

def main():
    """
    Main function to run the data transformer.
    """
    try:
        transformer = DataTransformer()
        transformer.transform_all_data()
    except Exception as e:
        print(f"Error in data transformation: {e}")
        raise

if __name__ == "__main__":
    main()
