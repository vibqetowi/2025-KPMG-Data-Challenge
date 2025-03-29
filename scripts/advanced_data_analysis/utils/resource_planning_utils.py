import pandas as pd
from datetime import datetime, timedelta
import sys

def analyze_project(eng_no, phase_code, df_budgets, df_time, df_staffing, current_week, rate_mapping, efficiency_buffer):
    """Analyze specific project's pacing and resource requirements"""
    # Convert inputs to correct types
    phase_code = int(phase_code)
    eng_no = str(eng_no)  # Ensure eng_no is string
    
    # Get project budget info
    project_data = df_budgets[
        (df_budgets['Eng. No.'].astype(str) == eng_no) & 
        (df_budgets['Eng. Phase'] == phase_code)
    ]
    
    if project_data.empty:
        print(f"\nError: Project with Eng. No. {eng_no} and Phase {phase_code} not found.")
        print("Available projects:")
        for _, row in df_budgets.iterrows():
            print(f"Eng. No.: {row['Eng. No.']} - Phase: {row['Eng. Phase']} - {row['Eng. Description']} - {row['Phase Description']}")
        return None
    
    project = project_data.iloc[0]
    
    # Calculate deadline based on weighted rate and BAC
    weighted_rate = (
        project['manager_pct'] * rate_mapping['MANAGER'] +
        project['senior_pct'] * rate_mapping['SENIOR MANAGER'] +
        project['assoc_pct'] * rate_mapping['SPECIALIST/SENIOR CONSULT']
    )
    
    total_hours = (project['BAC'] / weighted_rate) * efficiency_buffer
    weeks_needed = total_hours / 40  # Assuming 40-hour weeks
    
    # Get project start date from timesheet
    timesheet_data = df_time[
        (df_time['Eng. No.'].astype(str) == eng_no) & 
        (df_time['Eng. Phase'] == phase_code)
    ]
    
    start_date = timesheet_data['Work Date'].min()
    if pd.isna(start_date):
        start_date = pd.Timestamp.now()
    
    estimated_end_date = start_date + pd.Timedelta(weeks=weeks_needed)
    
    # Calculate this week's billing
    this_week_billing = timesheet_data[
        timesheet_data['Work Date'].dt.strftime('%d-%b') == current_week
    ]['EV'].sum()
    
    # Calculate weekly target to meet deadline
    weeks_remaining = (estimated_end_date - pd.Timestamp.now()).days / 7
    if weeks_remaining < 1:
        weeks_remaining = 1
    
    total_billed = timesheet_data['EV'].sum()
    weekly_target = (project['BAC'] - total_billed) / weeks_remaining
    
    return {
        'project_name': project['Eng. Description'],
        'phase_name': project['Phase Description'],
        'budget': project['BAC'],
        'start_date': start_date,
        'estimated_end_date': estimated_end_date,
        'total_hours_needed': total_hours,
        'this_week_billing': this_week_billing,
        'weekly_target': weekly_target,
        'weeks_remaining': weeks_remaining,
        'total_billed': total_billed
    }

def calculate_bench_rates(df_staffing, current_week, weekly_commitment):
    """Calculate bench rates by staff level for current week"""
    # Get available hours by staff level
    available = df_staffing.groupby('Staff Level')[current_week].sum()
    
    # Calculate bench hours (available - committed)
    bench_rates = pd.DataFrame({
        'Staff Level': weekly_commitment.index,
        'Available Hours': available[weekly_commitment.index],
        'Committed Hours': weekly_commitment['Weekly Hours'],
    })
    
    bench_rates['Bench Hours'] = bench_rates['Available Hours'] - bench_rates['Committed Hours']
    bench_rates['Bench Rate %'] = (bench_rates['Bench Hours'] / bench_rates['Available Hours'] * 100).round(2)
    
    return bench_rates

def calculate_external_needs(bench_rates):
    """Calculate external consultant needs"""
    external_needs = pd.DataFrame(columns=['Staff Level', 'Hours Needed'])
    
    for _, row in bench_rates.iterrows():
        if row['Bench Hours'] < 0:  # Negative bench hours mean we need external help
            external_needs = pd.concat([external_needs, pd.DataFrame({
                'Staff Level': [row['Staff Level']],
                'Hours Needed': [-row['Bench Hours']]
            })])
    
    return external_needs

# -------------------------------
# 1. Load & Clean Budgets.csv
# -------------------------------
budgets_path = r"C:\skibidi\kpmg\POC\data\Budgets.csv"
df_budgets = pd.read_csv(budgets_path)

