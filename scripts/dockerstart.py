##script that runs the DDL against the database and once again runs the DML against the database
#should run with the correct connection string for microsoft

import os
import time
import subprocess
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def run_sql_script(script_path):
    """Run a SQL script using sqlcmd with the correct connection string"""
    cmd = [
        '/opt/mssql-tools18/bin/sqlcmd',
        '-S', 'localhost,1433',
        '-U', 'sa',
        '-P', 'YourStrong@Passw0rd',
        '-C',  # Trust server certificate
        '-i', script_path
    ]
    try:
        subprocess.run(cmd, check=True)
        print(f"Successfully executed {script_path}")
    except subprocess.CalledProcessError as e:
        print(f"Error executing {script_path}: {e}")

def main():
    # Wait for SQL Server to start
    print("Waiting for SQL Server to start...")
    time.sleep(30)

    # Run DDL script
    print("Running DDL script...")
    run_sql_script('/app/Database/DDL.sql')

    # Run DML script
    print("Running DML script...")
    run_sql_script('/app/Database/DML.sql')

    print("Database initialization complete!")

if __name__ == "__main__":
    main()