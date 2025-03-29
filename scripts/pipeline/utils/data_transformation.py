import os
import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime
# Fix the import for DataMocker to use the correct filename
from utils.data_mocking import DataMocker

# File paths
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
                'columns': ['eng_no', 'eng_description', 'client_no', 'start_date', 'end_date', 
                           'actual_end_date', 'primary_practice_id'],
                'dtypes': {'eng_no': 'int64', 'eng_description': 'str', 'client_no': 'int',
                          'start_date': 'datetime64[ns]', 'end_date': 'datetime64[ns]', 
                          'actual_end_date': 'datetime64[ns]', 'primary_practice_id': 'int'}
            },
            'phases': {
                'columns': ['eng_no', 'eng_phase', 'phase_description', 'budget', 
                           'start_date', 'end_date', 'actual_end_date'],
                'dtypes': {'eng_no': 'int64', 'eng_phase': 'int', 'phase_description': 'str', 'budget': 'float',
                          'start_date': 'datetime64[ns]', 'end_date': 'datetime64[ns]', 
                          'actual_end_date': 'datetime64[ns]'}
            },
            'staffing': {
                'columns': ['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'],
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
                    if col == 'id' and table_name in self.db_generated_columns and not df[col].isna().all():
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
                
                engagement = {
                    'eng_no': eng_no,
                    'eng_description': eng_description,
                    'client_no': client_no,
                    'primary_practice_id': 1  # Default to SAP practice
                }
                
                engagements.append(engagement)
                
                # Extract phase data
                phases.append({
                    'eng_no': eng_no,
                    'eng_phase': int(row['Code phase']),
                    'phase_description': row['Phase Projet'],
                    'budget': float(row['Budget']) if pd.notna(row['Budget']) else None
                })
            
            # Convert to DataFrames
            if engagements:
                df_engagements = pd.DataFrame(engagements)
                df_engagements = df_engagements.drop_duplicates(subset=['eng_no'])
                self.dfs['engagements'] = df_engagements
                
            if phases:
                df_phases = pd.DataFrame(phases)
                df_phases = df_phases.drop_duplicates(subset=['eng_no', 'eng_phase'])
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
        for table, fk_list in self.foreign_keys.items():
            if table not in self.dfs or self.dfs[table].empty:
                continue
                
            for fk in fk_list:
                if isinstance(fk[0], tuple):
                    # Composite foreign key
                    fk_cols = fk[0]
                    ref_table = fk[1]
                    ref_cols = fk[2]
                    
                    if ref_table not in self.dfs or self.dfs[ref_table].empty:
                        continue
                        
                    # Create sets of reference keys
                    ref_keys = set()
                    for _, row in self.dfs[ref_table].iterrows():
                        key_tuple = tuple(row[col] for col in ref_cols)
                        ref_keys.add(key_tuple)
                    
                    # Check each row in the table
                    valid_rows = []
                    for idx, row in self.dfs[table].iterrows():
                        fk_tuple = tuple(row[col] for col in fk_cols)
                        
                        # Allow if any FK column is NULL
                        if any(pd.isna(val) for val in fk_tuple):
                            valid_rows.append(idx)
                        # Otherwise check if the FK exists in the reference table
                        elif fk_tuple in ref_keys:
                            valid_rows.append(idx)
                    
                    # Keep only valid rows
                    self.dfs[table] = self.dfs[table].loc[valid_rows]
                
                else:
                    # Simple foreign key
                    fk_col = fk[0]
                    ref_table = fk[1]
                    ref_col = fk[2]
                    
                    if ref_table not in self.dfs or self.dfs[ref_table].empty:
                        continue
                        
                    # Get valid reference keys
                    ref_keys = set(self.dfs[ref_table][ref_col].dropna().unique())
                    
                    # Filter rows with valid foreign keys or NULL
                    self.dfs[table] = self.dfs[table][
                        self.dfs[table][fk_col].isna() | self.dfs[table][fk_col].isin(ref_keys)
                    ]
        
        # Report counts after validation
        for table, df in self.dfs.items():
            print(f"After FK validation: {table} has {len(df)} records")
    
    def save_transformed_data(self):
        """
        Save all DataFrames to CSV files in the output directory,
        explicitly ensuring composite primary keys are included.
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
            
            # We've already dropped NULL columns during processing
            # so we just need to handle primary keys and set auto-generated columns
            
            # Make sure composite primary keys are present
            pk_columns = self.primary_keys.get(table, [])
            if len(pk_columns) > 1:  # Composite primary key
                print(f"\nProcessing table {table} with composite primary key {pk_columns}")
                
                # Filter to keep only rows where ALL primary key components are non-null
                valid_mask = df[pk_columns].notna().all(axis=1)
                before_filter = len(df)
                df = df[valid_mask]
                after_filter = len(df)
                
                if before_filter != after_filter:
                    print(f"Filtered out {before_filter - after_filter} rows with NULL in composite primary key columns")
                
                # For staffing table, ensure uniqueness of composite primary key
                if table == 'staffing':
                    df = df.drop_duplicates(subset=pk_columns, keep='first')
                    print(f"Ensured uniqueness of staffing records by composite primary key")
                
                # Print the first 5 rows to verify composite primary key columns
                print(f"\nComposite primary key columns in {table}:")
                print(df[pk_columns].head(5))
            
            # No longer setting auto-generated columns to NULL
            # We now use incremental IDs assigned during processing
            
            # Save to CSV with NULL representation for NaN values
            output_file = OUTPUT_DIR / f"{table}.csv"
            df.to_csv(output_file, index=False, na_rep='NULL')
            
            # Verify the saved CSV actually contains the composite primary key columns
            if len(pk_columns) > 1:
                # Read back the saved CSV to verify
                try:
                    verification_df = pd.read_csv(output_file)
                    print(f"\nVerifying composite primary key in saved CSV for {table}:")
                    print(verification_df[pk_columns].head(5))
                    
                    # Verify that all primary key columns exist
                    if all(col in verification_df.columns for col in pk_columns):
                        print(f"✓ All composite primary key columns {pk_columns} are present in the CSV")
                    else:
                        print(f"❌ ERROR: Not all composite primary key columns {pk_columns} are in the CSV!")
                        missing = [col for col in pk_columns if col not in verification_df.columns]
                        print(f"   Missing columns: {missing}")
                except Exception as e:
                    print(f"Error verifying composite primary key in saved CSV: {e}")
            
            # Report what was saved
            if len(pk_columns) > 1:
                print(f"Saved {len(df)} rows to {output_file} with composite primary key: {pk_columns}")
            else:
                print(f"Saved {len(df)} rows to {output_file}")

    def transform_all_data(self):
        """
        Execute the complete data transformation pipeline.
        """
        print(f"Starting data transformation at {datetime.now()}")
        
        # Process each data source
        self.process_budget_data()
        self.process_staffing_data()
        self.process_timesheet_data()
        self.process_standard_chargeout_rates()  # Add this line
        
        # Generate mock data
        print("Setting 40-hour employment basis for all employees")
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
        
        # Still call save_transformed_data but it won't need to drop columns
        # since we've already handled that during processing
        self.save_transformed_data()
        
        print(f"Data transformation completed at {datetime.now()}")

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
