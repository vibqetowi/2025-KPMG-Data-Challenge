import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os
import sys
import logging
from pathlib import Path
import pulp  # Make sure this import is at the top level
import io
import textwrap

# Set up path to include shared modules
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
sys.path.append(str(project_root))

# Import utilities using project-root relative imports
from scripts.advanced_data_analysis.utils.fetcher import DataFetcher
from scripts.shared.metric_utils import calculate_staffing_ratios, get_week_start_date, get_latest_work_date, get_reference_week_start
from scripts.advanced_data_analysis.utils.evm_metrics import (
    calculate_vec, calculate_spi, calculate_burn, 
    calculate_schedule_elapsed, calculate_planned_value, calculate_earned_value,
    compute_evm_metrics
)
from scripts.shared.config import OPT_PARAMS  # Import default optimization parameters

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class MILPResourceOptimizer:
    def __init__(self, target_week_start=None, db_connection_string=None):
        """
        Initialize the MILP Resource Optimizer.
        
        Args:
            target_week_start: The Monday date for which to optimize staffing (defaults to next Monday)
            db_connection_string: Database connection string
        """
        # Initialize DataFetcher first to enable data loading
        self.fetcher = DataFetcher(db_connection_string=db_connection_string)
        
        # Fetch timesheet data first to determine dates
        timesheet_data = self.fetcher.fetch_data(['timesheets'], {'timesheets': {}})['timesheets']
        
        # Set target week based on timesheet data if none specified
        if target_week_start is None:
            # First determine the reference date based on latest timesheet data
            reference_date = get_latest_work_date(timesheet_data)
            
            # Default to next Monday after the latest timesheet date
            next_monday = get_week_start_date(reference_date + timedelta(days=7))
            self.target_week = next_monday
            logger.info(f"Target week automatically set to next Monday after latest data: {self.target_week}")
        else:
            self.target_week = target_week_start
            if self.target_week.weekday() != 0:  # Not a Monday
                self.target_week = get_week_start_date(self.target_week)
                logger.info(f"Target week adjusted to nearest Monday: {self.target_week}")
        
        # Previous weeks for historical data (3-week window for rolling ratios)
        self.previous_week1 = self.target_week - timedelta(days=7)
        self.previous_week2 = self.target_week - timedelta(days=14)
        self.previous_week3 = self.target_week - timedelta(days=21)
        
        # Current date for filtering out future data - use latest timesheet date
        if timesheet_data is not None and not timesheet_data.empty:
            self.current_date = get_latest_work_date(timesheet_data)
            logger.info(f"Current date set to latest timesheet date: {self.current_date}")
        else:
            self.current_date = datetime.now().date()
            logger.warning(f"No timesheet data available, using system date: {self.current_date}")
        
        # Default optimization parameters from shared config
        self.default_params = OPT_PARAMS.copy()
        
        # Data containers
        self.employees = None
        self.engagements = None
        self.timesheets = None
        self.vacations = None
        self.actual_ratios = None
        self.opt_params = None
        self.previous_assignments = None
        self.evm_metrics = None
        self.target_engagements = None  # New: optional list of (eng_no, eng_phase) tuples to optimize
        self.using_fallback = False  # Flag to indicate if we're using fallback data

        # Add new visualization flag
        self.visualize_model = False  # Flag to control model visualization

    def load_data(self):
        """Load all necessary data using the DataFetcher"""
        logger.info(f"Loading data for target week starting {self.target_week}")
        
        # Define filters for efficient data retrieval
        engagement_filter = {
            'where_clause': f"""
                start_date <= '{self.target_week}' AND 
                (actual_end_date IS NULL OR actual_end_date >= '{self.target_week}')
            """
        }
        
        phases_filter = {
            'where_clause': f"""
                (end_date >= '{self.target_week}' OR actual_end_date >= '{self.target_week}')
            """
        }
        
        # Modified timesheet filter to get the past 3 weeks of data
        # Ensure we don't include future data
        today = self.current_date
        cutoff_date = min(self.target_week, today)  # Don't include future data
        
        timesheet_filter = {
            'where_clause': f"""
                work_date >= '{self.previous_week3}' AND 
                work_date < '{cutoff_date}'
            """
        }
        
        vacation_filter = {
            'where_clause': f"""
                start_date <= '{self.target_week + timedelta(days=6)}' AND
                end_date >= '{self.target_week}'
            """
        }
        
        # Get previous staffing data for the three previous weeks
        staffing_filter = {
            'where_clause': f"""
                week_start_date >= '{self.previous_week3}' AND 
                week_start_date < '{self.target_week}'
            """
        }
        
        # Fetch data with filters
        data = self.fetcher.fetch_data(
            tables=['employees', 'engagements', 'phases', 'timesheets', 
                    'vacations', 'optimization_parameters', 'staffing'],
            filters={
                'engagements': engagement_filter,
                'phases': phases_filter,
                'timesheets': timesheet_filter,
                'vacations': vacation_filter,
                'staffing': staffing_filter
            }
        )
        
        # Store fetched data
        self.employees = data['employees']
        self.engagements = data['engagements']
        
        # Join engagements with phases
        if not data['phases'].empty and not data['engagements'].empty:
            self.engagements = pd.merge(
                data['engagements'],
                data['phases'],
                on='eng_no',
                how='inner'
            )
        
        # Filter to target engagements if specified
        if self.target_engagements:
            logger.info(f"Filtering to {len(self.target_engagements)} target engagement-phase combinations")
            # Convert to set of tuples for faster lookups
            target_set = set((str(eng_no), int(eng_phase)) for eng_no, eng_phase in self.target_engagements)
            
            # Filter engagements DataFrame
            self.engagements = self.engagements[
                self.engagements.apply(
                    lambda row: (str(row['eng_no']), int(row['eng_phase'])) in target_set,
                    axis=1
                )
            ]
            
            if self.engagements.empty:
                logger.warning("No matching engagements found after filtering")
        
        self.timesheets = data['timesheets']
        self.vacations = data['vacations']
        self.opt_params = data['optimization_parameters']
        self.previous_assignments = data['staffing']
        
        # Calculate actual ratios using a 3-week rolling window
        self.calculate_rolling_ratios()
        
        # Calculate EVM metrics for active engagements
        self.calculate_evm_metrics()
        
        logger.info("Data loading complete")

    def calculate_rolling_ratios(self):
        """Calculate actual staffing ratios using a 3-week rolling window"""
        logger.info("Calculating rolling staffing ratios from the past 3 weeks")
        
        # Ensure timesheet data has datetime type for work_date
        if 'work_date' in self.timesheets.columns:
            # Use .loc to avoid SettingWithCopyWarning
            self.timesheets.loc[:, 'work_date'] = pd.to_datetime(self.timesheets['work_date'], errors='coerce')
        elif 'Work Date' in self.timesheets.columns:
            # Use .loc to avoid SettingWithCopyWarning
            self.timesheets.loc[:, 'Work Date'] = pd.to_datetime(self.timesheets['Work Date'], errors='coerce')
        
        # Filter timesheet data by each week and collect the ratios
        weeks_data = []
        
        # Define the weeks to analyze
        weeks = [
            (self.previous_week1, self.target_week),
            (self.previous_week2, self.previous_week1),
            (self.previous_week3, self.previous_week2)
        ]
        
        # Filter for current date - don't include future data
        today = self.current_date
        
        # Calculate ratios for each week and weight by recency
        all_ratios = []
        weights = [0.6, 0.3, 0.1]  # Weighting by recency - most recent week has highest weight
        
        for i, (start_date, end_date) in enumerate(weeks):
            # Don't include data after today
            if start_date > today:
                continue
                
            end_date = min(end_date, today + timedelta(days=1))  # Include today
            
            # Filter by this week's date range
            if 'work_date' in self.timesheets.columns:
                week_data = self.timesheets[
                    (self.timesheets['work_date'] >= start_date) & 
                    (self.timesheets['work_date'] < end_date)
                ].copy()  # Create an explicit copy to avoid warnings
            elif 'Work Date' in self.timesheets.columns:
                week_data = self.timesheets[
                    (self.timesheets['Work Date'] >= start_date) & 
                    (self.timesheets['Work Date'] < end_date)
                ].copy()  # Create an explicit copy to avoid warnings
            else:
                week_data = pd.DataFrame()
            
            # Skip if no data for this week
            if week_data.empty:
                continue
                
            # Calculate staffing ratios for this week
            week_ratios = calculate_staffing_ratios(
                week_data,
                self.employees,
                start_date=start_date,
                end_date=end_date
            )
            
            # Add weight for this week
            if not week_ratios.empty:
                week_ratios['weight'] = weights[i]
                all_ratios.append(week_ratios)
        
        # Combine the ratios from all weeks
        if all_ratios:
            combined_ratios = pd.concat(all_ratios, ignore_index=True)
            
            # Create a result list manually instead of using apply
            result = []
            for (eng_no, eng_phase, staff_level, practice_id), group in combined_ratios.groupby(['eng_no', 'eng_phase', 'staff_level', 'practice_id']):
                weighted_avg = (group['ratio'] * group['weight']).sum() / group['weight'].sum()
                result.append({
                    'eng_no': eng_no,
                    'eng_phase': eng_phase,
                    'staff_level': staff_level,
                    'practice_id': practice_id,
                    'ratio': weighted_avg
                })
            
            self.actual_ratios = pd.DataFrame(result)
            logger.info(f"Calculated weighted ratios across {len(all_ratios)} weeks of data")
        else:
            logger.warning("No data found in the past 3 weeks. Using default ratios.")
            self.create_default_ratios()

    def calculate_actual_ratios(self):
        """Calculate actual staffing ratios from previous week's timesheet data"""
        logger.info("Calculating actual staffing ratios from previous week")
        
        # Calculate staffing ratios using shared utility function
        self.actual_ratios = calculate_staffing_ratios(
            self.timesheets,
            self.employees,
            start_date=self.previous_week,
            end_date=self.target_week
        )
        
        # Handle cases where no previous data exists - use default ratios
        if self.actual_ratios.empty:
            logger.warning("No previous week data found. Using default ratios.")
            self.create_default_ratios()

    def create_default_ratios(self):
        """Create default ratios when no historical data is available"""
        # Simple defaults: 20% Partner, 30% Manager, 50% Staff
        # For practices, distribute evenly based on engagement's primary practice
        
        default_staff_levels = [
            {'staff_level': 'Partner', 'ratio': 0.2},
            {'staff_level': 'Manager', 'ratio': 0.3},
            {'staff_level': 'Staff', 'ratio': 0.5}
        ]
        
        ratios_list = []
        
        for _, eng in self.engagements.iterrows():
            # Add default staff level ratios
            for level_data in default_staff_levels:
                ratios_list.append({
                    'eng_no': eng['eng_no'],
                    'eng_phase': eng['eng_phase'],
                    'staff_level': level_data['staff_level'],
                    'practice_id': None,
                    'ratio': level_data['ratio']
                })
            
            # Add default practice ratio (100% primary practice)
            ratios_list.append({
                'eng_no': eng['eng_no'],
                'eng_phase': eng['eng_phase'],
                'staff_level': None,
                'practice_id': eng['primary_practice_id'],
                'ratio': 1.0
            })
        
        self.actual_ratios = pd.DataFrame(ratios_list)

    def calculate_evm_metrics(self):
        """Calculate EVM metrics for active engagements"""
        logger.info("Calculating EVM metrics for active engagements")
        
        try:
            # Use the actual reference date from timesheet data, not target week
            # This ensures metrics are calculated based on available data
            current_date = self.current_date
            
            # Compute EVM metrics - no fallbacks, if this fails we exit
            self.evm_metrics = compute_evm_metrics(current_date=current_date)
            
            if self.evm_metrics.empty:
                logger.error("EVM metrics calculation returned empty dataset - cannot proceed")
                return False
                
            logger.info(f"Successfully calculated EVM metrics for {len(self.evm_metrics)} engagements")
            return True
        except Exception as e:
            logger.error(f"Error calculating EVM metrics: {str(e)}")
            return False

    def calculate_adjusted_capacity(self):
        """Calculate adjusted capacity for each consultant based on vacations"""
        # Start with standard employment basis
        self.employees['adjusted_capacity'] = self.employees['employment_basis']
        
        # Adjust for vacations
        if not self.vacations.empty:
            for _, vacation in self.vacations.iterrows():
                # Get personnel_no and calculate days off from start_date and end_date
                personnel_no = vacation['personnel_no']
                
                # Calculate days_off from start_date and end_date
                if 'start_date' in vacation and 'end_date' in vacation:
                    start_date = pd.to_datetime(vacation['start_date'])
                    end_date = pd.to_datetime(vacation['end_date'])
                    # +1 because both start and end dates are inclusive
                    days_off = (end_date - start_date).days + 1
                    
                    # Only count weekdays (assuming Monday-Friday work week)
                    weekday_count = sum(1 for d in pd.date_range(start_date, end_date) if d.weekday() < 5)
                    days_off = min(weekday_count, 5)  # Cap at 5 days for a single week
                else:
                    # Default to 0 if dates are missing
                    days_off = 0
                
                # Find the employee
                if personnel_no in self.employees['personnel_no'].values:
                    employee_idx = self.employees[self.employees['personnel_no'] == personnel_no].index[0]
                    standard_capacity = self.employees.loc[employee_idx, 'employment_basis']
                    
                    # Calculate overlap with target week
                    target_week_start = self.target_week
                    target_week_end = target_week_start + timedelta(days=4)  # Friday
                    
                    # Check if vacation overlaps with target week
                    if (start_date <= target_week_end and end_date >= target_week_start):
                        # Calculate overlapping days
                        overlap_start = max(start_date, target_week_start)
                        overlap_end = min(end_date, target_week_end)
                        
                        # Count weekdays in the overlap
                        weekdays_in_overlap = sum(1 for d in pd.date_range(overlap_start, overlap_end) if d.weekday() < 5)
                        
                        # Reduce capacity proportionally (assuming 5-day work week)
                        reduction = standard_capacity * (weekdays_in_overlap / 5.0)
                        self.employees.loc[employee_idx, 'adjusted_capacity'] = max(0, standard_capacity - reduction)

    def get_optimization_parameters(self):
        """Get optimization parameters from database or use defaults"""
        params = self.default_params.copy()
        
        if not self.opt_params.empty:
            for _, param in self.opt_params.iterrows():
                key = param['parameter_key']
                value = param['parameter_value']
                if key in params:
                    params[key] = value
        
        logger.info(f"Using optimization parameters: {params}")
        return params

    def build_optimization_model(self):
        """Build the MILP optimization model using PuLP"""
        logger.info("Building optimization model")
        
        # Verify that we have EVM metrics - if not, we can't build a valid model
        if self.evm_metrics is None or self.evm_metrics.empty:
            logger.error("Cannot build optimization model without valid EVM metrics")
            return None, None
            
        # Get optimization parameters
        params = self.get_optimization_parameters()
        alpha = params['alpha']
        beta = params['beta']
        pse = params['pse']
        delta = params['delta']
        
        # Calculate adjusted capacity
        self.calculate_adjusted_capacity()
        
        # Create model
        model = pulp.LpProblem("Resource_Allocation", pulp.LpMaximize)
        
        # Decision variables
        # Hours[c, en, ph, w]: hours for consultant c on engagement en, phase ph in week w
        hours_vars = {}
        
        # is_switch[c, en, ph, w]: binary var indicating if consultant c starts work on engagement en in week w
        switch_vars = {}
        
        # Create decision variables
        for _, emp in self.employees.iterrows():
            c = emp['personnel_no']
            
            for _, eng in self.engagements.iterrows():
                en = eng['eng_no']
                ph = eng['eng_phase']
                
                # Hours variable (continuous)
                hours_vars[(c, en, ph)] = pulp.LpVariable(
                    f"Hours_{c}_{en}_{ph}", 
                    lowBound=0, 
                    upBound=emp['adjusted_capacity'],
                    cat=pulp.LpContinuous
                )
                
                # Switch variable (binary)
                switch_vars[(c, en, ph)] = pulp.LpVariable(
                    f"Switch_{c}_{en}_{ph}",
                    cat=pulp.LpBinary
                )
        
        # Prepare data structures for constraints
        # Group employees by their attributes
        employees_by_level = {}
        employees_by_practice = {}
        
        for _, emp in self.employees.iterrows():
            level = emp['staff_level']
            practice = emp['practice_id']
            c = emp['personnel_no']
            
            if level not in employees_by_level:
                employees_by_level[level] = []
            employees_by_level[level].append(c)
            
            if practice not in employees_by_practice:
                employees_by_practice[practice] = []
            employees_by_practice[practice].append(c)
        
        # OBJECTIVE FUNCTION
        # Use EVM metrics to create a more accurate objective function
        objective = 0
        
        # Engagement contribution terms (weighted by strategic_weight and risk_coefficient)
        for _, eng in self.engagements.iterrows():
            en = eng['eng_no']
            ph = eng['eng_phase']
            w_en = eng['strategic_weight']
            r_en = eng['risk_coefficient']
            
            # Create project key for looking up EVM metrics
            project_key = f"{en}_{ph}"
            
            # Get EVM metrics for this engagement if available
            eng_metrics = self.evm_metrics[self.evm_metrics['project_key'] == project_key]
            
            # Use metrics if available, otherwise use defaults
            spi_value = 1.0
            vec_value = 1.0
            if not eng_metrics.empty:
                spi_value = eng_metrics['spi'].iloc[0]
                vec_value = eng_metrics['vec'].iloc[0]
            
            # Sum of hours across all consultants for this engagement
            eng_sum_hours = pulp.lpSum([hours_vars[(c, en, ph)] for c in self.employees['personnel_no'] 
                                       if (c, en, ph) in hours_vars])
            
            # Calculate projected SPI and VEC contributions
            # Assumption: contribution is proportional to hours assigned relative to metrics
            proj_spi_contrib = spi_value * eng_sum_hours / 40.0  # Normalized by 40 hour baseline
            proj_vec_contrib = vec_value * eng_sum_hours / 40.0
            
            # Add to objective function
            objective += w_en * r_en * (alpha * proj_spi_contrib + beta * proj_vec_contrib)
        
        # Subtract switching penalty
        for (c, en, ph), switch_var in switch_vars.items():
            objective -= pse * switch_var
        
        model += objective
        
        # CONSTRAINTS
        
        # 1. Consultant Capacity: Sum of hours across all engagements <= adjusted capacity
        for _, emp in self.employees.iterrows():
            c = emp['personnel_no']
            capacity = emp['adjusted_capacity']
            
            model += (
                pulp.lpSum([hours_vars[(c, en, ph)] for en, ph in 
                           [(eng['eng_no'], eng['eng_phase']) for _, eng in self.engagements.iterrows()]
                           if (c, en, ph) in hours_vars]) <= capacity,
                f"Capacity_Constraint_{c}"
            )
        
        # 2. Staffing Ratio Tolerance Constraints
        for _, ratio in self.actual_ratios.iterrows():
            eng_no = ratio['eng_no']
            eng_phase = ratio['eng_phase']
            target_ratio = ratio['ratio']
            
            # Skip if target ratio is zero or not applicable
            if target_ratio <= 0 or eng_no not in self.engagements['eng_no'].values:
                continue
            
            # Staff level ratio constraint
            if pd.notna(ratio['staff_level']):
                level = ratio['staff_level']
                
                if level in employees_by_level:
                    # Sum of hours from consultants of this level on this engagement
                    level_hours = pulp.lpSum([hours_vars[(c, eng_no, eng_phase)] 
                                            for c in employees_by_level[level] 
                                            if (c, eng_no, eng_phase) in hours_vars])
                    
                    # Sum of hours from consultants not of this level on this engagement
                    other_hours = pulp.lpSum([hours_vars[(c, eng_no, eng_phase)] 
                                            for c in self.employees['personnel_no'] 
                                            if c not in employees_by_level[level] and (c, eng_no, eng_phase) in hours_vars])
                    
                    # Lower bound constraint: PlannedRatio >= TargetRatio * (1-delta)
                    model += (
                        (target_ratio * (1-delta) - 1) * level_hours + target_ratio * (1-delta) * other_hours <= 0,
                        f"Level_Ratio_LB_{eng_no}_{eng_phase}_{level}"
                    )
                    
                    # Upper bound constraint: PlannedRatio <= TargetRatio * (1+delta)
                    model += (
                        (1 - target_ratio * (1+delta)) * level_hours - target_ratio * (1+delta) * other_hours <= 0,
                        f"Level_Ratio_UB_{eng_no}_{eng_phase}_{level}"
                    )
            
            # Practice ratio constraint
            if pd.notna(ratio['practice_id']):
                practice = ratio['practice_id']
                
                if practice in employees_by_practice:
                    # Sum of hours from consultants of this practice on this engagement
                    practice_hours = pulp.lpSum([hours_vars[(c, eng_no, eng_phase)] 
                                              for c in employees_by_practice[practice] 
                                              if (c, eng_no, eng_phase) in hours_vars])
                    
                    # Sum of hours from consultants not of this practice on this engagement
                    other_hours = pulp.lpSum([hours_vars[(c, eng_no, eng_phase)] 
                                           for c in self.employees['personnel_no'] 
                                           if c not in employees_by_practice[practice] and (c, eng_no, eng_phase) in hours_vars])
                    
                    # Lower bound constraint: PlannedRatio >= TargetRatio * (1-delta)
                    model += (
                        (target_ratio * (1-delta) - 1) * practice_hours + target_ratio * (1-delta) * other_hours <= 0,
                        f"Practice_Ratio_LB_{eng_no}_{eng_phase}_{practice}"
                    )
                    
                    # Upper bound constraint: PlannedRatio <= TargetRatio * (1+delta)
                    model += (
                        (1 - target_ratio * (1+delta)) * practice_hours - target_ratio * (1+delta) * other_hours <= 0,
                        f"Practice_Ratio_UB_{eng_no}_{eng_phase}_{practice}"
                    )
        
        # 3. Switch Logic: Define when a consultant starts a new engagement
        for (c, en, ph), switch_var in switch_vars.items():
            # Check if consultant worked on this engagement in previous week
            prev_assignment = self.previous_assignments[
                (self.previous_assignments['personnel_no'] == c) & 
                (self.previous_assignments['eng_no'] == en) & 
                (self.previous_assignments['eng_phase'] == ph)
            ]
            
            worked_previously = not prev_assignment.empty and prev_assignment['planned_hours'].values[0] > 0
            
            # If consultant worked previously, switch=0 if hours>0, otherwise unconstrained
            if worked_previously:
                # Not a switch if continuing work (hours > 0)
                model += (
                    switch_var == 0,
                    f"Switch_Continuing_{c}_{en}_{ph}"
                )
            else:
                # Switch if starting work (hours > 0)
                M = emp['adjusted_capacity']  # Big-M value
                
                # is_switch = 1 if hours > 0
                model += (
                    hours_vars[(c, en, ph)] <= M * switch_var,
                    f"Switch_Logic1_{c}_{en}_{ph}"
                )
                
                model += (
                    switch_var <= hours_vars[(c, en, ph)] * 100,  # Scaled for numerical stability
                    f"Switch_Logic2_{c}_{en}_{ph}"
                )
        
        # 4. Internal Priority: External consultants assigned only if internal consultants fully utilized
        internal_employees = self.employees[self.employees['is_external'] == 0]['personnel_no'].tolist()
        external_employees = self.employees[self.employees['is_external'] == 1]['personnel_no'].tolist()
        
        # Skip if no external employees
        if external_employees:
            for _, eng in self.engagements.iterrows():
                en = eng['eng_no']
                ph = eng['eng_phase']
                
                # Sum of unused capacity for internal consultants
                internal_unused = pulp.lpSum([
                    emp['adjusted_capacity'] - pulp.lpSum([
                        hours_vars[(c, eng_no, eng_phase)] 
                        for eng_no, eng_phase in [(e['eng_no'], e['eng_phase']) for _, e in self.engagements.iterrows()]
                        if (c, eng_no, eng_phase) in hours_vars
                    ])
                    for c in internal_employees
                    for _, emp in self.employees[self.employees['personnel_no'] == c].iterrows()
                ])
                
                # Sum of hours for external consultants on this engagement
                external_hours = pulp.lpSum([
                    hours_vars[(c, en, ph)]
                    for c in external_employees
                    if (c, en, ph) in hours_vars
                ])
                
                # External consultants only used if internal capacity is fully utilized
                # Using a relaxed constraint with small tolerance
                tolerance = 5  # Allow 5 hours of slack
                
                # Fix: Use simple linear constraint instead of max()
                model += (
                    external_hours <= internal_unused - tolerance,
                    f"Internal_Priority_{en}_{ph}"
                )
        
        # 5. Benching Rate Constraint (optional)
        # Limit the total unassigned internal consultant hours
        # This is optional and parameters would need to be tuned
        
        # max_bench_rate = 0.15  # Max 15% bench time
        # total_internal_capacity = pulp.lpSum([
        #     emp['adjusted_capacity'] for _, emp in self.employees.iterrows() if emp['is_external'] == 0
        # ])
        
        # total_internal_assigned = pulp.lpSum([
        #     hours_vars[(c, en, ph)]
        #     for c in internal_employees
        #     for en, ph in [(eng['eng_no'], eng['eng_phase']) for _, eng in self.engagements.iterrows()]
        #     if (c, en, ph) in hours_vars
        # ])
        
        # model += (
        #     total_internal_capacity - total_internal_assigned <= max_bench_rate * total_internal_capacity,
        #     "Benching_Rate"
        # )
        
        # Add SPI threshold constraints if needed
        # Ensure projects with low SPI get minimum required attention
        min_spi_threshold = 0.85  # Projects with SPI < 0.85 need attention
        min_hours_for_troubled = 20.0  # Minimum weekly hours for troubled projects
        
        if self.evm_metrics is not None and not self.evm_metrics.empty:
            for _, metric in self.evm_metrics.iterrows():
                # Ignore any future-dated metrics or those with SPI >= threshold
                if pd.to_datetime(metric['current_date']) > pd.to_datetime(self.current_date) or metric['spi'] >= min_spi_threshold:
                    continue
                    
                en = metric['eng_no']
                ph = metric['eng_phase']
                
                # Sum of hours for this troubled project
                project_hours = pulp.lpSum([hours_vars[(c, en, ph)] for c in self.employees['personnel_no'] 
                                          if (c, en, ph) in hours_vars])
                
                # Ensure minimum hours to address schedule issues
                model += (
                    project_hours >= min_hours_for_troubled,
                    f"Min_Hours_For_Troubled_{en}_{ph}"
                )
        
        # If visualization is enabled, log more details about the model
        if self.visualize_model:
            logger.info(f"Building model with visualization for debugging")
            logger.info(f"Engagements: {len(self.engagements)}")
            logger.info(f"Employees: {len(self.employees)}")
            logger.info(f"Ratio constraints: {len(self.actual_ratios)}")
        
        return model, hours_vars
    
    def analyze_constraints(self, model):
        """
        Analyze constraints to find potential sources of infeasibility
        
        Args:
            model: The PuLP LpProblem model to analyze
            
        Returns:
            dict: Dictionary of potentially infeasible constraints and reasons
        """
        infeasible_constraints = {}
        
        # Check each constraint for potential infeasibility
        for name, constraint in model.constraints.items():
            # Extract constraint parts - use multiple approaches for better compatibility with different PuLP versions
            try:
                # Method 1: Try accessing through constraint's variables and coefficients
                lhs_terms = {}
                constant = 0
                
                # Get the left-hand side expression
                if hasattr(constraint, 'expr'):
                    expr = constraint.expr
                    
                    # Extract variables and coefficients from the expression
                    if hasattr(expr, 'items'):
                        for var, coef in expr.items():
                            if hasattr(var, 'name'):
                                lhs_terms[var.name] = coef
                    
                    # Get the constant term if available
                    if hasattr(expr, 'constant'):
                        constant = expr.constant
                    
                    # Get RHS (usually 0 since the constant is on the LHS)
                    rhs = 0
                
                # Method 2: Try accessing through toDict (newer PuLP)
                elif hasattr(constraint, 'toDict'):
                    dict_result = constraint.toDict()
                    if isinstance(dict_result, dict):
                        lhs_terms = dict_result.get(0, {})
                        rhs = dict_result.get(1, 0)
                    elif isinstance(dict_result, tuple) and len(dict_result) == 2:
                        lhs_terms, rhs = dict_result
                
                # Method 3: Use string representation parsing as last resort
                else:
                    logger.warning(f"Using fallback constraint parsing for {name}")
                    constraint_str = str(constraint)
                    # Simple parsing of PuLP constraint string (very brittle fallback)
                    parts = constraint_str.split('=')
                    # Skip constraints we can't parse this way
                    lhs_terms = {}
                    rhs = 0
                
                # Get constraint sense
                sense = constraint.sense if hasattr(constraint, 'sense') else 0
                
                # Check for obvious issues
                if "Level_Ratio" in name:
                    # These are common sources of infeasibility
                    infeasible_constraints[name] = {
                        'reason': "Staff level ratio constraint may be infeasible",
                        'suggestion': "Increase delta parameter to allow more flexibility in staff ratios"
                    }
                
                # Check practice ratio constraints
                if "Practice_Ratio" in name:
                    # Another common source of infeasibility
                    infeasible_constraints[name] = {
                        'reason': "Practice ratio constraint may be infeasible",
                        'suggestion': "Increase delta parameter or ensure sufficient staff from each practice"
                    }
                
                # Check capacity constraints
                if "Capacity_Constraint" in name:
                    # This would indicate insufficient capacity
                    employee_id = name.replace("Capacity_Constraint_", "")
                    suggestion = "Increase capacity for this consultant or distribute work to others"
                    
                    infeasible_constraints[name] = {
                        'reason': f"Consultant {employee_id} may have insufficient capacity",
                        'suggestion': suggestion
                    }
                
                # Check internal priority constraints
                if "Internal_Priority" in name:
                    # This could indicate conflict between internal priority and other constraints
                    eng_info = name.replace("Internal_Priority_", "")
                    infeasible_constraints[name] = {
                        'reason': f"Internal priority constraint for {eng_info} conflicts with other requirements",
                        'suggestion': "Relax internal priority constraint or increase internal capacity"
                    }
                    
                # Check troubled project constraints
                if "Min_Hours_For_Troubled" in name:
                    # These might be infeasible if there's not enough capacity
                    eng_info = name.replace("Min_Hours_For_Troubled_", "")
                    infeasible_constraints[name] = {
                        'reason': f"Minimum hours requirement for troubled project {eng_info} cannot be met",
                        'suggestion': "Reduce minimum hours requirement or increase available capacity"
                    }
            except Exception as e:
                logger.warning(f"Error analyzing constraint {name}: {str(e)}")
                # Add a generic entry for this constraint
                infeasible_constraints[name] = {
                    'reason': f"Unknown - error analyzing constraint: {str(e)}",
                    'suggestion': "Check model formulation and data"
                }
        
        # If we have more than 5 potential issues, just keep the most likely ones
        if len(infeasible_constraints) > 5:
            # Sort by likelihood of being the actual issue
            priority_types = ["Level_Ratio", "Practice_Ratio", "Capacity_Constraint", 
                              "Min_Hours_For_Troubled", "Internal_Priority"]
            
            # Filter to the top 5 most likely issues
            filtered_constraints = {}
            count = 0
            
            for priority_type in priority_types:
                for name, details in infeasible_constraints.items():
                    if priority_type in name and count < 5:
                        filtered_constraints[name] = details
                        count += 1
            
            infeasible_constraints = filtered_constraints
        
        return infeasible_constraints

    def export_model_visualization(self, model, vars_dict, output_path):
        """
        Export a detailed visualization of the model to help diagnose infeasibility
        
        Args:
            model: The PuLP LpProblem model to visualize
            vars_dict: Dictionary of decision variables
            output_path: Path to save the visualization
        """
        output = io.StringIO()
        
        # Model overview
        output.write("=== MILP MODEL VISUALIZATION ===\n\n")
        output.write(f"Problem name: {model.name}\n")
        output.write(f"Optimization direction: {model.sense}\n")
        output.write(f"Number of variables: {len(model.variables())}\n")
        output.write(f"Number of constraints: {len(model.constraints)}\n\n")
        
        # Variables summary
        output.write("=== VARIABLES ===\n\n")
        
        # Group variables by type
        hours_vars = [v for v in model.variables() if v.name.startswith("Hours_")]
        switch_vars = [v for v in model.variables() if v.name.startswith("Switch_")]
        other_vars = [v for v in model.variables() if not (v.name.startswith("Hours_") or v.name.startswith("Switch_"))]
        
        output.write(f"Hours variables: {len(hours_vars)}\n")
        output.write(f"Switch variables: {len(switch_vars)}\n")
        output.write(f"Other variables: {len(other_vars)}\n\n")
        
        # Sample of variables
        output.write("Sample of Hours variables:\n")
        for v in hours_vars[:5]:
            output.write(f"  {v.name}: {v.lowBound} <= x <= {v.upBound}, Category={v.cat}\n")
        
        output.write("\nSample of Switch variables:\n")
        for v in switch_vars[:5]:
            output.write(f"  {v.name}: {v.lowBound} <= x <= {v.upBound}, Category={v.cat}\n")
        
        # Constraints
        output.write("\n=== CONSTRAINTS ===\n\n")
        
        # Group constraints by type
        capacity_constraints = [c for name, c in model.constraints.items() if "Capacity_Constraint" in name]
        level_ratio_constraints = [c for name, c in model.constraints.items() if "Level_Ratio" in name]
        practice_ratio_constraints = [c for name, c in model.constraints.items() if "Practice_Ratio" in name]
        switch_constraints = [c for name, c in model.constraints.items() if "Switch" in name]
        internal_priority_constraints = [c for name, c in model.constraints.items() if "Internal_Priority" in name]
        troubled_project_constraints = [c for name, c in model.constraints.items() if "Min_Hours_For_Troubled" in name]
        other_constraints = [c for name, c in model.constraints.items() 
                             if not any(t in name for t in ["Capacity_Constraint", "Level_Ratio", "Practice_Ratio", 
                                                            "Switch", "Internal_Priority", "Min_Hours_For_Troubled"])]
        
        output.write(f"Capacity constraints: {len(capacity_constraints)}\n")
        output.write(f"Level ratio constraints: {len(level_ratio_constraints)}\n")
        output.write(f"Practice ratio constraints: {len(practice_ratio_constraints)}\n")
        output.write(f"Switch logic constraints: {len(switch_constraints)}\n")
        output.write(f"Internal priority constraints: {len(internal_priority_constraints)}\n")
        output.write(f"Troubled project constraints: {len(troubled_project_constraints)}\n")
        output.write(f"Other constraints: {len(other_constraints)}\n\n")
        
        # Sample of each constraint type
        constraint_types = [
            ("Capacity", capacity_constraints),
            ("Level Ratio", level_ratio_constraints),
            ("Practice Ratio", practice_ratio_constraints),
            ("Switch Logic", switch_constraints),
            ("Internal Priority", internal_priority_constraints),
            ("Troubled Project", troubled_project_constraints),
            ("Other", other_constraints)
        ]
        
        for constraint_type, constraints in constraint_types:
            if constraints:
                output.write(f"Sample of {constraint_type} constraints:\n")
                for i, constraint in enumerate(constraints[:3]):
                    constraint_name = list(model.constraints.keys())[list(model.constraints.values()).index(constraint)]
                    constraint_text = str(constraint)
                    # Format the constraint text for readability
                    formatted_text = textwrap.fill(constraint_text, width=80, subsequent_indent='    ')
                    output.write(f"  {constraint_name}:\n    {formatted_text}\n")
                output.write("\n")
        
        # Data summary
        output.write("=== DATA SUMMARY ===\n\n")
        
        # Engagements
        if hasattr(self, 'engagements') and self.engagements is not None:
            output.write(f"Engagements: {len(self.engagements)}\n")
            if not self.engagements.empty:
                for idx, row in self.engagements.head(5).iterrows():
                    output.write(f"  {row['eng_no']} - Phase {row['eng_phase']}\n")
        
        # Employees
        if hasattr(self, 'employees') and self.employees is not None:
            output.write(f"\nEmployees: {len(self.employees)}\n")
            if not self.employees.empty:
                staff_level_counts = self.employees.groupby('staff_level').size()
                for level, count in staff_level_counts.items():
                    output.write(f"  {level}: {count}\n")
        
        # Ratios
        if hasattr(self, 'actual_ratios') and self.actual_ratios is not None:
            output.write(f"\nStaffing Ratios: {len(self.actual_ratios)}\n")
            if not self.actual_ratios.empty:
                # Sample of staff level ratios
                staff_ratios = self.actual_ratios[pd.notna(self.actual_ratios['staff_level'])]
                if not staff_ratios.empty:
                    output.write("  Staff Level Ratios (sample):\n")
                    for idx, row in staff_ratios.head(3).iterrows():
                        output.write(f"    Eng {row['eng_no']}, Phase {row['eng_phase']}, " 
                                    f"Level {row['staff_level']}: {row['ratio']:.2f}\n")
                
                # Sample of practice ratios
                practice_ratios = self.actual_ratios[pd.notna(self.actual_ratios['practice_id'])]
                if not practice_ratios.empty:
                    output.write("  Practice Ratios (sample):\n")
                    for idx, row in practice_ratios.head(3).iterrows():
                        output.write(f"    Eng {row['eng_no']}, Phase {row['eng_phase']}, " 
                                    f"Practice {row['practice_id']}: {row['ratio']:.2f}\n")
        
        # EVM metrics
        if hasattr(self, 'evm_metrics') and self.evm_metrics is not None:
            output.write(f"\nEVM Metrics: {len(self.evm_metrics)}\n")
            if not self.evm_metrics.empty:
                for idx, row in self.evm_metrics.head(5).iterrows():
                    output.write(f"  Eng {row['eng_no']}, Phase {row['eng_phase']}: " 
                                f"SPI={row['spi']:.2f}, VEC={row['vec']:.2f}\n")
        
        # Optimization parameters
        if hasattr(self, 'get_optimization_parameters'):
            params = self.get_optimization_parameters()
            output.write(f"\nOptimization Parameters:\n")
            for key, value in params.items():
                output.write(f"  {key}: {value}\n")
        
        # Write to file
        with open(output_path, 'w') as f:
            f.write(output.getvalue())
        
        logger.info(f"Model visualization exported to {output_path}")
    
    def solve_model(self):
        """Solve the optimization model"""
        logger.info("Solving optimization model...")
        
        # Build the model
        model, hours_vars = self.build_optimization_model()
        
        # Check if model was successfully built
        if model is None:
            logger.error("Failed to build optimization model")
            return self.get_previous_week_assignments()
        
        # If visualization is enabled, export model details before solving
        if self.visualize_model:
            # Create logs directory if it doesn't exist
            log_dir = Path(os.path.dirname(os.path.abspath(__file__))).parent.parent / "logs"
            os.makedirs(log_dir, exist_ok=True)
            
            # Export model visualization
            visualization_path = log_dir / f"model_pre_solve_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
            self.export_model_visualization(model, hours_vars, visualization_path)
            logger.info(f"Pre-solve model visualization exported to {visualization_path}")
            
            # Also add a detailed LP file that can be imported into other solvers
            lp_path = log_dir / f"model_{datetime.now().strftime('%Y%m%d_%H%M%S')}.lp"
            model.writeLP(str(lp_path))
            logger.info(f"Model LP file exported to {lp_path}")
        
        # Solve
        solver = pulp.PULP_CBC_CMD(msg=self.visualize_model, timeLimit=600)  # Show messages if visualizing
        model.solve(solver)
        
        # Check solution status
        if model.status == pulp.LpStatusOptimal:
            logger.info("Optimal solution found")
            return self.process_results(hours_vars, model)
        else:
            logger.warning(f"No optimal solution found. Status: {pulp.LpStatus[model.status]}")
            
            # If visualizing, provide more detail about the infeasibility
            if self.visualize_model:
                logger.info("Analyzing constraint conflicts...")
                # Try to identify conflicting constraints - an advanced analysis would use IIS (Irreducible Infeasible Subsystem)
                # but that requires commercial solvers. Instead we'll use a simpler approach to suggest likely issues
                infeasible_constraints = self.analyze_constraints(model)
                
                if infeasible_constraints:
                    logger.info("Potential sources of infeasibility:")
                    for name, details in infeasible_constraints.items():
                        logger.info(f"  - {name}: {details['reason']}")
                        logger.info(f"    Suggestion: {details['suggestion']}")
                else:
                    logger.info("No obvious sources of infeasibility detected")
            
            # Fall back to last week's assignments if optimization is infeasible
            logger.info("Falling back to previous week's staffing allocation")
            return self.get_previous_week_assignments()

    def get_previous_week_assignments(self):
        """Get previous week's staffing assignments to use as fallback"""
        logger.info("Retrieving previous week's staffing allocation as fallback")
        
        if self.previous_assignments is None or self.previous_assignments.empty:
            logger.warning("No previous week assignments available for fallback")
            return None
            
        # Find the most recent week's data
        self.previous_assignments['week_start_date'] = pd.to_datetime(self.previous_assignments['week_start_date'])
        latest_week = self.previous_assignments['week_start_date'].max()
        
        # Filter to just the most recent week
        latest_assignments = self.previous_assignments[
            self.previous_assignments['week_start_date'] == latest_week
        ].copy()
        
        if latest_assignments.empty:
            logger.warning("Latest week assignments are empty")
            return None
            
        # Update week_start_date to target week
        latest_assignments['week_start_date'] = self.target_week
        
        # Set flag indicating we're using fallback data
        self.using_fallback = True
        
        logger.info(f"Using {len(latest_assignments)} assignments from week of {latest_week} as fallback")
        return latest_assignments

    def save_results(self, results_df):
        """Save optimization results to the database and always to CSV as backup"""
        if results_df is None or results_df.empty:
            logger.warning("No results to save")
            return False
        
        saved_to_db = False
        
        # First try to save to database
        try:
            # Use a custom query to delete existing predictions and insert new ones
            # First, delete existing predictions
            delete_query = f"""
                DELETE FROM staffing_prediction 
                WHERE week_start_date = '{self.target_week}'
            """
            
            # Create connection
            conn_str = self.fetcher.conn_str if hasattr(self.fetcher, 'conn_str') else None
            if conn_str:
                import pyodbc
                conn = pyodbc.connect(conn_str)
                cursor = conn.cursor()
                
                # Execute delete
                cursor.execute(delete_query)
                
                # Insert new predictions
                for _, row in results_df.iterrows():
                    cursor.execute("""
                        INSERT INTO staffing_prediction 
                        (personnel_no, eng_no, eng_phase, week_start_date, planned_hours)
                        VALUES (?, ?, ?, ?, ?)
                    """, (
                        row['personnel_no'],
                        row['eng_no'],
                        row['eng_phase'],
                        row['week_start_date'],
                        row['planned_hours']
                    ))
                
                conn.commit()
                conn.close()
                
                logger.info(f"Successfully saved {len(results_df)} staffing predictions to database")
                saved_to_db = True
            else:
                logger.error("No database connection available")
        except Exception as e:
            logger.error(f"Error saving results to database: {str(e)}")
        
        # Always save to CSV regardless of DB success
        try:
            # Save to CSV in the project's csv-dump/transformed directory
            import os
            from pathlib import Path
            
            # Get project root
            current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
            project_root = current_dir.parent.parent
            
            # Create transformed directory if it doesn't exist
            csv_dir = project_root / "csv-dump" / "transformed"
            os.makedirs(csv_dir, exist_ok=True)
            
            # Save without timestamp to make consistent
            csv_path = csv_dir / "staffing_prediction.csv"
            
            # Ensure week_start_date is a string for CSV
            results_copy = results_df.copy()
            if not isinstance(results_copy['week_start_date'].iloc[0], str):
                results_copy['week_start_date'] = results_copy['week_start_date'].astype(str)
            
            # Save to CSV
            results_copy.to_csv(csv_path, index=False)
            logger.info(f"Successfully saved {len(results_df)} staffing predictions to CSV: {csv_path}")
            
            # Always return True if we saved to CSV, even if DB failed
            return True
        except Exception as e:
            logger.error(f"Error saving results to CSV: {str(e)}")
            # Only return DB save status if CSV save failed
            return saved_to_db

    def run(self):
        """Run the complete optimization process"""
        # Initialize the fallback flag to False
        self.using_fallback = False
        
        try:
            # 1. Load all necessary data
            self.load_data()
            
            # 2. Check if we have valid EVM metrics - exit early if not
            if self.evm_metrics is None or self.evm_metrics.empty:
                logger.error("Cannot proceed with optimization without valid EVM metrics")
                # Try fallback to previous week's assignments
                fallback_results = self.get_previous_week_assignments()
                if fallback_results is not None:
                    logger.info("Using previous week's assignments due to missing EVM metrics")
                    self.save_results(fallback_results)
                    return True, fallback_results
                return False, None
                
            # 3. Build and solve the optimization model
            results = self.solve_model()
            
            # 4. Save results to database and CSV if not None
            if results is not None:
                success = self.save_results(results)
                return success, results
            
            return False, None
            
        except Exception as e:
            logger.error(f"Error in optimization process: {str(e)}")
            # Try fallback in case of any exception
            try:
                fallback_results = self.get_previous_week_assignments()
                if fallback_results is not None:
                    logger.info("Using previous week's assignments due to exception")
                    self.save_results(fallback_results)
                    return True, fallback_results
            except Exception as fallback_error:
                logger.error(f"Error in fallback process: {str(fallback_error)}")
            return False, None


# Usage example
if __name__ == "__main__":
    # Configuration - fetcher handles the connection details
    optimizer = MILPResourceOptimizer()
    success, results = optimizer.run()
    
    if success:
        print(f"Optimization successful: {len(results)} assignments created")
    else:
        print("Optimization failed")