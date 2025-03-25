import os
import pandas as pd
from pathlib import Path

# Hardcoded directories
INPUT_DIR = Path('/Users/notAdmin/Dev/2025 KPMG Data Challenge/transformed')
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
        
        # Define table schemas based on DDL
        self.schemas = {
            'employees': ['personnel_no', 'employee_name', 'staff_level', 'is_external'],
            'clients': ['client_no', 'client_name'],
            'engagements': ['eng_no', 'eng_description', 'client_no'],
            'phases': ['eng_no', 'eng_phase', 'phase_description', 'budget'],
            'staffing': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'],
            'timesheets': ['id', 'personnel_no', 'eng_no', 'eng_phase', 'work_date', 'hours', 
                          'time_entry_date', 'posting_date', 'charge_out_rate', 'std_price', 'adm_surcharge'],
            'dictionary': ['id', 'category', 'key', 'value', 'description']
        }
        
        # Define column data types for proper SQL formatting
        self.column_types = {
            'personnel_no': 'integer',
            'employee_name': 'varchar',
            'staff_level': 'varchar',
            'is_external': 'bit',
            'client_no': 'integer',
            'client_name': 'varchar',
            'eng_no': 'integer',
            'eng_description': 'varchar',
            'eng_phase': 'integer',
            'phase_description': 'varchar',
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
            'category': 'varchar',
            'key': 'varchar',
            'value': 'varchar',
            'description': 'varchar'
        }
        
        # SQL statements for each table
        self.sql_statements = {table: [] for table in self.schemas.keys()}
        
        # DataFrames loaded from transformed CSVs
        self.dfs = {}
    
    def fetch_data(self):
        """
        Fetch all transformed CSV data from hardcoded directory.
        """
        print(f"Fetching transformed data from {self.csv_dir}")
        
        # Check if input directory exists
        if not os.path.exists(self.csv_dir):
            raise FileNotFoundError(f"Transformed CSV directory not found: {self.csv_dir}")
        
        # Load all transformed CSVs into DataFrames
        for table_name in self.schemas:
            csv_file = self.csv_dir / f"{table_name}.csv"
            if os.path.exists(csv_file):
                try:
                    self.dfs[table_name] = pd.read_csv(csv_file)
                    print(f"Loaded {len(self.dfs[table_name])} rows from {csv_file}")
                except Exception as e:
                    print(f"Error loading {csv_file}: {e}")
            else:
                print(f"Warning: Transformed CSV file not found: {csv_file}")
    
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
        else:  # varchar and other text types
            return "N'" + str(value).replace("'", "''") + "'"
    
    def generate_insert_statements(self):
        """
        Generate SQL INSERT statements for all tables from loaded DataFrames.
        """
        for table_name, df in self.dfs.items():
            statements = []
            
            # Generate INSERT statements
            for _, row in df.iterrows():
                values = []
                for column in self.schemas[table_name]:
                    value = row.get(column)
                    column_type = self.column_types.get(column, 'varchar')
                    values.append(self.format_value(value, column_type))
                
                stmt = f"INSERT INTO {table_name} ({', '.join(self.schemas[table_name])}) VALUES ({', '.join(values)});"
                statements.append(stmt)
            
            self.sql_statements[table_name] = statements
            print(f"Generated {len(statements)} T-SQL INSERT statements for {table_name}")
    
    def write_dml_file(self):
        """
        Write all INSERT statements to a single DML file.
        """
        # Generate statements for all tables
        self.generate_insert_statements()
        
        # Write statements to file
        with open(self.output_file, 'w') as f:
            f.write("-- T-SQL DML INSERT statements generated from transformed CSV files\n\n")
            f.write("BEGIN TRANSACTION;\n\n")
            
            # Define order for tables to handle foreign key constraints
            table_order = [
                'clients', 
                'employees', 
                'engagements', 
                'phases', 
                'staffing', 
                'timesheets',
                'dictionary'
            ]
            
            # Write statements for each table in the defined order
            for table in table_order:
                statements = self.sql_statements.get(table, [])
                if statements:
                    f.write(f"-- INSERT statements for {table} table\n")
                    for stmt in statements:
                        f.write(stmt + "\n")
                    f.write("\n")
            
            f.write("COMMIT TRANSACTION;\n")
        
        # Print summary
        total_statements = sum(len(stmts) for stmts in self.sql_statements.values())
        print(f"Generated {total_statements} T-SQL DML statements written to {self.output_file}")
    
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
    print("Starting DML generation...")
    try:
        writer = DMLWriter()
        writer.process_data()
        print("T-SQL DML generation complete!")
    except Exception as e:
        print(f"Error in DML generation: {e}")
        raise

if __name__ == "__main__":
    main()
