import os
import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime
import sys
import logging

# Add parent directories to path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent.parent
shared_dir = project_root / "scripts" / "shared"
sys.path.append(str(shared_dir))

# Import from shared modules
from config import CSV_DUMP_DIR, TRANSFORMED_DIR, RAW_FILE_MAP

# Import local modules
from data_mocking import DataMocker

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# File paths using shared config
BUDGET_CSV = CSV_DUMP_DIR / RAW_FILE_MAP["budget"]
STAFFING_2024_CSV = CSV_DUMP_DIR / RAW_FILE_MAP["staffing"]
STAFFING_2025_CSV = CSV_DUMP_DIR / "KPMG Case Data_Staffing___2025.csv"  # Add to RAW_FILE_MAP if needed
TIME_CSV = CSV_DUMP_DIR / RAW_FILE_MAP["timesheets"]
DICTIONARY_CSV = CSV_DUMP_DIR / RAW_FILE_MAP["dictionary"]

# Output directory
OUTPUT_DIR = TRANSFORMED_DIR

class DataTransformer:
    def __init__(self):
        """
        Initialize the data transformer with file paths and schema definitions
        based on the SQL DDL structure.
        """
        # Ensure output directory exists
        OUTPUT_DIR.mkdir(exist_ok=True, parents=True)
        
        # Define table schemas based on DDL with proper types
        self.schemas = {
            'practices': {
                'columns': ['practice_id', 'practice_name', 'description'],
                'dtypes': {'practice_id': 'int', 'practice_name': 'str', 'description': 'str'}
            },
            'employees': {
                'columns': ['personnel_no', 'employee_name', 'staff_level', 'is_external', 'employment_basis', 'practice_id'],
                'dtypes': {'personnel_no': 'int', 'employee_name': 'str', 'staff_level': 'str', 
                          'is_external': 'bool', 'employment_basis': 'float', 'practice_id': 'int'}
            },
            'clients': {
                'columns': ['client_no', 'client_name'],
                'dtypes': {'client_no': 'int', 'client_name': 'str'}
            },
            'engagements': {
                'columns': ['eng_no', 'eng_description', 'client_no', 'primary_practice_id', 
                           'start_date', 'end_date', 'actual_end_date', 'strategic_weight', 'risk_coefficient'],
                'dtypes': {'eng_no': 'int64', 'eng_description': 'str', 'client_no': 'int',
                          'primary_practice_id': 'int', 'start_date': 'datetime64[ns]', 'end_date': 'datetime64[ns]', 
                          'actual_end_date': 'datetime64[ns]', 'strategic_weight': 'float', 'risk_coefficient': 'float'}
            },
            'phases': {
                'columns': ['eng_no', 'eng_phase', 'phase_description', 'budget', 
                           'start_date', 'end_date', 'actual_end_date'],
                'dtypes': {'eng_no': 'int64', 'eng_phase': 'int', 'phase_description': 'str', 'budget': 'float',
                          'start_date': 'datetime64[ns]', 'end_date': 'datetime64[ns]', 
                          'actual_end_date': 'datetime64[ns]'}
            },
            'staffing': {
                'columns': ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'],  # Removed 'id'
                'dtypes': {'personnel_no': 'int', 'eng_no': 'int64', 
                          'eng_phase': 'int', 'week_start_date': 'datetime64[ns]', 'planned_hours': 'float'}
            },
            'timesheets': {
                'columns': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'work_date', 'hours', 
                           'time_entry_date', 'posting_date', 'charge_out_rate', 'std_price', 'adm_surcharge'],
                'dtypes': {'id': 'int', 'personnel_no': 'int', 'eng_no': 'int64', 'eng_phase': 'int',
                          'work_date': 'datetime64[ns]', 'hours': 'float', 'time_entry_date': 'datetime64[ns]',
                          'posting_date': 'datetime64[ns]', 'charge_out_rate': 'float', 
                          'std_price': 'float', 'adm_surcharge': 'float'}
            },
            'dictionary': {
                'columns': ['key', 'description'],
                'dtypes': {'key': 'str', 'description': 'str'}
            },
            'vacations': {
                'columns': ['personnel_no', 'start_date', 'end_date'],
                'dtypes': {'personnel_no': 'int', 'start_date': 'datetime64[ns]', 'end_date': 'datetime64[ns]'}
            },
            'charge_out_rates': {
                'columns': ['eng_no', 'personnel_no', 'standard_chargeout_rate'],
                'dtypes': {'eng_no': 'int64', 'personnel_no': 'int', 'standard_chargeout_rate': 'float'}
            },
            'staffing_prediction': {
                'columns': ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'],
                'dtypes': {'personnel_no': 'int', 'eng_no': 'int64', 
                          'eng_phase': 'int', 'week_start_date': 'datetime64[ns]', 'planned_hours': 'float'}
            },
            'optimization_parameters': {
                'columns': ['parameter_key', 'parameter_value', 'description', 'last_updated', 'updated_by'],
                'dtypes': {'parameter_key': 'str', 'parameter_value': 'float', 'description': 'str', 
                          'last_updated': 'datetime64[ns]', 'updated_by': 'int'}
            }
        }
        
        # Define primary keys for each table as per DDL
        self.primary_keys = {
            'practices': ['practice_id'],
            'employees': ['personnel_no'],
            'clients': ['client_no'],
            'engagements': ['eng_no'],
            'phases': ['eng_no', 'eng_phase'],  # Composite primary key
            'staffing': ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date'],  # Composite primary key
            'timesheets': ['id'],  # Auto-generated by DB
            'dictionary': ['key'],
            'vacations': ['personnel_no', 'start_date'],  # Composite primary key
            'charge_out_rates': ['eng_no', 'personnel_no'],  # Composite primary key
            'optimization_parameters': ['parameter_key']  # Primary key
        }
        
        # Define foreign key relationships as per DDL
        self.foreign_keys = {
            'employees': [('practice_id', 'practices', 'practice_id')],
            'engagements': [
                ('client_no', 'clients', 'client_no'),
                ('primary_practice_id', 'practices', 'practice_id')
            ],
            'phases': [('eng_no', 'engagements', 'eng_no')],
            'staffing': [
                ('personnel_no', 'employees', 'personnel_no'),
                (('eng_no', 'eng_phase'), 'phases', ('eng_no', 'eng_phase'))
            ],
            'timesheets': [
                ('personnel_no', 'employees', 'personnel_no'),
                (('eng_no', 'eng_phase'), 'phases', ('eng_no', 'eng_phase'))
            ],
            'vacations': [('personnel_no', 'employees', 'personnel_no')],
            'charge_out_rates': [
                ('eng_no', 'engagements', 'eng_no'),
                ('personnel_no', 'employees', 'personnel_no')
            ],
            'optimization_parameters': [('updated_by', 'employees', 'personnel_no')]
        }
        
        # Columns generated by the database (IDENTITY in SQL Server)
        self.db_generated_columns = {
            'timesheets': ['id']
        }
        
        # Initialize empty DataFrames for each table
        self.dfs = {}
        for table, schema in self.schemas.items():
            self.dfs[table] = pd.DataFrame(columns=schema['columns'])
        
        # Initialize data mocker
        self.mocker = DataMocker()
        
        # Create default data using mocker
        self.dfs['practices'] = self.mocker.create_default_practices()
        self.dfs['clients'] = self.mocker.create_default_clients()
        self.dfs['employees'] = self.mocker.create_default_employees()
    
    def _clean_dataframe(self, df, table_name):
        """
        Clean and validate a dataframe according to its schema.
        """
        schema = self.schemas[table_name]
        columns = schema['columns']
        dtypes = schema['dtypes']
        
        # Select only columns defined in the schema
        df = df.reindex(columns=columns)
        

        # Replace empty strings with None
        for col in df.columns:
            if df[col].dtype == 'object':
                df[col] = df[col].replace('', None)
        
        # DO NOT set NULL for database-generated columns anymore
        # We're now generating IDs in our processing steps
        
        # Convert data types based on schema
        for col, dtype in dtypes.items():
            if col in df.columns:
                try:
                    # Don't convert ID columns if they already contain sequential values
                    if (col == 'id' and table_name in self.db_generated_columns and 
                        not df[col].isna().all()):
                        print(f"Preserving generated ID values in {table_name}")
                        continue
                        
                    if dtype in ('datetime64[ns]', 'datetime'):
                        df[col] = pd.to_datetime(df[col], errors='coerce')
                    elif dtype == 'int' or dtype == 'int64':
                        # Convert to float first to handle NaNs, then to Int64 (nullable integer)
                        df[col] = pd.to_numeric(df[col], errors='coerce')
                        df[col] = df[col].astype('Int64')
                    elif dtype == 'float':
                        df[col] = pd.to_numeric(df[col], errors='coerce')
                    elif dtype == 'bool':
                        df[col] = df[col].astype(bool)
                except Exception as e:
                    print(f"Error converting {col} to {dtype} in {table_name}: {e}")
        
        return df
    
    def _drop_null_columns(self, df, table_name, exclude_columns=None):
        """
        Drop columns that are entirely NULL, except those in exclude_columns
        Returns the DataFrame with NULL columns removed
        """
        if exclude_columns is None:
            exclude_columns = []
        
        # Ensure exclude_columns is a list
        if not isinstance(exclude_columns, list):
            exclude_columns = [exclude_columns]
        
        # Add primary key columns to exclude_columns
        pk_columns = self.primary_keys.get(table_name, [])
        if not isinstance(pk_columns, list):
            pk_columns = [pk_columns]
        exclude_columns.extend(pk_columns)
        
        # Find columns that are all NULL and not in exclude_columns
        null_columns = []
        for col in df.columns:
            if col not in exclude_columns and df[col].isna().all():
                null_columns.append(col)
        
        if null_columns:
            print(f"Dropping all-NULL columns from {table_name} before generating values: {null_columns}")
            df = df.drop(columns=null_columns)
        
        return df

    def _standardize_personnel_no(self, personnel_no):
        """
        Standardize personnel number format by removing leading/trailing zeros.
        
        Args:
            personnel_no: The personnel number to standardize
            
        Returns:
            Standardized personnel number as integer
        """
        if pd.isna(personnel_no):
            return None
            
        try:
            # Handle float values by converting to integer first
            if isinstance(personnel_no, float):
                personnel_no = int(personnel_no)
                
            # Convert to string to handle various input formats
            personnel_str = str(personnel_no).strip()
            
            # Remove any leading zeros and decimal points
            personnel_str = personnel_str.lstrip('0')
            if '.' in personnel_str:
                personnel_str = personnel_str.split('.')[0]
                
            # If empty after stripping (all zeros), return 0
            if not personnel_str:
                return 0
                
            # Convert to integer
            return int(personnel_str)
        except ValueError as e:
            print(f"Warning: Could not convert personnel number '{personnel_no}' to integer: {e}")
            return None
        except Exception as e:
            print(f"Error processing personnel number '{personnel_no}': {e}")
            return None
    
    def _standardize_personnel_numbers_in_df(self, df, column='personnel_no'):
        """
        Apply personnel number standardization to a DataFrame column.
        
        Args:
            df: DataFrame to process
            column: Column name containing personnel numbers
            
        Returns:
            DataFrame with standardized personnel numbers
        """
        if column in df.columns:
            df[column] = df[column].apply(self._standardize_personnel_no)
        return df

    def process_budget_data(self):
        """
        Process budget data to populate engagements and phases tables.
        """
        if not os.path.exists(BUDGET_CSV):
            print(f"Warning: Budget CSV file not found at {BUDGET_CSV}")
            return
        
        try:
            print(f"Processing budget file: {BUDGET_CSV}")
            df_budget = pd.read_csv(BUDGET_CSV, encoding='utf-8-sig')
            
            # First, extract client mapping from staffing files
            eng_client_map = self._extract_engagement_client_mapping()
            
            # Get default client IDs from our mocked clients as fallback
            client_ids = self.dfs['clients']['client_no'].tolist()
            default_client_id = client_ids[0] if client_ids else None
            
            # Process engagements - only include non-NULL fields and required keys
            engagements = []
            phases = []
            
            for _, row in df_budget.iterrows():
                # Extract engagement data
                eng_no = row['Code projet']
                eng_description = row['Nom de projet']
                
                # Get client number from mapping or default to first client
                client_no = eng_client_map.get(eng_no, default_client_id)
                
                # Generate synthetic dates using DataMocker
                start_date = pd.Timestamp('2025-01-01')  # Default start date
                end_date = pd.Timestamp('2025-12-31')    # Default end date
                
                engagement = {
                    'eng_no': eng_no,
                    'eng_description': eng_description,
                    'client_no': client_no,
                    'primary_practice_id': 1,  # Default to SAP practice
                    'start_date': start_date,
                    'end_date': end_date,
                    'strategic_weight': 1.0,
                    'risk_coefficient': 1.0
                }
                
                engagements.append(engagement)
                
                # Extract phase data with dates
                phase_start = start_date
                phase_end = end_date
                
                phases.append({
                    'eng_no': eng_no,
                    'eng_phase': int(row['Code phase']),
                    'phase_description': row['Phase Projet'],
                    'budget': float(row['Budget']) if pd.notna(row['Budget']) else None,
                    'start_date': phase_start,
                    'end_date': phase_end,
                    'actual_end_date': None
                })
            
            # Convert to DataFrames
            if engagements:
                df_engagements = pd.DataFrame(engagements)
                df_engagements = df_engagements.drop_duplicates(subset=['eng_no'])
                self.dfs['engagements'] = df_engagements
                
            if phases:
                df_phases = pd.DataFrame(phases)
                df_phases = df_phases.drop_duplicates(subset=['eng_no', 'eng_phase'])
                self.budget_phases = df_phases  # Store for later merging
                self.dfs['phases'] = df_phases
            
            print(f"Processed budget data: {len(engagements)} engagements, {len(phases)} phases")
            
        except Exception as e:
            print(f"Error processing budget data: {str(e)}")
            import traceback
            traceback.print_exc()
        
    def _extract_engagement_client_mapping(self):
        """
        Extract mapping between engagement numbers and client numbers from staffing files.
        """
        eng_client_map = {}
        staffing_files = [STAFFING_2024_CSV, STAFFING_2025_CSV]
        
        for staffing_file in staffing_files:
            if not os.path.exists(staffing_file):
                continue
                
            try:
                df_staff = pd.read_csv(staffing_file, encoding='utf-8-sig')
                
                # Create mapping from eng_no to client_no
                for _, row in df_staff.iterrows():
                    eng_no = row['Eng. No.']
                    client_no = row['Client No.']
                    
                    if pd.notna(eng_no) and pd.notna(client_no):
                        eng_client_map[eng_no] = client_no
            except:
                pass
                
        return eng_client_map

    def extract_phases_from_staffing(self):
        """
        Extract engagement phase information from staffing data to ensure 
        phases referenced in staffing records are present in the phases table.
        """
        staffing_files = [STAFFING_2024_CSV, STAFFING_2025_CSV]
        
        if not any(os.path.exists(f) for f in staffing_files):
            print("No staffing files found to extract phases")
            return pd.DataFrame()
            
        # Extract unique engagement and phase combinations from staffing data
        staffing_phases = pd.DataFrame()
        
        for file in staffing_files:
            if not os.path.exists(file):
                continue
                
            try:
                df = pd.read_csv(file, encoding='utf-8-sig')
                phases = df[['Eng. No.', 'Eng. Phase']].drop_duplicates()
                phases = phases.rename(columns={'Eng. No.': 'eng_no', 'Eng. Phase': 'eng_phase'})
                staffing_phases = pd.concat([staffing_phases, phases])
            except Exception as e:
                print(f"Error extracting phases from {file}: {e}")
        
        if staffing_phases.empty:
            return pd.DataFrame()
            
        # Deduplicate
        staffing_phases = staffing_phases.drop_duplicates()
        
        # Check which phases exist in the phases table
        existing_phases = pd.DataFrame()
        if 'phases' in self.dfs and not self.dfs['phases'].empty:
            existing_phases = self.dfs['phases'][['eng_no', 'eng_phase']]
        
        # Create composite key for comparison
        staffing_phases['key'] = staffing_phases['eng_no'].astype(str) + '_' + staffing_phases['eng_phase'].astype(str)
        
        if not existing_phases.empty:
            existing_phases['key'] = existing_phases['eng_no'].astype(str) + '_' + existing_phases['eng_phase'].astype(str)
            
            # Find missing phases
            missing_keys = set(staffing_phases['key']) - set(existing_phases['key'])
            missing_phases = staffing_phases[staffing_phases['key'].isin(missing_keys)]
        else:
            missing_phases = staffing_phases
        
        if not missing_phases.empty:
            print(f"Found {len(missing_phases)} phases in staffing data that need to be added to phases table")
            
            # Create a complete dictionary for each missing phase
            phase_records = []
            
            for _, row in missing_phases.iterrows():
                phase_dict = {
                    'eng_no': row['eng_no'],
                    'eng_phase': row['eng_phase'],
                    'phase_description': 'Auto-generated from staffing data',
                    'budget': None,
                    'start_date': pd.Timestamp('2025-01-01'),
                    'end_date': pd.Timestamp('2025-12-31'),
                    'actual_end_date': None
                }
                phase_records.append(phase_dict)
            
            # Create a new DataFrame with all required columns
            result_df = pd.DataFrame(phase_records)
            
            # Drop the key column if it exists
            if 'key' in result_df.columns:
                result_df = result_df.drop(columns=['key'])
            
            # Store phases from staffing for later merging
            self.staffing_phases = result_df
            
            return result_df
        
        # Return an empty DataFrame with the correct columns
        return pd.DataFrame(columns=['eng_no', 'eng_phase', 'phase_description', 
                                   'budget', 'start_date', 'end_date', 'actual_end_date'])

    def _merge_phase_info(self, budget_phases, staffing_phases):
        """
        Merge phase information from budget and staffing data,
        keeping the most complete information available.
        
        Args:
            budget_phases: DataFrame with phases from budget data
            staffing_phases: DataFrame with phases from staffing data
            
        Returns:
            DataFrame with merged phase information
        """
        if budget_phases.empty and staffing_phases.empty:
            return pd.DataFrame(columns=self.schemas['phases']['columns'])
        
        if budget_phases.empty:
            return staffing_phases
        
        if staffing_phases.empty:
            return budget_phases
        
        # Convert both DataFrames to dictionaries for easier merging
        budget_phase_dicts = budget_phases.to_dict('records')
        staffing_phase_dicts = staffing_phases.to_dict('records')
        
        # Create a lookup key for each phase
        budget_phase_lookup = {f"{phase['eng_no']}_{phase['eng_phase']}": phase 
                              for phase in budget_phase_dicts}
        
        # Add staffing phases that don't exist in budget phases
        for staffing_phase in staffing_phase_dicts:
            key = f"{staffing_phase['eng_no']}_{staffing_phase['eng_phase']}"
            if key not in budget_phase_lookup:
                budget_phase_lookup[key] = staffing_phase
        
        # Convert the merged dictionary back to a DataFrame
        merged_phases = pd.DataFrame(list(budget_phase_lookup.values()))
        
        # Ensure all expected columns exist
        for col in self.schemas['phases']['columns']:
            if col not in merged_phases.columns:
                merged_phases[col] = None
        
        return merged_phases

    def process_staffing_data(self):
        """
        Process staffing data to populate employees and staffing tables.
        """
        staffing_files = [STAFFING_2024_CSV, STAFFING_2025_CSV]
        staffing_records = []
        skipped_records = 0
        
        # Track records by year for debugging
        records_by_file = {}
        
        for staffing_file in staffing_files:
            if not os.path.exists(staffing_file):
                print(f"Warning: Staffing file not found at {staffing_file}")
                continue
            
            try:
                file_name = os.path.basename(staffing_file)
                print(f"Processing staffing file: {file_name}")
                df_staff = pd.read_csv(staffing_file, encoding='utf-8-sig')
                records_for_file = 0
                
                # Pre-filter dataframe to remove invalid records
                valid_mask = df_staff['Personnel No.'].notna() & df_staff['Employee Name'].notna()
                invalid_count = (~valid_mask).sum()
                skipped_records += invalid_count
                df_staff = df_staff[valid_mask]
                
                print(f"Found {len(df_staff)} valid staff records in {file_name}, skipped {invalid_count} invalid records")
                
                # Process staffing data only - we're using mocked employees now
                for _, row in df_staff.iterrows():
                    # Get engagement info
                    eng_no = row['Eng. No.']
                    eng_phase = row['Eng. Phase'] 
                    personnel_no = row['Personnel No.']
                    
                    # Process staffing data - columns after 'Staff Level' are week dates
                    # The date columns start at index 9 (0-indexed)
                    date_columns = [col for col in df_staff.columns if col not in [
                        'Eng. No.', 'Eng. Description', 'Eng. Phase', 'Phase Description',
                        'Client No.', 'Client Name', 'Personnel No.', 'Employee Name', 'Staff Level'
                    ]]
                    
                    # Debug date columns
                    if len(date_columns) == 0:
                        print(f"Warning: No date columns found in {file_name}")
                        print(f"Available columns: {df_staff.columns.tolist()}")
                        continue
                        
                    print(f"Processing {len(date_columns)} date columns in {file_name}") if records_for_file == 0 else None
                    
                    for date_col in date_columns:
                        hours = row[date_col]
                        if pd.notna(hours) and hours > 0:
                            try:
                                # Handle different date formats
                                # First try direct parsing, then with replacement
                                try:
                                    week_date = pd.to_datetime(date_col)
                                except:
                                    # Try removing time component if present
                                    if ' 0:00' in date_col or ' 00:00:00' in date_col:
                                        date_str = date_col.split(' ')[0]
                                    else:
                                        date_str = date_col
                                    week_date = pd.to_datetime(date_str)
                                
                                staffing_records.append({
                                    'personnel_no': personnel_no,
                                    'eng_no': eng_no,
                                    'eng_phase': eng_phase,
                                    'week_start_date': week_date,
                                    'planned_hours': float(hours)
                                })
                                records_for_file += 1
                            except Exception as e:
                                print(f"Warning: Could not parse date '{date_col}': {e}")
                
                records_by_file[file_name] = records_for_file
                print(f"Extracted {records_for_file} staffing records from {file_name}")
                
            except Exception as e:
                print(f"Error processing staffing file {staffing_file}: {str(e)}")
                import traceback
                traceback.print_exc()
        
        # Convert to DataFrames for staffing records
        if staffing_records:
            df_staffing = pd.DataFrame(staffing_records)
            
            # Standardize personnel numbers by removing leading zeros
            df_staffing = self._standardize_personnel_numbers_in_df(df_staffing)
            print("Standardized personnel numbers in staffing data")
            
            # Add debug info about date ranges
            if not df_staffing.empty and 'week_start_date' in df_staffing.columns:
                min_date = df_staffing['week_start_date'].min()
                max_date = df_staffing['week_start_date'].max()
                print(f"Staffing date range: {min_date} to {max_date}")
            
            # Show count by year
            if not df_staffing.empty and 'week_start_date' in df_staffing.columns:
                df_staffing['year'] = df_staffing['week_start_date'].dt.year
                year_counts = df_staffing.groupby('year').size()
                print(f"Staffing records by year:\n{year_counts}")
                df_staffing = df_staffing.drop(columns=['year'])  # Remove temporary column
            
            # Ensure we don't have duplicates across the composite primary key
            pk_columns = ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date']
            before_dedup = len(df_staffing)
            df_staffing = df_staffing.drop_duplicates(subset=pk_columns, keep='first')
            after_dedup = len(df_staffing)
            
            if before_dedup != after_dedup:
                print(f"Removed {before_dedup - after_dedup} duplicate staffing records")
            
            # Append to existing staffing data
            self.dfs['staffing'] = pd.concat([self.dfs['staffing'], df_staffing])
            print(f"Processed {len(staffing_records)} total staffing records")
            
            # Final verification of combined data
            print(f"Final staffing table contains {len(self.dfs['staffing'])} records")
        
        print(f"Completed staffing data processing: {sum(records_by_file.values())} total records ({skipped_records} invalid records skipped)")
        print(f"Records by file: {records_by_file}")
        
        # Add missing phases from staffing
        missing_phases = self.extract_phases_from_staffing()
        if not missing_phases.empty:
            # Add missing phases to phases DataFrame
            if 'phases' in self.dfs and not self.dfs['phases'].empty:
                # Instead of concatenation, use a more robust approach
                print(f"Adding {len(missing_phases)} missing phases to phases table")
                
                # Convert all phases to a list of dictionaries
                existing_phase_dicts = self.dfs['phases'].to_dict('records')
                missing_phase_dicts = missing_phases.to_dict('records')
                
                # Combine the two lists
                all_phase_dicts = existing_phase_dicts + missing_phase_dicts
                
                # Create a new DataFrame with all columns
                all_columns = set()
                for phase_dict in all_phase_dicts:
                    all_columns.update(phase_dict.keys())
                
                # Convert back to DataFrame
                combined_phases = pd.DataFrame(all_phase_dicts)
                
                # Ensure all expected columns exist
                for col in self.schemas['phases']['columns']:
                    if col not in combined_phases.columns:
                        combined_phases[col] = None
                
                # Set the result to the phases DataFrame
                self.dfs['phases'] = combined_phases
                print(f"Combined phases table now contains {len(combined_phases)} phases")
            else:
                # If no existing phases, just use the missing phases
                self.dfs['phases'] = missing_phases
                print(f"Created phases table with {len(missing_phases)} phases from staffing data")
            
            # Ensure there are no duplicates
            self.dfs['phases'] = self.dfs['phases'].drop_duplicates(subset=['eng_no', 'eng_phase'])
            print(f"After removing duplicates, phases table contains {len(self.dfs['phases'])} phases")

    def process_timesheet_data(self):
        """
        Process timesheet data to populate the timesheets table.
        """
        if not os.path.exists(TIME_CSV):
            print(f"Warning: Timesheet file not found at {TIME_CSV}")
            return
        
        try:
            print(f"Processing timesheet file: {TIME_CSV}")
            
            # Try different encodings
            encodings = ['utf-8-sig', 'latin1', 'cp1252']
            df_time = None
            
            for encoding in encodings:
                try:
                    df_time = pd.read_csv(TIME_CSV, encoding=encoding)
                    break
                except:
                    continue
            
            if df_time is None or df_time.empty:
                print(f"Warning: Could not read timesheet file or file is empty")
                return
            
            # Map column names
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
                print(f"Warning: Missing columns in timesheet file: {missing_columns}")
                print(f"Available columns: {df_time.columns.tolist()}")
                return
            
            # Rename columns and add sequential IDs
            df_time = df_time.rename(columns=column_mapping)
            
            # Standardize personnel numbers by removing leading zeros
            df_time = self._standardize_personnel_numbers_in_df(df_time)
            print("Standardized personnel numbers in timesheet data")
            
            # IMPORTANT: Add sequential IDs starting from 1
            # and explicitly convert to integer type
            df_time['id'] = range(1, len(df_time) + 1)
            df_time['id'] = df_time['id'].astype('int64')
            
            print(f"Assigned {len(df_time)} sequential IDs to timesheet records")
            print(f"Sample timesheet IDs: {df_time['id'].head().tolist()}")
            
            # Convert date columns
            date_columns = ['work_date', 'time_entry_date', 'posting_date']
            for col in date_columns:
                if col in df_time.columns:
                    df_time[col] = pd.to_datetime(df_time[col], errors='coerce')
            
            # Convert numeric columns
            numeric_columns = ['hours', 'charge_out_rate', 'std_price', 'adm_surcharge']
            for col in numeric_columns:
                if col in df_time.columns:
                    df_time[col] = pd.to_numeric(df_time[col], errors='coerce')
            
            # Select only the columns defined in our schema
            schema_columns = self.schemas['timesheets']['columns']
            df_time = df_time.reindex(columns=schema_columns)
            
            # Append to the timesheets DataFrame
            self.dfs['timesheets'] = pd.concat([self.dfs['timesheets'], df_time])
            print(f"Processed {len(df_time)} timesheet records")
            
        except Exception as e:
            print(f"Error processing timesheet data: {str(e)}")
            import traceback
            traceback.print_exc()

    def process_standard_chargeout_rates(self):
        """
        Generate standard chargeout rates table by analyzing timesheet data.
        Takes the most common rate for each employee per engagement.
        """
        if 'timesheets' not in self.dfs or self.dfs['timesheets'].empty:
            print("No timesheet data available to generate standard chargeout rates")
            return

        # Group timesheets by engagement and personnel number
        grouped = self.dfs['timesheets'].groupby(['eng_no', 'personnel_no'])['charge_out_rate']
        
        # Get the most common (mode) charge-out rate for each combination
        standard_rates = []
        for (eng_no, personnel_no), rates in grouped:
            # Get mode, ignoring NaN values
            mode_rate = rates.mode().iloc[0] if not rates.empty else None
            if pd.notna(mode_rate):
                standard_rates.append({
                    'eng_no': eng_no,
                    'personnel_no': personnel_no,
                    'standard_chargeout_rate': mode_rate
                })
        
        # Create DataFrame and store in dfs
        if standard_rates:
            self.dfs['charge_out_rates'] = pd.DataFrame(standard_rates)
            
            # Standardize personnel numbers
            self.dfs['charge_out_rates'] = self._standardize_personnel_numbers_in_df(self.dfs['charge_out_rates'])
            print("Standardized personnel numbers in charge out rates")
            
            print(f"Generated {len(standard_rates)} standard chargeout rate records")
            
            # Show distribution of rates for verification
            print("\nStandard chargeout rate distribution:")
            rate_stats = self.dfs['charge_out_rates']['standard_chargeout_rate'].describe()
            print(rate_stats)
        else:
            print("No valid chargeout rates found")

    def validate_foreign_keys(self):
        """
        Validate foreign key relationships between tables.
        """
        # Ensure all employees have standardized personnel numbers first
        if 'employees' in self.dfs and not self.dfs['employees'].empty:
            self.dfs['employees'] = self._standardize_personnel_numbers_in_df(self.dfs['employees'])
            print("Standardized personnel numbers in employees table")
        
        # Also standardize personnel numbers in all related tables before validation
        for table in ['staffing', 'timesheets', 'vacations', 'charge_out_rates']:
            if table in self.dfs and not self.dfs[table].empty:
                self.dfs[table] = self._standardize_personnel_numbers_in_df(self.dfs[table])
                print(f"Standardized personnel numbers in {table} table before validation")
        
        # Now proceed with regular foreign key validation
        for table, fk_list in self.foreign_keys.items():
            if table not in self.dfs or self.dfs[table].empty:
                continue
                
            print(f"Validating foreign keys for {table} table ({len(self.dfs[table])} records)")
            
            # For validation, we use strict validation for certain tables that MUST maintain referential integrity
            strict_validation = table not in ['staffing', 'timesheets']
            
            for fk in fk_list:
                if isinstance(fk[0], tuple):
                    # Composite foreign key
                    fk_cols = fk[0]
                    ref_table = fk[1]
                    ref_cols = fk[2]
                    
                    if ref_table not in self.dfs or self.dfs[ref_table].empty:
                        print(f"  Reference table {ref_table} is empty or missing")
                        continue
                    
                    # Create sets of reference keys
                    ref_keys = set()
                    for _, row in self.dfs[ref_table].iterrows():
                        key_tuple = tuple(row[col] for col in ref_cols)
                        ref_keys.add(key_tuple)
                    
                    # Check each row in the table
                    valid_rows = []
                    invalid_rows = []
                    for idx, row in self.dfs[table].iterrows():
                        fk_tuple = tuple(row[col] for col in fk_cols)
                        
                        # Skip rows with NULL foreign keys
                        if any(pd.isna(val) for val in fk_tuple):
                            valid_rows.append(idx)
                        # Otherwise check if the FK exists in the reference table
                        elif fk_tuple in ref_keys:
                            valid_rows.append(idx)
                        else:
                            invalid_rows.append((idx, fk_tuple))
                    
                    # Report invalid foreign keys
                    if invalid_rows:
                        print(f"  Found {len(invalid_rows)} records with invalid FK references to {ref_table}")
                    
                    # Filter rows if using strict validation
                    if strict_validation and invalid_rows:
                        before_filter = len(self.dfs[table])
                        self.dfs[table] = self.dfs[table].loc[valid_rows]
                        after_filter = len(self.dfs[table])
                        print(f"  Removed {before_filter - after_filter} records with invalid {fk_cols} references")
                else:
                    # Simple foreign key
                    fk_col = fk[0]
                    ref_table = fk[1]
                    ref_col = fk[2]
                    
                    if ref_table not in self.dfs or self.dfs[ref_table].empty:
                        print(f"  Reference table {ref_table} is empty or missing")
                        continue
                    
                    # Get valid reference keys
                    ref_keys = set(self.dfs[ref_table][ref_col].dropna().unique())
                    
                    # Find invalid foreign keys
                    invalid_mask = ~(self.dfs[table][fk_col].isna() | self.dfs[table][fk_col].isin(ref_keys))
                    invalid_count = invalid_mask.sum()
                    
                    if invalid_count > 0:
                        invalid_keys = self.dfs[table].loc[invalid_mask, fk_col].unique()
                        print(f"  Found {invalid_count} records with invalid {fk_col} references to {ref_table}")
                        print(f"  Sample invalid keys: {list(invalid_keys)[:3]}")
                    
                    # Filter rows if using strict validation
                    if strict_validation and invalid_count > 0:
                        before_filter = len(self.dfs[table])
                        self.dfs[table] = self.dfs[table][
                            self.dfs[table][fk_col].isna() | self.dfs[table][fk_col].isin(ref_keys)
                        ]
                        after_filter = len(self.dfs[table])
                        print(f"  Removed {before_filter - after_filter} records with invalid {fk_col} references")
        
        # Report counts after validation
        for table, df in self.dfs.items():
            print(f"After FK validation: {table} has {len(df)} records")
    
    def save_transformed_data(self):
        """
        Save all DataFrames to CSV files in the output directory,
        explicitly ensuring composite primary keys are included and NULL PKs are removed.
        """
        for table, df in self.dfs.items():
            if df.empty:
                print(f"Skipping empty table: {table}")
                continue
            
            # Clean the DataFrame according to its schema
            df = self._clean_dataframe(df, table)
            
            # For timesheets, ensure IDs are present and not null
            if table in self.db_generated_columns and 'id' in df.columns:
                # Check if IDs are null
                if df['id'].isna().any():
                    print(f"WARNING: Found NULL IDs in {table} table, regenerating sequential IDs...")
                    df['id'] = range(1, len(df) + 1)
                    df['id'] = df['id'].astype('int64')
                
                # Verify IDs are present
                print(f"Verifying IDs in {table}: {df['id'].notna().sum()} of {len(df)} records have IDs")
                print(f"First 5 IDs: {df['id'].head().tolist()}")
            
            # For staffing table, make sure we don't include an 'id' column that's not in the DDL
            if table == 'staffing' and 'id' in df.columns:
                print(f"Removing 'id' column from staffing table as it's not in the DDL schema")
                df = df.drop(columns=['id'])
            
            # IMPORTANT: Make sure ALL primary keys are non-null (not just composite ones)
            pk_columns = self.primary_keys.get(table, [])
            if not isinstance(pk_columns, list):
                pk_columns = [pk_columns]
                
            # Filter to keep only rows where ALL primary key components are non-null
            print(f"\nValidating primary key integrity for {table} ({pk_columns})")
            valid_mask = df[pk_columns].notna().all(axis=1)
            before_filter = len(df)
            df = df[valid_mask]
            after_filter = len(df)
            
            if before_filter != after_filter:
                print(f"⚠️ Filtered out {before_filter - after_filter} rows with NULL in primary key columns")
            
            # Ensure uniqueness of primary key (for all tables)
            before_dedup = len(df)
            df = df.drop_duplicates(subset=pk_columns, keep='first')
            after_dedup = len(df)
            
            if before_dedup != after_dedup:
                print(f"⚠️ Removed {before_dedup - after_dedup} duplicate rows with the same primary key values")
            
            # For composite primary keys, print additional information
            if len(pk_columns) > 1:  # Composite primary key
                print(f"Composite primary key columns in {table}:")
                print(df[pk_columns].head(5))
            
            # Save to CSV with NULL representation for NaN values
            output_file = OUTPUT_DIR / f"{table}.csv"
            df.to_csv(output_file, index=False, na_rep='NULL')
            
            # Verify the saved CSV file
            try:
                verification_df = pd.read_csv(output_file)
                pk_count = len(verification_df)
                print(f"✓ Verified {pk_count} records saved to {table}")
                
                # Verify that all primary key columns exist and have no nulls
                if all(col in verification_df.columns for col in pk_columns):
                    null_pks = verification_df[pk_columns].isna().any(axis=1).sum()
                    if null_pks > 0:
                        print(f"⚠️ WARNING: Found {null_pks} records with NULL primary keys in saved CSV!")
                    else:
                        print(f"✓ All primary keys are non-null in the CSV")
                else:
                    missing = [col for col in pk_columns if col not in verification_df.columns]
                    print(f"❌ ERROR: Missing primary key columns in CSV: {missing}")
            except Exception as e:
                print(f"Error verifying CSV: {e}")
            
            # Report what was saved
            print(f"Saved {len(df)} rows to {output_file} with primary key: {pk_columns}")

    def transform_all_data(self):
        """
        Execute the complete data transformation pipeline.
        """
        print(f"Starting data transformation at {datetime.now()}")
        
        # Initialize phase DataFrames
        self.budget_phases = pd.DataFrame()
        self.staffing_phases = pd.DataFrame()
        
        # Process each data source
        self.process_budget_data()
        self.process_staffing_data()
        
        # Merge phase information from different sources
        print("Merging phase information from budget and staffing data")
        merged_phases = self._merge_phase_info(self.budget_phases, self.staffing_phases)
        
        if not merged_phases.empty:
            # Ensure unique phases
            merged_phases = merged_phases.drop_duplicates(subset=['eng_no', 'eng_phase'], keep='first')
            self.dfs['phases'] = merged_phases
            print(f"Created merged phases table with {len(merged_phases)} unique phases")
        
        # Continue with other processing
        self.process_timesheet_data()
        self.process_standard_chargeout_rates()
        
        # Set dates for all engagements and phases that are still NULL
        self._populate_missing_dates()
        
        # Generate mock data
        print("Setting 40-hour employment basis for all employees")
        
        # Ensure standardized personnel numbers in employees before generating vacations
        if 'employees' in self.dfs and not self.dfs['employees'].empty:
            self.dfs['employees'] = self._standardize_personnel_numbers_in_df(self.dfs['employees'])
            print("Standardized personnel numbers in employees table")
        
        self.dfs['vacations'] = self.mocker.generate_vacation_data(self.dfs['employees'])
        self.dfs['optimization_parameters'] = self.mocker.create_default_optimization_parameters()
        
        # Update foreign keys to make sure practice IDs are properly set
        print("Setting practice IDs for all employees to SAP practice (ID 1)")
        if 'employees' in self.dfs and not self.dfs['employees'].empty:
            self.dfs['employees']['practice_id'] = 1
        
        if 'engagements' in self.dfs and not self.dfs['engagements'].empty:
            # Add some variety in engagements primary practice 
            # but ensure most are SAP (ID 1)
            self.dfs['engagements']['primary_practice_id'] = 1
            
            # For demonstration purposes, assign a few engagements to other KPMG practices
            # But keep the vast majority in SAP
            if len(self.dfs['engagements']) > 10:
                # Get some random indices, but keeping 80% in SAP
                num_to_change = min(int(len(self.dfs['engagements']) * 0.2), 7)
                if num_to_change > 0:
                    import random
                    indices = random.sample(range(len(self.dfs['engagements'])), num_to_change)
                    for i, idx in enumerate(indices):
                        # Assign to KPMG practices 2-8 (not SAP)
                        practice_id = (i % 7) + 2  # This gives practice IDs 2-8
                        self.dfs['engagements'].iloc[idx, self.dfs['engagements'].columns.get_loc('primary_practice_id')] = practice_id
            
            print(f"Assigned {num_to_change if 'num_to_change' in locals() else 0} engagements to non-SAP KPMG practices for demonstration")
        
        # Validate foreign key relationships
        self.validate_foreign_keys()
        
        # Before final save, ensure all employees have valid personnel_no values
        if 'employees' in self.dfs and not self.dfs['employees'].empty:
            print("Performing final validation of employee primary keys...")
            non_null_mask = self.dfs['employees']['personnel_no'].notna()
            before_count = len(self.dfs['employees'])
            self.dfs['employees'] = self.dfs['employees'][non_null_mask]
            after_count = len(self.dfs['employees'])
            if before_count != after_count:
                print(f"⚠️ Removed {before_count - after_count} employees with null personnel numbers")
        
        # Perform a final check on all foreign key references
        print("Performing final FK validation before save...")
        self.validate_foreign_keys()
        
        # Save the transformed data
        print("Saving final transformed data...")
        self.save_transformed_data()
                 
        print(f"Data transformation completed at {datetime.now()}")
    
    def _populate_missing_dates(self):
        """
        Populate missing dates in engagements and phases tables using realistic date ranges.
        """
        # Set dates for engagements
        if 'engagements' in self.dfs and not self.dfs['engagements'].empty:
            print("Checking for missing dates in engagements table...")
            engagements_df = self.dfs['engagements']
            
            # Count engagements with missing dates
            missing_start = engagements_df['start_date'].isna().sum()
            missing_end = engagements_df['end_date'].isna().sum()
            
            if missing_start > 0 or missing_end > 0:
                print(f"Found {missing_start} missing start dates and {missing_end} missing end dates in engagements")
                
                # Generate dates for engagements with missing dates
                for idx, row in engagements_df.iterrows():
                    if pd.isna(row['start_date']) or pd.isna(row['end_date']):
                        # Generate realistic dates - spread engagements throughout 2025
                        month = (idx % 12) + 1  # Spread across months 1-12
                        day = min((idx % 28) + 1, 28)  # Spread across days 1-28
                        
                        # Set start date in 2025
                        start_date = pd.Timestamp(f'2025-{month:02d}-{day:02d}')
                        
                        # Set end date 60-120 days later
                        duration = random.randint(60, 120)
                        end_date = start_date + pd.Timedelta(days=duration)
                        
                        # Update the DataFrame
                        if pd.isna(row['start_date']):
                            engagements_df.at[idx, 'start_date'] = start_date
                        if pd.isna(row['end_date']):
                            engagements_df.at[idx, 'end_date'] = end_date
                
                self.dfs['engagements'] = engagements_df
                print("Populated missing engagement dates with synthetic values")
        
        # Set dates for phases
        if 'phases' in self.dfs and not self.dfs['phases'].empty:
            print("Checking for missing dates in phases table...")
            phases_df = self.dfs['phases']
            
            # Count phases with missing dates
            missing_start = phases_df['start_date'].isna().sum()
            missing_end = phases_df['end_date'].isna().sum()
            
            if missing_start > 0 or missing_end > 0:
                print(f"Found {missing_start} missing start dates and {missing_end} missing end dates in phases")
                
                # First, create a mapping of engagement dates to use as reference
                eng_dates = {}
                if 'engagements' in self.dfs and not self.dfs['engagements'].empty:
                    for _, row in self.dfs['engagements'].iterrows():
                        if pd.notna(row['start_date']) and pd.notna(row['end_date']):
                            eng_dates[row['eng_no']] = (row['start_date'], row['end_date'])
                
                # Generate dates for phases with missing dates
                for idx, row in phases_df.iterrows():
                    eng_no = row['eng_no']
                    
                    if pd.isna(row['start_date']) or pd.isna(row['end_date']):
                        # First try to use engagement dates if available
                        if eng_no in eng_dates:
                            eng_start, eng_end = eng_dates[eng_no]
                            
                            # For multi-phase engagements, divide the duration into segments
                            phase_count = phases_df[phases_df['eng_no'] == eng_no].shape[0]
                            if phase_count > 1:
                                # Calculate phase duration as a portion of the engagement duration
                                eng_duration = (eng_end - eng_start).days
                                phase_duration = max(7, eng_duration // phase_count)
                                
                                # Get the phase index within this engagement
                                phase_idx = phases_df[
                                    (phases_df['eng_no'] == eng_no) & 
                                    (phases_df['eng_phase'] <= row['eng_phase'])
                                ].shape[0] - 1
                                
                                # Calculate phase dates based on position
                                phase_start = eng_start + pd.Timedelta(days=phase_idx * phase_duration)
                                phase_end = min(phase_start + pd.Timedelta(days=phase_duration), eng_end)
                            else:
                                # Single phase - use engagement dates
                                phase_start = eng_start
                                phase_end = eng_end
                        else:
                            # No engagement dates available - generate synthetic dates
                            month = (idx % 12) + 1  # Spread across months 1-12
                            day = min((idx % 28) + 1, 28)  # Spread across days 1-28
                            
                            # Set start date in 2025
                            phase_start = pd.Timestamp(f'2025-{month:02d}-{day:02d}')
                            
                            # Set end date 30-90 days later
                            duration = random.randint(30, 90)
                            phase_end = phase_start + pd.Timedelta(days=duration)
                        
                        # Update the DataFrame
                        if pd.isna(row['start_date']):
                            phases_df.at[idx, 'start_date'] = phase_start
                        if pd.isna(row['end_date']):
                            phases_df.at[idx, 'end_date'] = phase_end
                
                self.dfs['phases'] = phases_df
                print("Populated missing phase dates with synthetic values")

def main():
    """
    Main function to run the data transformer.
    """
    try:
        transformer = DataTransformer()
        transformer.transform_all_data()
    except Exception as e:
        print(f"Error in data transformation: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()

# Utility functions for standalone operation
def transform_staffing_data(input_file, output_file=None, append=False):
    """
    Transform staffing data from wide format (dates as columns) to long format (dates as rows)
    
    Parameters:
    - input_file: path to the input CSV file
    - output_file: path to the output CSV file (if None, returns DataFrame)
    - append: if True, append to the output file; if False, overwrite it
    
    Returns:
    - DataFrame with transformed data if output_file is None
    """
    # Read the input CSV file
    df = pd.read_csv(input_file)
    
    # Define metadata columns (first 9 columns A-I)
    metadata_columns = [
        'Eng. No.', 'Eng. Description', 'Eng. Phase', 'Phase Description',
        'Client No.', 'Client Name', 'Personnel No.', 'Employee Name', 'Staff Level'
    ]
    
    # All columns after the metadata columns are weekly allocations (J onwards)
    date_columns = [col for col in df.columns if col not in metadata_columns]
    
    print(f"Processing file: {input_file}")
    print(f"Found {len(date_columns)} weekly allocation columns")
    
    # Melt the DataFrame to convert from wide to long format
    melted_df = pd.melt(
        df,
        id_vars=['Eng. No.', 'Eng. Phase', 'Personnel No.'],
        value_vars=date_columns,
        var_name='week_start_date',
        value_name='planned_hours'
    )
    
    # Convert week_start_date from string to datetime and format it
    melted_df['week_start_date'] = pd.to_datetime(melted_df['week_start_date']).dt.strftime('%Y-%m-%d')
    
    # Rename columns to match the target format
    melted_df = melted_df.rename(columns={
        'Eng. No.': 'eng_no',
        'Eng. Phase': 'eng_phase',
        'Personnel No.': 'personnel_no'
    })
    
    # Select and reorder columns
    transformed_df = melted_df[['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours']]
    
    # Filter out rows with zero planned hours
    transformed_df = transformed_df[transformed_df['planned_hours'] > 0]
    
    # Standardize personnel numbers (remove leading zeros)
    def standardize_personnel_no(personnel_no):
        if pd.isna(personnel_no):
            return None
            
        try:
            # Handle float values by converting to integer first
            if isinstance(personnel_no, float):
                personnel_no = int(personnel_no)
                
            # Convert to string to handle various input formats
            personnel_str = str(personnel_no).strip()
            
            # Remove any leading zeros and decimal points
            personnel_str = personnel_str.lstrip('0')
            if '.' in personnel_str:
                personnel_str = personnel_str.split('.')[0]
                
            # If empty after stripping (all zeros), return 0
            if not personnel_str:
                return 0
                
            # Convert to integer
            return int(personnel_str)
        except Exception:
            return None
    
    transformed_df['personnel_no'] = transformed_df['personnel_no'].apply(standardize_personnel_no)
    
    # Convert column types
    transformed_df['personnel_no'] = transformed_df['personnel_no'].astype(int)
    transformed_df['eng_no'] = transformed_df['eng_no'].astype(int)
    transformed_df['eng_phase'] = transformed_df['eng_phase'].astype(int)
    
    # Print summary of data by year to verify we have all dates
    if not transformed_df.empty:
        transformed_df['year'] = pd.to_datetime(transformed_df['week_start_date']).dt.year
        year_counts = transformed_df.groupby('year').size()
        print(f"Records by year:\n{year_counts}")
        transformed_df = transformed_df.drop(columns=['year'])  # Remove temporary column
    
    # Write the transformed data to the output file or return the DataFrame
    if output_file:
        mode = 'a' if append else 'w'
        header = not append
        transformed_df.to_csv(output_file, index=False, mode=mode, header=header)
        print(f"Saved {len(transformed_df)} records to {output_file}")
    else:
        return transformed_df

def process_all_staffing_data():
    """Process both 2024 and 2025 staffing data and combine them"""
    # Define file paths
    base_dir = '/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump'
    staffing_2024 = os.path.join(base_dir, 'KPMG Case Data_Staffing___2024.csv')
    staffing_2025 = os.path.join(base_dir, 'KPMG Case Data_Staffing___2025.csv')
    output_file = os.path.join(base_dir, 'transformed/staffing.csv')
    
    # Transform 2024 data and write to output
    print("Transforming 2024 staffing data...")
    transform_staffing_data(staffing_2024, output_file, append=False)
    
    # Transform 2025 data and append to output
    print("Transforming 2025 staffing data...")
    transform_staffing_data(staffing_2025, output_file, append=True)
    
    print(f"Transformation complete. Output saved to {output_file}")

if __name__ == "__main__":
    process_all_staffing_data()
