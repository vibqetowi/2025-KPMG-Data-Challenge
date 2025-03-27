import pandas as pd
import os
import sys
from datetime import datetime

# Add the parent directory to path so we can import the fetcher
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from pipeline.fetcher import DataFetcher

# Create a DataFetcher instance (defaults to trying DB first then CSV)
fetcher = DataFetcher()

# Fetch data using the modular approach
data = fetcher.fetch_data(['employee_timesheet_data'])
df = data['employee_timesheet_data']

# Convert date columns to datetime objects
df['work_date'] = pd.to_datetime(df['work_date'])
df['time_entry_date'] = pd.to_datetime(df['time_entry_date'])

# Calculate the difference in days between time entry and work date
df['days_diff'] = (df['time_entry_date'] - df['work_date']).dt.total_seconds() / (24 * 3600)

# Group by personnel_no and calculate average time difference
avg_days_by_employee = df.groupby('personnel_no')['days_diff'].mean().reset_index()

# Rename columns for clarity
avg_days_by_employee.columns = ['Employee ID', 'Average Days Between Work and Entry']

# Print the results
print("\nAverage Days Between Work Date and Time Entry Date Per Employee:\n")
print(avg_days_by_employee.to_string(index=False, float_format=lambda x: f"{x:.2f}"))

# Optional: Additional statistics about the time entry behavior
print("\nAdditional Time Entry Statistics:\n")

# Calculate employees with longest and shortest average entry delays
max_delay_employee = avg_days_by_employee.loc[avg_days_by_employee['Average Days Between Work and Entry'].idxmax()]
min_delay_employee = avg_days_by_employee.loc[avg_days_by_employee['Average Days Between Work and Entry'].idxmin()]

print(f"Employee with longest average delay: {max_delay_employee['Employee ID']} - {max_delay_employee['Average Days Between Work and Entry']:.2f} days")
print(f"Employee with shortest average delay: {min_delay_employee['Employee ID']} - {min_delay_employee['Average Days Between Work and Entry']:.2f} days")

# Calculate overall average delay
overall_avg = df['days_diff'].mean()
print(f"Overall average delay across all employees: {overall_avg:.2f} days")

# Calculate percentage of same-day entries
same_day_entries = df[df['days_diff'] == 0].shape[0]
total_entries = df.shape[0]
same_day_percentage = (same_day_entries / total_entries) * 100
print(f"Percentage of time entries made on the same day as work: {same_day_percentage:.2f}%")

# Check for negative time differences (entries made before work date)
negative_entries = df[df['days_diff'] < 0]
if not negative_entries.empty:
    print(f"\nWarning: Found {negative_entries.shape[0]} entries where time was logged before work date")
