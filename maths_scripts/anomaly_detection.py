from sklearn.ensemble import IsolationForest
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from datetime import datetime

csv_path = r"C:\Users\carte\OneDrive\Documents\Coding Projects\2025-KPMG-Data-Challenge\csv-dump\KPMG Case Data_TIME.csv"
df_time = pd.read_csv(csv_path, encoding="latin-1")

# Convert date columns to datetime
df_time['Work Date'] = pd.to_datetime(df_time['Work Date'])
df_time['Time Entry Date'] = pd.to_datetime(df_time['Time Entry Date'])

# Calculate time difference in days
df_time['Time Entry Delay'] = (df_time['Time Entry Date'] - df_time['Work Date']).dt.total_seconds() / (24 * 60 * 60)

# Function to perform anomaly detection for hours for a single employee
def detect_hours_anomalies(employee_data):
    # Select relevant columns for anomaly detection
    anomaly_columns = ['Hours', 'Std. Price']
    
    # Check if employee has enough data points
    if len(employee_data) < 5:  # Minimum data points for meaningful detection
        return pd.Series([-1] * len(employee_data), index=employee_data.index)
    
    # Prepare data for anomaly detection
    df_anomaly = employee_data[anomaly_columns].dropna()
    
    # Standardize the features to ensure equal weight
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(df_anomaly)
    
    # Fit Isolation Forest model
    iso_forest = IsolationForest(contamination=0.1, random_state=42)  # 10% anomalies
    anomalies = iso_forest.fit_predict(scaled_data)
    
    # Create a series of anomalies with the same index as the input data
    anomaly_series = pd.Series([-1] * len(employee_data), index=employee_data.index)
    anomaly_series.loc[df_anomaly.index] = anomalies
    return anomaly_series

# Function to perform anomaly detection for time entry delays for a single employee
def detect_time_entry_delay_anomalies(employee_data):
    # Check if employee has enough data points
    if len(employee_data) < 5:  # Minimum data points for meaningful detection
        return pd.Series([-1] * len(employee_data), index=employee_data.index)
    
    # Prepare data for anomaly detection
    df_anomaly = employee_data[['Time Entry Delay']].dropna()
    
    # Fit Isolation Forest model
    iso_forest = IsolationForest(contamination=0.1, random_state=42)  # 10% anomalies
    anomalies = iso_forest.fit_predict(df_anomaly)
    
    # Create a series of anomalies with the same index as the input data
    anomaly_series = pd.Series([-1] * len(employee_data), index=employee_data.index)
    anomaly_series.loc[df_anomaly.index] = anomalies
    return anomaly_series

# Apply anomaly detection for hours
df_time['Hours Anomaly'] = df_time.groupby('Employee Name', group_keys=False).apply(detect_hours_anomalies)

# Apply anomaly detection for time entry delays
df_time['Time Entry Delay Anomaly'] = df_time.groupby('Employee Name', group_keys=False).apply(detect_time_entry_delay_anomalies)

# Summary of hours anomalies by employee
def calculate_hours_anomaly_summary(group):
    return pd.Series({
        'Total Records': len(group),
        'Hours Anomalies': (group['Hours Anomaly'] == -1).sum(),
        'Hours Anomaly Percentage': (group['Hours Anomaly'] == -1).mean() * 100,
        'Average Hours': group['Hours'].mean(),
        'Max Hours': group['Hours'].max()
    })

hours_anomaly_summary = df_time.groupby('Employee Name').apply(calculate_hours_anomaly_summary).reset_index()
hours_anomaly_summary = hours_anomaly_summary.sort_values('Hours Anomaly Percentage', ascending=False)

# Summary of time entry delay anomalies by employee
def calculate_time_entry_delay_summary(group):
    return pd.Series({
        'Total Records': len(group),
        'Delay Anomalies': (group['Time Entry Delay Anomaly'] == -1).sum(),
        'Delay Anomaly Percentage': (group['Time Entry Delay Anomaly'] == -1).mean() * 100,
        'Average Time Entry Delay (Days)': group['Time Entry Delay'].mean(),
        'Max Time Entry Delay (Days)': group['Time Entry Delay'].max()
    })

time_entry_delay_summary = df_time.groupby('Employee Name').apply(calculate_time_entry_delay_summary).reset_index()
time_entry_delay_summary = time_entry_delay_summary.sort_values('Delay Anomaly Percentage', ascending=False)

print("Hours Anomaly Summary:")
print(hours_anomaly_summary)

print("\nTime Entry Delay Anomaly Summary:")
print(time_entry_delay_summary)

# Visualize anomalies for a specific employee
def plot_employee_anomalies(employee_name):
    employee_data = df_time[df_time['Employee Name'] == employee_name]
    
    # Hours Anomalies Plot
    plt.figure(figsize=(15, 10))
    
    plt.subplot(2, 2, 1)
    sns.scatterplot(
        data=employee_data, 
        x='Hours', 
        y='Std. Price', 
        hue='Hours Anomaly', 
        palette={1: "blue", -1: "red"}
    )
    plt.title(f"Hours Anomalies for {employee_name}")
    plt.xlabel("Hours Logged")
    plt.ylabel("Standard Price")
    plt.legend(title="Anomaly", labels=["Normal", "Anomalous"])
    
    # Time Entry Delay Anomalies Plot
    plt.subplot(2, 2, 2)
    sns.scatterplot(
        data=employee_data, 
        x='Work Date', 
        y='Time Entry Delay', 
        hue='Time Entry Delay Anomaly', 
        palette={1: "blue", -1: "red"}
    )
    plt.title(f"Time Entry Delays for {employee_name}")
    plt.xlabel("Work Date")
    plt.ylabel("Time Entry Delay (Days)")
    plt.xticks(rotation=45)
    plt.legend(title="Anomaly", labels=["Normal", "Anomalous"])
    
    # Hours Distribution
    plt.subplot(2, 2, 3)
    sns.boxplot(data=employee_data, y='Hours')
    plt.title(f"Hours Distribution for {employee_name}")
    plt.ylabel("Hours")
    
    # Time Entry Delay Distribution
    plt.subplot(2, 2, 4)
    sns.boxplot(data=employee_data, y='Time Entry Delay')
    plt.title(f"Time Entry Delay Distribution for {employee_name}")
    plt.ylabel("Time Entry Delay (Days)")
    
    plt.tight_layout()
    plt.show()

# Optional: Plot anomalies for specific employees
employee_names = ['Alice Dupont', 'Bastien Lefèvre']
for name in employee_names:
    plot_employee_anomalies(name)

# Identify employees with significant issues
significant_hours_anomaly_employees = hours_anomaly_summary[
    (hours_anomaly_summary['Hours Anomaly Percentage'] > 20) | 
    (hours_anomaly_summary['Max Hours'] > 12)
]

significant_delay_employees = time_entry_delay_summary[
    (time_entry_delay_summary['Delay Anomaly Percentage'] > 10) | # More than 10% of the entries must be anomalous
    (time_entry_delay_summary['Max Time Entry Delay (Days)'] > 14) # Delay for time entry must be greater than 2 weeks
]

print("\nEmployees with Significant Hours Anomaly Issues:")
print(significant_hours_anomaly_employees)

print("\nEmployees with Significant Time Entry Delay Issues:")
print(significant_delay_employees)