# Clean headers & rename French columns
df_budgets.columns = df_budgets.columns.str.strip()
df_budgets.rename(columns={
    'Code phase': 'Eng. Phase',
    'Nom de projet': 'Eng. Description',
    'Phase Projet': 'Phase Description',
    'Budget': 'BAC'
}, inplace=True)

# Clean BAC (remove $, commas) and convert to float
df_budgets['BAC'] = (
    df_budgets['BAC']
    .astype(str)
    .str.replace(',', '', regex=False)
    .str.replace('$', '', regex=False)
    .str.strip()
    .astype(float)
)

# Clean phase codes - convert to integers
def clean_phase_code(x):
    try:
        return int(str(x).strip().lstrip('0') or '0')
    except:
        return 0

df_budgets['Eng. Phase'] = df_budgets['Eng. Phase'].apply(clean_phase_code)

# Set default split if not present
df_budgets['manager_pct'] = df_budgets.get('manager_pct', 0.30)
df_budgets['senior_pct'] = df_budgets.get('senior_pct', 0.40)
df_budgets['assoc_pct']  = df_budgets.get('assoc_pct', 0.30)

# -------------------------------
# 2. Load & Process Timesheet.csv
# -------------------------------
timesheet_path = r"C:\skibidi\kpmg\POC\data\TIMESHEET.csv"
df_time = pd.read_csv(timesheet_path)

# Clean phase codes - convert to integers
df_time['Eng. Phase'] = df_time['Eng. Phase'].apply(clean_phase_code)

# Ensure numeric types for Charge-Out Rate and Hours
df_time['Charge-Out Rate'] = pd.to_numeric(df_time['Charge-Out Rate'], errors='coerce')
df_time['Hours'] = pd.to_numeric(df_time['Hours'], errors='coerce')
df_time['Std. Price'] = pd.to_numeric(df_time['Std. Price'], errors='coerce')
df_time['Adm. Surcharge'] = pd.to_numeric(df_time['Adm. Surcharge'], errors='coerce')

# Convert date columns
for col in ['Posting Date', 'Time Entry Date', 'Work Date']:
    if col in df_time.columns:
        df_time[col] = pd.to_datetime(df_time[col], errors='coerce')

# Add EV and Actual Cost if needed
df_time['EV'] = df_time['Charge-Out Rate'] * df_time['Hours']
df_time['Actual Cost'] = df_time['Std. Price'] + df_time['Adm. Surcharge']

# Calculate average rates by staff level
staff_rates = df_time.groupby('Staff Level')['Charge-Out Rate'].agg(['mean', 'count']).reset_index()
print("\nAverage Charge-Out Rates by Staff Level:")
print(staff_rates)

# Create rate mapping for all staff levels
rate_mapping = {}
for _, row in staff_rates.iterrows():
    rate_mapping[row['Staff Level']] = row['mean']

# Map staff levels to our categories
staff_level_mapping = {
    'MANAGER': 'MANAGER',
    'SENIOR MANAGER': 'SENIOR MANAGER',
    'SPECIALIST/SENIOR CONSULT': 'SPECIALIST/SENIOR CONSULT',
    'STAFF ACCOUNTANT/CONSULTA': 'SPECIALIST/SENIOR CONSULT'  # Map staff accountants to specialists
}

# -------------------------------
# 3. Load & Process Staffing Data
# -------------------------------
staffing_path = r"C:\skibidi\kpmg\POC\data\staffing_merged24_25.csv"
df_staffing = pd.read_csv(staffing_path)

# Get date columns (all columns after 'Staff Level')
date_cols = df_staffing.columns[df_staffing.columns.get_loc('Staff Level')+1:]

# Calculate weekly availability by staff level
weekly_availability = df_staffing.groupby('Staff Level')[date_cols].sum().reset_index()

# -------------------------------
# 4. Calculate Project Requirements
# -------------------------------
# Define efficiency buffer
efficiency_buffer = 1.05  # 5% buffer for efficiency loss

# Calculate weighted average rate for each project
df_budgets['weighted_rate'] = (
    df_budgets['manager_pct'] * rate_mapping['MANAGER'] +
    df_budgets['senior_pct'] * rate_mapping['SENIOR MANAGER'] +
    df_budgets['assoc_pct'] * rate_mapping['SPECIALIST/SENIOR CONSULT']
)

# Calculate total hours needed for each project (including buffer)
df_budgets['total_hours_needed'] = (df_budgets['BAC'] / df_budgets['weighted_rate']) * efficiency_buffer

