import pandas as pd
import numpy as np
from datetime import datetime
from pandas.tseries.offsets import BDay
import os
from pathlib import Path
import sys
import logging

# Add parent directories to path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent.parent
shared_dir = project_root / "scripts" / "shared"
sys.path.append(str(shared_dir))

# Import from shared modules
from config import TRANSFORMED_DIR

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class DataEnricher:
    """
    Enriches transformed data with additional calculations and derived values.
    This module specifically focuses on adding realistic dates to phases based on
    all the data now available in CSV files.
    """
    
    def __init__(self, csv_dir=TRANSFORMED_DIR):
        """
        Initialize the DataEnricher with the directory containing transformed CSV files.
        
        Args:
            csv_dir: Path to directory containing transformed CSV files
        """
        self.csv_dir = csv_dir
        self.data = {}
        self.default_chargeout_rate = 1000
        self.default_headcount = 3
        self.default_working_hours = 8
        
        # Staff level rates for fallback calculations
        self.staff_level_rates = {
            'STAFF ACCOUNTANT/CONSULTA': 800,
            'SPECIALIST/SENIOR CONSULT': 1100,
            'MANAGER': 1400,
            'SENIOR MANAGER': 1700,
            'DIRECTOR': 2000,
            'PARTNER': 2500
        }
        
        logger.info("DataEnricher initialized")
    
    def load_data(self):
        """Load all required CSV files for enrichment"""
        required_files = ['phases', 'staffing', 'timesheets', 'charge_out_rates', 'employees', 'engagements']
        
        for file_name in required_files:
            csv_path = self.csv_dir / f"{file_name}.csv"
            if os.path.exists(csv_path):
                try:
                    self.data[file_name] = pd.read_csv(csv_path, na_values='NULL')
                    logger.info(f"Loaded {len(self.data[file_name])} rows from {file_name}.csv")
                except Exception as e:
                    logger.error(f"Error loading {file_name}.csv: {e}")
                    self.data[file_name] = pd.DataFrame()
            else:
                logger.warning(f"CSV file not found: {csv_path}")
                self.data[file_name] = pd.DataFrame()
    
    def enrich_phase_dates(self):
        """
        Calculate realistic phase dates based on budget, staffing, and first logged work dates.
        Saves updated phases CSV with improved dates.
        """
        if not self.data:
            self.load_data()
        
        if self.data['phases'].empty:
            logger.warning("No phase data available to enrich")
            return False
        
        phases_df = self.data['phases'].copy()
        
        # 1. Extract first logged work dates from timesheet data
        phase_start_dates = {}
        if not self.data['timesheets'].empty:
            logger.info("Extracting first logged work dates from timesheet data")
            
            # Ensure work_date is datetime
            self.data['timesheets']['work_date'] = pd.to_datetime(self.data['timesheets']['work_date'], errors='coerce')
            
            # Get earliest work date per phase
            first_dates = self.data['timesheets'].groupby(['eng_no', 'eng_phase'])['work_date'].min().reset_index()
            
            # Create a dictionary for lookup
            for _, row in first_dates.iterrows():
                if pd.notna(row['work_date']):
                    phase_start_dates[(row['eng_no'], row['eng_phase'])] = row['work_date']
            
            logger.info(f"Found first logged work dates for {len(phase_start_dates)} phases")
        
        # 2. Calculate weighted rates
        # Create a copy to avoid modifying the original
        phases = phases_df.copy()
        
        # Clean budget values - replace NaN with default
        phases['budget'] = phases['budget'].fillna(1000000)
        
        # Calculate staffing headcount per phase
        if not self.data['staffing'].empty:
            headcounts = (
                self.data['staffing'].groupby(["eng_no", "eng_phase"])["personnel_no"]
                .nunique()
                .reset_index()
                .rename(columns={"personnel_no": "headcount"})
            )
            phases = pd.merge(phases, headcounts, on=["eng_no", "eng_phase"], how="left")
        else:
            phases['headcount'] = self.default_headcount
        
        # Fill missing headcounts with default value and ensure it's never zero
        phases['headcount'] = phases['headcount'].fillna(self.default_headcount)
        phases['headcount'] = phases['headcount'].replace(0, self.default_headcount)
        
        # Set default weighted rates
        phases['weighted_rate'] = self.default_chargeout_rate
        
        # Calculate weighted average chargeout rates
        if not self.data['charge_out_rates'].empty and not self.data['staffing'].empty:
            logger.info("Calculating weighted chargeout rates from charge_out_rates and staffing")
            
            # Create a dictionary to store weighted rates by phase
            weighted_rates = {}
            
            for idx, phase_row in phases.iterrows():
                eng_no = phase_row['eng_no']
                eng_phase = phase_row['eng_phase']
                
                phase_staffing = self.data['staffing'][
                    (self.data['staffing']['eng_no'] == eng_no) & 
                    (self.data['staffing']['eng_phase'] == eng_phase)
                ]
                
                if phase_staffing.empty:
                    weighted_rates[(eng_no, eng_phase)] = self.default_chargeout_rate
                    continue
                
                personnel_nos = phase_staffing['personnel_no'].unique()
                
                phase_rates = self.data['charge_out_rates'][
                    (self.data['charge_out_rates']['eng_no'] == eng_no) & 
                    (self.data['charge_out_rates']['personnel_no'].isin(personnel_nos))
                ]
                
                if phase_rates.empty:
                    weighted_rates[(eng_no, eng_phase)] = self.default_chargeout_rate
                    continue
                
                hours_by_person = phase_staffing.groupby('personnel_no')['planned_hours'].sum()
                
                total_weighted_rate = 0
                total_hours = 0
                
                for person_id, hours in hours_by_person.items():
                    rate_rows = phase_rates[phase_rates['personnel_no'] == person_id]
                    if not rate_rows.empty:
                        rate = rate_rows['standard_chargeout_rate'].iloc[0]
                        total_weighted_rate += rate * hours
                        total_hours += hours
                
                if total_hours > 0:
                    weighted_rates[(eng_no, eng_phase)] = total_weighted_rate / total_hours
                else:
                    weighted_rates[(eng_no, eng_phase)] = self.default_chargeout_rate
            
            # Apply the weighted rates to the phases DataFrame
            phases['weighted_rate'] = phases.apply(
                lambda row: weighted_rates.get((row['eng_no'], row['eng_phase']), self.default_chargeout_rate), 
                axis=1
            )
        
        # Ensure weighted rates are valid (no zeros or NaNs)
        phases['weighted_rate'] = phases['weighted_rate'].replace(0, self.default_chargeout_rate)
        phases['weighted_rate'] = phases['weighted_rate'].fillna(self.default_chargeout_rate)
        
        # 3. Calculate durations using Appendix 4 formula from README
        # Hours_required_est = phases.budget / Weighted_Rate
        phases['effort_hours'] = phases['budget'] / phases['weighted_rate']
        logger.info("Calculated effort_hours using formula from README Appendix 4")
        
        # Handle potential NaN or Inf values in effort_hours
        phases['effort_hours'] = phases['effort_hours'].fillna(160)  # Default to 160 hours (4 weeks)
        phases['effort_hours'] = phases['effort_hours'].replace([np.inf, -np.inf], 160)
        
        # Duration_est = Hours_required_est / (staff_count * daily_hours)
        # Exact formula from README Appendix 4
        duration_days = phases['effort_hours'] / (phases['headcount'] * self.default_working_hours)
        logger.info("Calculated duration_days using formula from README Appendix 4")
        
        # Handle NaN and Inf values before conversion to int
        duration_days = duration_days.fillna(20)  # Default to 20 business days (4 weeks)
        duration_days = duration_days.replace([np.inf, -np.inf], 20)
        
        # Round to nearest integer for business days calculation
        phases['duration_days'] = duration_days.round().fillna(20).astype(int)
        
        # Make sure duration is at least 5 days (1 week) for any phase
        phases['duration_days'] = phases['duration_days'].apply(lambda x: max(x, 5))
        
        # 4. Assign start and end dates with first logged work date priority (per README)
        phases = phases.sort_values(['eng_no', 'eng_phase'])
        phases['new_start_date'] = phases['start_date']
        phases['new_end_date'] = phases['end_date']
        
        reference_date = pd.Timestamp('2025-01-01')
        
        # Group by engagement to calculate progressive phase dates
        for eng_no, eng_group in phases.groupby('eng_no'):
            start_date = reference_date
            
            # For each phase in the engagement
            for idx, row in eng_group.iterrows():
                eng_phase = row['eng_phase']
                
                # FIRST PRIORITY: Use first logged work date if available (per README requirement)
                if (eng_no, eng_phase) in phase_start_dates:
                    # "Phase Start Date is the First Logged Work Date" (README rule)
                    start_date = phase_start_dates[(eng_no, eng_phase)]
                    phases.at[idx, 'new_start_date'] = start_date
                    
                    # Calculate end date using BUSINESS days (BDay) from start date
                    # This ensures weekends are skipped in the duration calculation
                    end_date = start_date + BDay(row['duration_days'])
                    phases.at[idx, 'new_end_date'] = end_date
                    
                    # Next phase processing logic for sequential phases
                    next_phase_idx = eng_group.index.get_indexer([idx])[0] + 1
                    if next_phase_idx < len(eng_group.index):
                        next_idx = eng_group.index[next_phase_idx]
                        next_eng_phase = eng_group.loc[next_idx, 'eng_phase']
                        
                        if (eng_no, next_eng_phase) in phase_start_dates:
                            # If next phase has its own logged date, respect that
                            start_date = phase_start_dates[(eng_no, next_eng_phase)]
                        else:
                            # Otherwise use current phase end + 1 business day
                            start_date = end_date + BDay(1)
                
                # SECOND PRIORITY: Use existing dates if they're not null
                elif pd.notna(row['start_date']) and pd.notna(row['end_date']):
                    # Keep existing start date
                    start_date = pd.to_datetime(row['start_date'])
                    phases.at[idx, 'new_start_date'] = start_date
                    
                    # Recalculate end date using business days and duration formula
                    end_date = start_date + BDay(row['duration_days'])
                    phases.at[idx, 'new_end_date'] = end_date
                    
                    # Next phase starts after this one
                    start_date = end_date + BDay(1)
                
                # THIRD PRIORITY: Generate progressive dates
                else:
                    phases.at[idx, 'new_start_date'] = start_date
                    
                    # Calculate end date using business days
                    end_date = start_date + BDay(row['duration_days'])
                    phases.at[idx, 'new_end_date'] = end_date
                    
                    # Next phase starts 1 business day after this phase ends
                    start_date = end_date + BDay(1)
        
        # Update the phases dataframe with new dates
        phases_df['start_date'] = pd.to_datetime(phases['new_start_date'])
        phases_df['end_date'] = pd.to_datetime(phases['new_end_date'])
        
        # 5. Save the updated phases data
        phases_csv = self.csv_dir / "phases.csv"
        phases_df.to_csv(phases_csv, index=False)
        logger.info(f"Updated phases.csv with enriched dates for {len(phases_df)} phases")
        
        # Calculate how many dates came from timesheet data
        timesheet_dates_count = sum(1 for idx, row in phases_df.iterrows() 
                                  if (row['eng_no'], row['eng_phase']) in phase_start_dates)
        logger.info(f"Used {timesheet_dates_count} dates from timesheet data (first logged work dates)")
        
        return True

    def enrich_engagement_dates(self):
        """
        Calculate realistic engagement dates based on their phases.
        Ensures engagement dates span all of their phases.
        """
        if not self.data:
            self.load_data()
        
        if self.data['engagements'].empty or self.data['phases'].empty:
            logger.warning("No engagement or phase data available to enrich")
            return False
        
        engagements_df = self.data['engagements'].copy()
        phases_df = self.data['phases'].copy()
        
        # Get phases start and end dates by engagement
        logger.info("Calculating engagement dates that span all phases")
        
        # Convert dates to datetime
        phases_df['start_date'] = pd.to_datetime(phases_df['start_date'], errors='coerce')
        phases_df['end_date'] = pd.to_datetime(phases_df['end_date'], errors='coerce')
        
        # Group phases by engagement to find earliest start and latest end date
        phase_span = phases_df.groupby('eng_no').agg({
            'start_date': 'min',
            'end_date': 'max'
        }).reset_index()
        
        # If we have strategic project data (not required), we could use it here
        # to set strategic_weight and risk_coefficient
        
        # Merge engagement data with phase span
        engagements_df['eng_no'] = pd.to_numeric(engagements_df['eng_no'], errors='coerce')
        phase_span['eng_no'] = pd.to_numeric(phase_span['eng_no'], errors='coerce')
        
        # Update engagement dates where phase data is available
        for idx, eng in engagements_df.iterrows():
            eng_no = eng['eng_no']
            span = phase_span[phase_span['eng_no'] == eng_no]
            
            if not span.empty:
                # Update engagement dates to span all phases
                if pd.notna(span['start_date'].iloc[0]):
                    engagements_df.at[idx, 'start_date'] = span['start_date'].iloc[0]
                
                if pd.notna(span['end_date'].iloc[0]):
                    engagements_df.at[idx, 'end_date'] = span['end_date'].iloc[0]
        
        # Set any remaining NULL dates to reasonable defaults
        for idx, eng in engagements_df.iterrows():
            if pd.isna(eng['start_date']) or pd.isna(eng['end_date']):
                # Generate synthetic dates based on index to spread throughout the year
                month = (idx % 12) + 1  # 1-12
                day = min((idx % 28) + 1, 28)  # 1-28
                
                # Default to 2025 for projects
                start_date = pd.Timestamp(f'2025-{month:02d}-{day:02d}')
                
                # Project duration of 3-6 months
                duration_days = 90 + (idx % 90)  # 90-180 days
                end_date = start_date + pd.Timedelta(days=duration_days)
                
                if pd.isna(eng['start_date']):
                    engagements_df.at[idx, 'start_date'] = start_date
                
                if pd.isna(eng['end_date']):
                    engagements_df.at[idx, 'end_date'] = end_date
        
        # Ensure engagement dates are always valid (start < end)
        for idx, eng in engagements_df.iterrows():
            start = pd.to_datetime(eng['start_date']) 
            end = pd.to_datetime(eng['end_date'])
            
            if start >= end:
                # Add at least 30 days if end date is not after start date
                engagements_df.at[idx, 'end_date'] = start + pd.Timedelta(days=30)
        
        # Set strategic_weight and risk_coefficient to reasonable defaults if missing
        if 'strategic_weight' in engagements_df.columns:
            engagements_df['strategic_weight'] = engagements_df['strategic_weight'].fillna(1.0)
        
        if 'risk_coefficient' in engagements_df.columns:
            engagements_df['risk_coefficient'] = engagements_df['risk_coefficient'].fillna(1.0)
        
        # Save the enriched engagements data
        engagements_csv = self.csv_dir / "engagements.csv"
        engagements_df.to_csv(engagements_csv, index=False)
        logger.info(f"Updated engagements.csv with enriched dates for {len(engagements_df)} engagements")
        
        return True

    def generate_resource_kpis(self):
        """
        Generate resource KPIs for all employees and save to a CSV file.
        
        Calculates:
        - Weekly Benching Rate: (1 - planned_hours/capacity) * 100%
        - Weekly Capacity Utilization Rate: (actual_hours/capacity) * 100%
        - Weekly Assignment Realization Rate: actual_hours/planned_hours
        
        Note: "capacity" is defined as the employment_basis (weekly contracted hours) for each employee
        """
        # Use the first Monday of March 2025 instead of today
        # This ensures alignment with the available timesheet data (ending March 14, 2025)
        current_week_start = pd.Timestamp('2025-03-03')  # First Monday of March 2025
        
        print(f"╔════════════════════════════════════════════════════════════════╗")
        print(f"║ Calculating KPIs for week starting: {current_week_start.strftime('%Y-%m-%d')} ║")
        print(f"╚════════════════════════════════════════════════════════════════╝")
        logger.info(f"Calculating KPIs for week starting: {current_week_start.date()}")
        
        # Read CSV files directly to ensure we have the latest data
        try:
            # Read employees CSV 
            employees_path = self.csv_dir / "employees.csv"
            if not os.path.exists(employees_path):
                logger.error(f"Employees CSV not found at {employees_path}")
                return False
            employees_df = pd.read_csv(employees_path)
            print(f"Loaded {len(employees_df)} employees from CSV")
            
            # Read staffing CSV
            staffing_path = self.csv_dir / "staffing.csv"
            if os.path.exists(staffing_path):
                staffing_df = pd.read_csv(staffing_path)
                staffing_df['week_start_date'] = pd.to_datetime(staffing_df['week_start_date'])
                print(f"Loaded {len(staffing_df)} staffing records from CSV")
                
                # Show available weeks for debugging
                unique_weeks = staffing_df['week_start_date'].drop_duplicates().sort_values()
                print(f"Available staffing weeks: {[week.strftime('%Y-%m-%d') for week in unique_weeks]}")
            else:
                logger.warning(f"Staffing CSV not found at {staffing_path}")
                staffing_df = pd.DataFrame(columns=['personnel_no', 'eng_no', 'eng_phase', 'week_start_date', 'planned_hours'])
            
            # Read timesheets CSV 
            timesheets_path = self.csv_dir / "timesheets.csv"
            if os.path.exists(timesheets_path):
                timesheets_df = pd.read_csv(timesheets_path)
                timesheets_df['work_date'] = pd.to_datetime(timesheets_df['work_date'])
                print(f"Loaded {len(timesheets_df)} timesheet records from CSV")
                
                # Show date range for debugging
                min_date = timesheets_df['work_date'].min()
                max_date = timesheets_df['work_date'].max()
                print(f"Timesheet date range: {min_date.strftime('%Y-%m-%d')} to {max_date.strftime('%Y-%m-%d')}")
            else:
                logger.warning(f"Timesheets CSV not found at {timesheets_path}")
                timesheets_df = pd.DataFrame(columns=['personnel_no', 'eng_no', 'eng_phase', 'work_date', 'hours'])
            
        except Exception as e:
            logger.error(f"Error reading CSV files: {e}")
            print(f"Error reading CSV files: {e}")
            return False
        
        # Prepare results dataframe
        results = []
        print("\nCalculating KPIs for each employee:")
        print("=" * 80)
        
        # Iterate through each employee
        for _, emp in employees_df.iterrows():
            personnel_no = emp['personnel_no']
            # employment_basis represents the weekly capacity of the employee (contracted hours)
            capacity = emp.get('employment_basis', 40.0)  # Default to 40 hours if not set
            
            # Get planned hours for this employee for the current week
            employee_staffing = staffing_df[
                (staffing_df['personnel_no'] == personnel_no) & 
                (staffing_df['week_start_date'] == current_week_start)
            ]
            planned_hours = employee_staffing['planned_hours'].sum() if not employee_staffing.empty else 0
            
            # Get actual hours for this employee for the current week
            week_end = current_week_start + pd.Timedelta(days=6)
            employee_timesheets = timesheets_df[
                (timesheets_df['personnel_no'] == personnel_no) & 
                (timesheets_df['work_date'] >= current_week_start) & 
                (timesheets_df['work_date'] <= week_end)
            ]
            actual_hours = employee_timesheets['hours'].sum() if not employee_timesheets.empty else 0
            
            # Calculate KPIs with safe division
            try:
                # 1. Weekly Benching Rate = (1 - (planned_hours/capacity)) * 100%
                benching_rate = 100.0  # Default to 100% if no planned hours
                if capacity > 0:
                    utilization_ratio = min(planned_hours / capacity, 1.0)  # Cap at 100%
                    benching_rate = (1 - utilization_ratio) * 100
                
                # 2. Weekly Capacity Utilization Rate = (actual_hours/capacity) * 100%
                capacity_utilization = 0.0  # Default to 0% if no actual hours
                if capacity > 0:
                    capacity_utilization = (actual_hours / capacity) * 100
                
                # 3. Weekly Assignment Realization Rate = actual_hours/planned_hours
                assignment_realization = 0.0  # Default to 0 if no planned hours
                if planned_hours > 0:
                    assignment_realization = actual_hours / planned_hours
            except Exception as e:
                logger.error(f"Error calculating KPIs for employee {personnel_no}: {e}")
                benching_rate = 0.0
                capacity_utilization = 0.0
                assignment_realization = 0.0
            
            # Debug output for verification
            if personnel_no == employees_df['personnel_no'].iloc[0]:  # Show first employee as example
                print(f"Example calculation for employee {personnel_no}:")
                print(f"  - Employment basis (weekly capacity): {capacity} hours")
                print(f"  - Planned hours: {planned_hours}")
                print(f"  - Actual hours: {actual_hours}")
                print(f"  - Weekly Benching Rate: (1 - {planned_hours}/{capacity}) * 100 = {benching_rate:.2f}%")
                print(f"  - Weekly Capacity Utilization: ({actual_hours}/{capacity}) * 100 = {capacity_utilization:.2f}%")
                print(f"  - Weekly Assignment Realization: {actual_hours}/{planned_hours} = {assignment_realization:.2f}")
                print()
            
            # Add only the requested fields to results
            results.append({
                'personnel_no': personnel_no,
                'weekly_benching_rate': round(benching_rate, 2),
                'weekly_capacity_utilization': round(capacity_utilization, 2),
                'weekly_assignment_realization': round(assignment_realization, 2)
            })
        
        # Convert to dataframe
        results_df = pd.DataFrame(results)
        
        # Print summary statistics
        print("\nKPI Summary Statistics:")
        print("=" * 80)
        avg_benching = results_df['weekly_benching_rate'].mean()
        avg_utilization = results_df['weekly_capacity_utilization'].mean()
        avg_realization = results_df['weekly_assignment_realization'].mean()
        
        print(f"Average Weekly Benching Rate: {avg_benching:.2f}%")
        print(f"Average Weekly Capacity Utilization Rate: {avg_utilization:.2f}%")
        print(f"Average Weekly Assignment Realization Rate: {avg_realization:.2f}")
        
        # Save to CSV file
        output_file = self.csv_dir / "resource_kpi.csv"
        results_df.to_csv(output_file, index=False)
        print(f"\nResource KPIs saved to: {output_file}")
        
        logger.info(f"Resource KPIs generated for {len(results_df)} employees and saved to {output_file}")
        return True

    def enrich_all(self):
        """Run all enrichment processes"""
        self.load_data()
        
        # Enrich phases first, then engagements to ensure proper relationships
        phase_success = self.enrich_phase_dates()
        
        # Reload phases after enrichment to ensure we're using updated data
        if phase_success:
            self.data['phases'] = pd.read_csv(self.csv_dir / "phases.csv", na_values='NULL')
        
        # Now enrich engagements based on the updated phases
        engagement_success = self.enrich_engagement_dates()
        
        # Generate resource KPIs
        kpi_success = self.generate_resource_kpis()
        
        if phase_success and engagement_success and kpi_success:
            logger.info("Data enrichment completed successfully")
        else:
            logger.warning("Data enrichment completed with some issues")

def main():
    """Main function to run the enricher"""
    enricher = DataEnricher()
    enricher.enrich_all()

if __name__ == "__main__":
    main()
