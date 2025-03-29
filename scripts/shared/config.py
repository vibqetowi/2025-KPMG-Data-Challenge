"""
Shared configuration for KPMG Data Challenge.

This module provides centralized configuration and path definitions
used across the project.
"""
import os
from pathlib import Path

# Get project root path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
PROJECT_ROOT = current_dir.parent.parent

# Define common paths
EXCEL_FILE = PROJECT_ROOT / 'Documentation/KPMG Case Data.xlsx'
CSV_DUMP_DIR = PROJECT_ROOT / 'csv-dump'
TRANSFORMED_DIR = PROJECT_ROOT / 'csv-dump/transformed'
DATABASE_DIR = PROJECT_ROOT / 'Database'
DDL_FILE = DATABASE_DIR / 'DDL.sql'
DML_FILE = DATABASE_DIR / 'DML.sql'

# Define raw file mappings
RAW_FILE_MAP = {
    "timesheets": "KPMG Case Data_TIME.csv",
    "employees": "KPMG Case Data_Staffing___2024.csv", 
    "clients": "KPMG Case Data_Staffing___2024.csv",
    "engagements": "KPMG Case Data_Budget.csv",
    "phases": "KPMG Case Data_Budget.csv",
    "budget": "KPMG Case Data_Budget.csv",
    "staffing": "KPMG Case Data_Staffing___2024.csv",
    "practices": None,  # Generated internally
    "dictionary": "KPMG Case Data_Dictionnaire___Dictionary_.csv",
    "vacations": None,  # Generated internally
    "charge_out_rates": None,  # Generated internally
    "optimization_parameters": None  # Generated internally
}

# Column mapping definitions for transformations
COLUMN_MAPPINGS = {
    "timesheets": {
        "Personnel No.": "personnel_no",
        "Work Date": "work_date",
        "Hours": "hours",
        "Eng. No.": "eng_no",
        "Eng. Phase": "eng_phase",
        "Time Entry Date": "time_entry_date",
        "Posting Date": "posting_date",
        "Charge-Out Rate": "charge_out_rate",
        "Std. Price": "std_price",
        "Adm. Surcharge": "adm_surcharge"
    },
    "employees": {
        "Personnel No.": "personnel_no",
        "Employee Name": "employee_name",
        "Staff Level": "staff_level"
    },
    "clients": {
        "Client No.": "client_no",
        "Client Name": "client_name"
    },
    "phases": {
        "Code projet": "eng_no",
        "Code phase": "eng_phase",
        "Phase Projet": "phase_description",
        "Budget": "budget"
    },
    "engagements": {
        "Code projet": "eng_no",
        "Nom de projet": "eng_description",
        "Client No.": "client_no"
    },
    "dictionary": {
        "Clé": "key",
        "Description": "description"
    }
}
