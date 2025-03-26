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
            'employees': ['personnel_no', 'employee_name', 'staff_level', 'is_external', 'employment_basis'],
            'clients': ['client_no', 'client_name'],
            'engagements': ['eng_no', 'eng_description', 'client_no'],
            'phases': ['eng_no', 'eng_phase', 'phase_description', 'budget'],
            'staffing': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'],
            'timesheets': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'work_date', 'hours', 
                          'time_entry_date', 'posting_date', 'charge_out_rate', 'std_price', 'adm_surcharge'],
            'dictionary': ['key', 'description'],
            'vacations': ['personnel_no', 'start_date', 'end_date']
        }
        
        # Define column data types for proper SQL formatting (T-SQL specific)
        self.column_types = {
            'personnel_no': 'integer',
            'employee_name': 'nvarchar',
            'staff_level': 'nvarchar',
            'is_external': 'bit',
            'employment_basis': 'decimal',
            'client_no': 'integer',
            'client_name': 'nvarchar',
            'eng_no': 'integer',
            'eng_description': 'nvarchar',
            'eng_phase': 'integer',
            'phase_description': 'nvarchar',
            'budget': 'decimal',
            'id': 'integer',
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
            'description': 'nvarchar',
            'start_date': 'date',
            'end_date': 'date'
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
        
        # Load all transformed CSVs into DataFrames
        for table_name in self.schemas:
            csv_file = self.csv_dir / f"{table_name}.csv"
            if os.path.exists(csv_file):
                try:
                    self.dfs[table_name] = pd.read_csv(csv_file)
                    logger.info(f"Loaded {len(self.dfs[table_name])} rows from {csv_file}")
                except Exception as e:
                    logger.error(f"Error loading {csv_file}: {e}")
            else:
                logger.warning(f"Transformed CSV file not found: {csv_file}")
    
    def format_value(self, value, column_type):
        """
        Format a value based on its column type for SQL Server (T-SQL) insertion.
        """
        if value is None or pd.isna(value) or value == '':
            return 'NULL'
        
        value = str(value).strip()
        
        if column_type == 'integer':
            try:
                return str(int(float(value)))
            except (ValueError, TypeError):
                return 'NULL'
        elif column_type == 'decimal':
            try:
                return str(float(value))
            except (ValueError, TypeError):
                return 'NULL'
        elif column_type == 'date':
            try:
                # Try different date formats
                if isinstance(value, pd.Timestamp):
                    return f"CONVERT(DATE, '{value.strftime('%Y-%m-%d')}', 120)"
                else:
                    for fmt in ['%Y-%m-%d', '%d/%m/%Y', '%m/%d/%Y', '%Y-%m-%d %H:%M:%S']:
                        try:
                            date_obj = pd.to_datetime(value, format=fmt)
                            # T-SQL date format
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
        elif column_type.startswith('nvarchar'):  # Use N prefix for Unicode strings in T-SQL
            escaped_value = str(value).replace("'", "''")
            return f"N'{escaped_value}'"
        else:  # varchar and other text types
            escaped_value = str(value).replace("'", "''")
            return f"'{escaped_value}'"
    
    def generate_insert_statements(self):
        """
        Generate T-SQL INSERT statements for all tables from loaded DataFrames,
        handling composite primary keys correctly.
        """
        for table_name, df in self.dfs.items():
            statements = []
            schema_columns = self.schemas[table_name].copy()
            
            # Remove auto-generated columns from INSERT statements
            auto_generated = self.auto_generated_columns.get(table_name, [])
            if auto_generated:
                logger.info(f"Excluding auto-generated columns from {table_name} INSERT statements: {auto_generated}")
                for col in auto_generated:
                    if col in schema_columns:
                        schema_columns.remove(col)
            
            # For tables with composite primary keys like 'phases', ensure all key parts are included
            if table_name == 'phases':
                logger.info(f"Table {table_name} has composite primary key (eng_no, eng_phase)")
                # Ensure these columns are present in the schema and data
                if all(col in df.columns for col in ['eng_no', 'eng_phase']):
                    # Filter out rows with NULL in primary key columns
                    df = df[df['eng_no'].notna() & df['eng_phase'].notna()]
            
            # Check for column mismatch
            missing_columns = [col for col in schema_columns if col not in df.columns]
            if missing_columns:
                logger.warning(f"Missing columns in {table_name} data: {missing_columns}")
                for col in missing_columns:
                    df[col] = None  # Add missing columns as NULL
            
            # For large datasets, break into chunks to avoid too large SQL statements
            chunk_size = 500  # Number of rows per INSERT statement
            total_rows = len(df)
            
            for start_idx in range(0, total_rows, chunk_size):
                end_idx = min(start_idx + chunk_size, total_rows)
                chunk = df.iloc[start_idx:end_idx]
                
                # Start the multi-row INSERT statement
                if not chunk.empty:
                    values_list = []
                    
                    # Generate values for each row
                    for _, row in chunk.iterrows():
                        row_values = []
                        for column in schema_columns:
                            value = row.get(column)
                            column_type = self.column_types.get(column, 'nvarchar')
                            row_values.append(self.format_value(value, column_type))
                        
                        # Add the row's values as a tuple
                        values_list.append(f"({', '.join(row_values)})")
                    
                    # Create the multi-row INSERT statement
                    multi_insert = f"INSERT INTO [dbo].[{table_name}] ({', '.join([f'[{col}]' for col in schema_columns])}) VALUES\n"
                    multi_insert += ",\n".join(values_list) + ";"
                    
                    statements.append(multi_insert)
            
            self.sql_statements[table_name] = statements
            logger.info(f"Generated {len(statements)} multi-row T-SQL INSERT statements for {table_name} ({total_rows} total records)")

    def write_dml_file(self):
        """
        Write all INSERT statements to a single DML file using T-SQL syntax with batched transactions.
        """
        # Generate statements for all tables
        self.generate_insert_statements()
        
        # Write statements to file
        with open(self.output_file, 'w', encoding='utf-8') as f:
            f.write("-- T-SQL DML INSERT statements generated from transformed CSV files\n")
            f.write("-- Generation timestamp: " + pd.Timestamp.now().strftime("%Y-%m-%d %H:%M:%S") + "\n\n")
            
            f.write("-- Use the correct database\n")
            f.write("USE [KPMG_Data_Challenge];\n")
            f.write("GO\n\n")
            
            f.write("-- Turn off count of rows affected to improve performance\n")
            f.write("SET NOCOUNT ON;\n\n")
            
            f.write("BEGIN TRY\n")
            
            # Define insertion order for tables to handle foreign key constraints
            table_order = [
                'clients', 
                'employees', 
                'engagements', 
                'phases', 
                'staffing', 
                'timesheets',
                'dictionary',
                'vacations'  # Added new table
            ]
            
            # Write statements for each table in the defined order
            for table in table_order:
                statements = self.sql_statements.get(table, [])
                if statements:
                    statement_count = len(statements)
                    total_rows = sum(stmt.count('VALUES') for stmt in statements)
                    
                    f.write(f"    -- INSERT statements for {table} table ({total_rows} records)\n")
                    f.write(f"    PRINT 'Inserting data into {table} table ({total_rows} records)...';\n")
                    
                    f.write("    BEGIN TRANSACTION;\n")
                    
                    for i, stmt in enumerate(statements):
                        f.write(f"    -- Batch {i+1}/{statement_count}\n")
                        f.write("    " + stmt + "\n\n")
                    
                    f.write("    COMMIT TRANSACTION;\n")
                    f.write(f"    PRINT 'Committed all records for {table}';\n\n")
            
            f.write("    PRINT 'All data inserted successfully.';\n")
            f.write("END TRY\n")
            f.write("BEGIN CATCH\n")
            f.write("    IF @@TRANCOUNT > 0\n")
            f.write("        ROLLBACK TRANSACTION;\n\n")
            f.write("    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();\n")
            f.write("    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();\n")
            f.write("    DECLARE @ErrorState INT = ERROR_STATE();\n\n")
            f.write("    PRINT 'Error occurred: ' + @ErrorMessage;\n")
            f.write("    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);\n")
            f.write("END CATCH;\n\n")
            
            f.write("-- Turn count of rows affected back on\n")
            f.write("SET NOCOUNT OFF;\n")
            f.write("GO\n")
        
        # Print summary
        total_statements = sum(len(stmts) for stmts in self.sql_statements.values())
        logger.info(f"Generated {total_statements} T-SQL DML statements written to {self.output_file}")
    
    def process_data(self):
        """
        Main processing function to handle the entire workflow.
        """
        # Fetch transformed data
        self.fetch_data()
        
        # Write DML file
        self.write_dml_file()

def main():
    """
    Main function to run the DML writer with hardcoded directories.
    """
    logger.info("Starting DML generation...")
    try:
        writer = DMLWriter()
        writer.process_data()
        logger.info("T-SQL DML generation complete!")
    except Exception as e:
        logger.error(f"Error in DML generation: {e}", exc_info=True)
        raise

if __name__ == "__main__":
    main()

