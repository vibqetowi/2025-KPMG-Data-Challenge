import os
import pandas as pd
from pathlib import Path
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Hardcoded directories
INPUT_DIR = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/csv-dump/transformed')
OUTPUT_FILE = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/Database/DML.sql')

class DMLWriter:
    def __init__(self):
        """
        Initialize the DML writer with hardcoded directories for transformed CSV files and output SQL file.
        """
        self.csv_dir = INPUT_DIR
        self.output_file = OUTPUT_FILE
        
        # Ensure output directory exists
        self.output_file.parent.mkdir(exist_ok=True, parents=True)
        
        # Define table schemas based on DDL (match exactly with database structure)
        self.schemas = {
            'practices': ['practice_id', 'practice_name', 'description'],
            'employees': ['personnel_no', 'employee_name', 'staff_level', 'is_external', 'employment_basis', 'practice_id'],
            'clients': ['client_no', 'client_name'],
            'engagements': ['eng_no', 'eng_description', 'client_no', 'primary_practice_id'],
            'phases': ['eng_no', 'eng_phase', 'phase_description', 'budget'],
            'staffing': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'],
            'timesheets': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'work_date', 'hours', 
                          'time_entry_date', 'posting_date', 'charge_out_rate', 'std_price', 'adm_surcharge'],
            'dictionary': ['key', 'description'],
            'vacations': ['personnel_no', 'start_date', 'end_date'],
            'charge_out_rates': ['eng_no', 'personnel_no', 'standard_chargeout_rate']
        }
        
        # Define primary keys for each table
        self.primary_keys = {
            'practices': ['practice_id'],
            'employees': ['personnel_no'],
            'clients': ['client_no'],
            'engagements': ['eng_no'],
            'phases': ['eng_no', 'eng_phase'],
            'staffing': ['id'],
            'timesheets': ['id'],
            'dictionary': ['key'],
            'vacations': ['personnel_no', 'start_date'],
            'charge_out_rates': ['eng_no', 'personnel_no']
        }
        
        # Define column data types for proper SQL Server (T-SQL) formatting
        self.column_types = {
            'practice_id': 'int',
            'practice_name': 'nvarchar',
            'description': 'nvarchar',
            'personnel_no': 'int',
            'employee_name': 'nvarchar',
            'staff_level': 'nvarchar',
            'is_external': 'bit',
            'employment_basis': 'decimal',
            'client_no': 'int',
            'client_name': 'nvarchar',
            'eng_no': 'bigint',
            'eng_description': 'nvarchar',
            'eng_phase': 'int',
            'phase_description': 'nvarchar',
            'budget': 'decimal',
            'id': 'int',
            'week_start_date': 'date',
            'planned_hours': 'decimal',
            'work_date': 'date',
            'hours': 'decimal',
            'time_entry_date': 'date',
            'posting_date': 'date',
            'charge_out_rate': 'decimal',
            'std_price': 'decimal',
            'adm_surcharge': 'decimal',
            'key': 'nvarchar',
            'primary_practice_id': 'int',
            'start_date': 'date',
            'end_date': 'date',
            'standard_chargeout_rate': 'decimal'
        }
        
        # Define auto-generated columns that should be excluded from INSERT statements
        self.auto_generated_columns = {
            'staffing': ['id'],
            'timesheets': ['id']
        }
        
        # SQL statements for each table
        self.sql_statements = {table: [] for table in self.schemas.keys()}
        
        # DataFrames loaded from transformed CSVs
        self.dfs = {}
    
    def fetch_data(self):
        """
        Fetch all transformed CSV data from the transformed directory.
        """
        logger.info(f"Fetching transformed data from {self.csv_dir}")
        
        # Check if input directory exists
        if not os.path.exists(self.csv_dir):
            raise FileNotFoundError(f"Transformed CSV directory not found: {self.csv_dir}")
        
        # Load all transformed CSVs into DataFrames - including any new ones like vacations
        for table_name in self.schemas:
            csv_file = self.csv_dir / f"{table_name}.csv"
            if os.path.exists(csv_file):
                try:
                    self.dfs[table_name] = pd.read_csv(csv_file, na_values=['NULL'])
                    
                    # For vacation dates, ensure proper date format
                    if table_name == 'vacations':
                        if 'start_date' in self.dfs[table_name].columns:
                            self.dfs[table_name]['start_date'] = pd.to_datetime(self.dfs[table_name]['start_date'])
                        if 'end_date' in self.dfs[table_name].columns:
                            self.dfs[table_name]['end_date'] = pd.to_datetime(self.dfs[table_name]['end_date'])
                    
                    # For employees, ensure employment_basis is a float
                    if table_name == 'employees':
                        if 'employment_basis' in self.dfs[table_name].columns:
                            self.dfs[table_name]['employment_basis'] = pd.to_numeric(
                                self.dfs[table_name]['employment_basis'], errors='coerce')
                    
                    logger.info(f"Loaded {len(self.dfs[table_name])} rows from {csv_file}")
                except Exception as e:
                    logger.error(f"Error loading {csv_file}: {e}")
            else:
                logger.warning(f"Transformed CSV file not found: {csv_file}")
    
    def format_value(self, value, column_type):
        """
        Format a value based on its column type for SQL Server (T-SQL) insertion.
        """
        if value is None or pd.isna(value) or value == '' or value == 'NULL':
            return 'NULL'
        
        value = str(value).strip()
        
        if column_type == 'integer' or column_type == 'int' or column_type == 'bigint':
            try:
                return str(int(float(value)))
            except (ValueError, TypeError):
                return 'NULL'
        elif column_type == 'decimal':
            try:
                float_val = float(value)
                # Format with 2 decimal places for money values
                return f"{float_val:.2f}"
            except (ValueError, TypeError):
                return 'NULL'
        elif column_type == 'date':
            try:
                # Use proper SQL Server date conversion
                if isinstance(value, pd.Timestamp):
                    return f"CONVERT(DATE, '{value.strftime('%Y-%m-%d')}', 120)"
                else:
                    for fmt in ['%Y-%m-%d', '%d/%m/%Y', '%m/%d/%Y', '%Y-%m-%d %H:%M:%S']:
                        try:
                            date_obj = pd.to_datetime(value, format=fmt)
                            return f"CONVERT(DATE, '{date_obj.strftime('%Y-%m-%d')}', 120)"
                        except:
                            continue
                return 'NULL'
            except:
                return 'NULL'
        elif column_type == 'bit':
            if str(value).lower() in ('true', 't', 'yes', 'y', '1'):
                return '1'
            elif str(value).lower() in ('false', 'f', 'no', 'n', '0'):
                return '0'
            else:
                return 'NULL'
        elif column_type.startswith('nvarchar'):
            # Use N prefix for Unicode strings and proper escaping
            escaped_value = str(value).replace("'", "''")
            return f"N'{escaped_value}'"
        else:
            escaped_value = str(value).replace("'", "''")
            return f"'{escaped_value}'"
    
    def generate_insert_statements(self):
        """
        Generate T-SQL INSERT statements for all tables.
        """
        for table_name, df in self.dfs.items():
            statements = []
            schema_columns = self.schemas[table_name].copy()
            
            # Check for column mismatch
            missing_columns = [col for col in schema_columns if col not in df.columns]
            if missing_columns:
                logger.warning(f"Missing columns in {table_name} data: {missing_columns}")
                for col in missing_columns:
                    df[col] = None  # Add missing columns as NULL
            
            # For large datasets, break into chunks to avoid too large SQL statements
            chunk_size = 500  # Can use larger chunk size for simple INSERT vs MERGE
            total_rows = len(df)
            
            for start_idx in range(0, total_rows, chunk_size):
                end_idx = min(start_idx + chunk_size, total_rows)
                chunk = df.iloc[start_idx:end_idx]
                
                if not chunk.empty:
                    # Start the INSERT statement
                    insert_statement = f"INSERT INTO [dbo].[{table_name}] ([{'], ['.join(schema_columns)}])\nVALUES\n"
                    
                    # Generate values for each row
                    values_rows = []
                    for _, row in chunk.iterrows():
                        row_values = []
                        for column in schema_columns:
                            value = row.get(column)
                            column_type = self.column_types.get(column, 'nvarchar')
                            row_values.append(self.format_value(value, column_type))
                        
                        values_rows.append(f"({', '.join(row_values)})")
                    
                    insert_statement += ",\n".join(values_rows) + ";"
                    
                    statements.append(insert_statement)
            
            self.sql_statements[table_name] = statements
            logger.info(f"Generated {len(statements)} INSERT statements for {table_name} ({total_rows} total records)")

    def write_dml_file(self):
        """
        Write all INSERT statements to a single DML file using T-SQL syntax with batched transactions.
        """
        # Generate INSERT statements for all tables
        self.generate_insert_statements()
        
        # Write statements to file
        with open(self.output_file, 'w', encoding='utf-8') as f:
            f.write("-- T-SQL DML INSERT statements generated from transformed CSV files\n")
            f.write("-- Generation timestamp: " + pd.Timestamp.now().strftime("%Y-%m-%d %H:%M:%S") + "\n\n")
            
            f.write("-- Use the database created by the DDL script\n")
            f.write("USE [KPMG_Data_Challenge];\n")
            f.write("GO\n\n")
            
            f.write("-- Turn off count of rows affected to improve performance\n")
            f.write("SET NOCOUNT ON;\n")
            f.write("GO\n\n")
            
            f.write("-- Starting data insert operations\n")
            f.write("PRINT 'Starting data insert operations...';\n")
            f.write("GO\n\n")
            
            # Define insertion order for tables to handle foreign key constraints
            table_order = [
                'practices',
                'clients', 
                'employees', 
                'engagements', 
                'phases', 
                'dictionary',
                'staffing', 
                'timesheets',
                'vacations',
                'charge_out_rates'
            ]
            
            # Write statements for each table in the defined order
            for table in table_order:
                statements = self.sql_statements.get(table, [])
                if not statements:
                    continue
                    
                statement_count = len(statements)
                
                f.write(f"-- INSERT statements for {table} table\n")
                f.write(f"PRINT 'Inserting data into {table} table...';\n")
                f.write("BEGIN TRY\n")
                f.write("    BEGIN TRANSACTION;\n")
                
                # Handle identity insert for tables with identity columns
                if table in ('staffing', 'timesheets'):
                    f.write(f"    SET IDENTITY_INSERT [dbo].[{table}] ON;\n")
                
                for i, stmt in enumerate(statements):
                    f.write(f"    -- Batch {i+1}/{statement_count}\n")
                    f.write("    " + stmt.replace("\n", "\n    ") + "\n")
                
                # Turn off identity insert if it was turned on
                if table in ('staffing', 'timesheets'):
                    f.write(f"    SET IDENTITY_INSERT [dbo].[{table}] OFF;\n")
                
                f.write("    COMMIT TRANSACTION;\n")
                f.write(f"    PRINT 'Completed insert for {table}';\n")
                f.write("END TRY\n")
                f.write("BEGIN CATCH\n")
                f.write("    IF @@TRANCOUNT > 0\n")
                f.write("        ROLLBACK TRANSACTION;\n")
                f.write("    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();\n")
                f.write("    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();\n")
                f.write("    DECLARE @ErrorState INT = ERROR_STATE();\n")
                f.write(f"    PRINT 'Error inserting data into {table}: ' + @ErrorMessage;\n")
                f.write("    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);\n")
                f.write("END CATCH;\n")
                f.write("GO\n\n")
            
            f.write("-- Turn count of rows affected back on\n")
            f.write("SET NOCOUNT OFF;\n")
            f.write("GO\n\n")
            f.write("PRINT 'Data insert operations completed successfully.';\n")
            f.write("GO\n")
        
        # Print summary
        total_statements = sum(len(stmts) for stmts in self.sql_statements.values())
        logger.info(f"Generated {total_statements} T-SQL INSERT statements written to {self.output_file}")
    
    def process_data(self):
        """
        Main processing function to handle the entire workflow.
        """
        # Fetch transformed data
        self.fetch_data()
        
        # Write DML file with INSERT statements
        self.write_dml_file()

def main():
    """
    Main function to run the DML writer with hardcoded directories.
    """
    logger.info("Starting DML generation with INSERT approach...")
    try:
        writer = DMLWriter()
        writer.process_data()
        logger.info("T-SQL DML generation with INSERT complete!")
    except Exception as e:
        logger.error(f"Error in DML generation: {e}", exc_info=True)
        raise

if __name__ == "__main__":
    main()