# Calculate hours needed by staff level
df_budgets['manager_hours_req'] = df_budgets['total_hours_needed'] * df_budgets['manager_pct']
df_budgets['senior_hours_req'] = df_budgets['total_hours_needed'] * df_budgets['senior_pct']
df_budgets['assoc_hours_req'] = df_budgets['total_hours_needed'] * df_budgets['assoc_pct']

# -------------------------------
# 5. Calculate Weekly Commitments
# -------------------------------
# Get current week's availability
current_week = date_cols[0]  # Using first week as example
current_availability = weekly_availability[['Staff Level', current_week]].set_index('Staff Level')

# Calculate total required hours per staff level
total_requirements = pd.DataFrame({
    'Staff Level': ['MANAGER', 'SENIOR MANAGER', 'SPECIALIST/SENIOR CONSULT'],
    'Required Hours': [
        df_budgets['manager_hours_req'].sum(),
        df_budgets['senior_hours_req'].sum(),
        df_budgets['assoc_hours_req'].sum()
    ]
}).set_index('Staff Level')

# Calculate weekly commitment (assuming 52 weeks)
weekly_commitment = total_requirements.copy()
weekly_commitment['Weekly Hours'] = weekly_commitment['Required Hours'] / 52

# -------------------------------
# 6. Generate Staffing Recommendations
# -------------------------------
# Calculate utilization
utilization = pd.DataFrame({
    'Staff Level': ['MANAGER', 'SENIOR MANAGER', 'SPECIALIST/SENIOR CONSULT'],
    'Available Hours': current_availability.loc[['MANAGER', 'SENIOR MANAGER', 'SPECIALIST/SENIOR CONSULT'], current_week],
    'Weekly Commitment': weekly_commitment['Weekly Hours']
})
utilization['Utilization %'] = (utilization['Weekly Commitment'] / utilization['Available Hours'] * 100).round(2)

# -------------------------------
# 7. Output Results
# -------------------------------

if len(sys.argv) > 2:  # If project details provided
    eng_no = sys.argv[1]
    phase_code = sys.argv[2]
    
    # Analyze specific project
    project_analysis = analyze_project(eng_no, phase_code, df_budgets, df_time, df_staffing, current_week, rate_mapping, efficiency_buffer)
    
    if project_analysis:  # Only show analysis if project was found
        print("\n=== Project Drill-Down Analysis ===")
        print(f"Project: {project_analysis['project_name']} - Phase: {project_analysis['phase_name']}")
        print(f"Budget: ${project_analysis['budget']:,.2f}")
        print(f"\nTimeline:")
        print(f"Start Date: {project_analysis['start_date'].strftime('%Y-%m-%d')}")
        print(f"Estimated End Date: {project_analysis['estimated_end_date'].strftime('%Y-%m-%d')}")
        print(f"Weeks Remaining: {project_analysis['weeks_remaining']:.1f}")
        print(f"\nPacing:")
        print(f"Total Hours Needed: {project_analysis['total_hours_needed']:.1f}")
        print(f"Total Billed to Date: ${project_analysis['total_billed']:,.2f}")
        print(f"This Week's Billing: ${project_analysis['this_week_billing']:,.2f}")
        print(f"Weekly Target to Meet Deadline: ${project_analysis['weekly_target']:,.2f}")

# Calculate and display bench rates
bench_rates = calculate_bench_rates(df_staffing, current_week, weekly_commitment)
print("\n=== Bench Analysis ===")
print(f"Week: {current_week}")
print("\nBench Rates by Staff Level:")
print(bench_rates.to_string(index=False))

# Calculate external consultant needs
external_needs = calculate_external_needs(bench_rates)
if not external_needs.empty:
    print("\nExternal Consultant Needs:")
    print(external_needs.to_string(index=False))
else:
    print("\nNo external consultants needed - sufficient bench capacity")

print("\n=== Current Week Staffing Analysis ===")
print(f"Week: {current_week}")
print("\nWeekly Commitments vs Availability:")
print(utilization.to_string(index=False))

# Generate recommendations
print("\nStaffing Recommendations:")
for _, row in utilization.iterrows():
    staff_level = row['Staff Level']
    util = row['Utilization %']
    
    if util > 100:
        print(f"\n{staff_level}: Over-utilized by {util-100:.1f}%. Consider:")
        print(f"  - Adding more resources")
        print(f"  - Extending project timeline")
        print(f"  - Adjusting staff level mix")
    elif util < 70:
        print(f"\n{staff_level}: Under-utilized ({util:.1f}%). Consider:")
        print(f"  - Reallocating resources to other projects")
        print(f"  - Adjusting staff level mix")
    else:
        print(f"\n{staff_level}: Well-utilized ({util:.1f}%). Current allocation is appropriate.")
