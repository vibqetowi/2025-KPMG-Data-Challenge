import pandas as pd
from datetime import datetime
import os
import sys
from pathlib import Path

# Get the absolute path to the current script's directory
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
# Add parent directory to sys.path to allow imports
parent_dir = current_dir.parent
sys.path.append(str(parent_dir))

# Proper import of DataFetcher
from utils.fetcher import DataFetcher

# Create a DataFetcher instance (defaults to trying DB first then CSV)
fetcher = DataFetcher()

# Fetch needed data using the DataFetcher
data = fetcher.fetch_data(['timesheet_data', 'budget'])
df_time = data['timesheet_data']
df_budget = data['budget']  # Also get budget data for BAC values

# Convert relevant columns to datetime
if 'Posting Date' in df_time.columns:
    df_time['Posting Date'] = pd.to_datetime(df_time['Posting Date'], errors='coerce')
if 'Time Entry Date' in df_time.columns:
    df_time['Time Entry Date'] = pd.to_datetime(df_time['Time Entry Date'], errors='coerce')
if 'Work Date' in df_time.columns:
    df_time['Work Date'] = pd.to_datetime(df_time['Work Date'], errors='coerce')

# 3. Create a composite key for (Eng. No. + Eng. Phase) to identify a unique project-phase
df_time['project_key'] = (
    df_time['Eng. No.'].astype(str) + '_' + df_time['Eng. Phase'].astype(str)
)

# 4. Aggregate data at the (Eng. No., Eng. Phase) level
#    We'll:
#    - Sum Hours
#    - Sum Std. Price and Adm. Surcharge
#    - Take the earliest Posting Date as 'start_date' (the start of billing)
agg_dict = {
    'Hours': 'sum',
    'Std. Price': 'sum',
    'Adm. Surcharge': 'sum',
    'Posting Date': 'min',   # earliest date that hours were billed/posted
}

df_projects = df_time.groupby('project_key').agg(agg_dict).reset_index()

# Rename 'Posting Date' to 'start_date' for clarity
df_projects.rename(columns={'Posting Date': 'start_date'}, inplace=True)

# 5. Define budget data from the fetched budget information
# Create a mapping of project_key to budget value
budget_map = {}
if not df_budget.empty and 'budget' in df_budget.columns:
    for _, row in df_budget.iterrows():
        if pd.notna(row.get('eng_no')) and pd.notna(row.get('eng_phase')):
            key = f"{row['eng_no']}_{row['eng_phase']}"
            budget_map[key] = row.get('budget', 0)

# 6. Calculate key EVM metrics
df_projects['BAC'] = df_projects['project_key'].map(budget_map)
# Use default BAC if not found in budget data
df_projects['BAC'] = df_projects['BAC'].fillna(100000)  # fallback to placeholder

# Example: average charge rate (if not in your data, you might have 'Charge-Out Rate' column per line)
df_projects['average_charge_rate'] = 100  # $100/hr placeholder

# 6. Calculate key EVM metrics

# 6a. Hours_required = BAC / average_charge_rate
df_projects['Hours_required'] = df_projects['BAC'] / df_projects['average_charge_rate']

# 6b. For demonstration, assume a default # of employees and working hours/day
default_num_employees = 5
working_hours_per_day = 8
df_projects['Total_estimated_duration'] = (
    df_projects['Hours_required'] / (default_num_employees * working_hours_per_day)
)

# 6c. Days_elapsed (using today's date as reference)
current_date = datetime.now()
df_projects['Days_elapsed'] = (current_date - df_projects['start_date']).dt.days

# 6d. Schedule_elapsed
df_projects['Schedule_elapsed'] = (
    df_projects['Days_elapsed'] / df_projects['Total_estimated_duration']
)

# 6e. Completion_pct = Hours_billed / Hours_required
#     In this example, 'Hours' is the total hours billed (sum of hours for that project-phase)
df_projects['Completion_pct'] = df_projects['Hours'] / df_projects['Hours_required']

# 6f. Earned Value (EV) = BAC * Completion_pct
df_projects['EV'] = df_projects['BAC'] * df_projects['Completion_pct']

# 6g. Actual Cost (AC) = Std. Price + Adm. Surcharge
df_projects['AC'] = df_projects['Std. Price'] + df_projects['Adm. Surcharge']

# 6h. Cost Performance Index (CPI) = EV / AC
df_projects['CPI'] = df_projects['EV'] / df_projects['AC']

# 6i. Planned Value (PV) = BAC * (Days_elapsed / Total_estimated_duration)
df_projects['PV'] = df_projects['BAC'] * (
    df_projects['Days_elapsed'] / df_projects['Total_estimated_duration']
)

# 6j. Schedule Performance Index (SPI) = EV / PV
df_projects['SPI'] = df_projects['EV'] / df_projects['PV']

# 7. Inspect the final DataFrame
print(df_projects.head(10))
