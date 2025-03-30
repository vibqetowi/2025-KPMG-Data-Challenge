# ## Appendix 2: Predicting Optimal Allocation of Employee Resources (Demo Implementation Strategy)

# This section details the algorithmic approach for solving the resource optimization problem, specifically outlining the strategy for this demonstration using Mixed Integer Linear Programming (MILP) [see video.](https://www.youtube.com/embed/E72DWgKP_1Y).

# ### Implementation Strategy

# 1. **Data Preparation Phase (Scheduled - Weekly)**

#    * **Calculate Engagement Status:** Determine current or projected statuses (SPI, VEC, Budget Burn) for active engagements using methods outlined in Appendix 4. Linear approximations may be needed if using these directly in the objective/constraints.
#    * **Retrieve Consultant Availability:** Fetch each consultant's standard capacity (`employees.employment_basis`), adjusting for planned time off (`vacations`) for the target week(s) $w$.
#    * **Calculate Dynamic Target Ratios:** For each active engagement ($en$), staff level ($l$), and practice ($pr$), calculate the *actual* ratio ($ActualRatio_{l,pr,en,w-1}$) based on `timesheets.hours` from the most recently completed week ($w-1$), as per the definition in Appendix 4/5. This value serves as the baseline target for the next week's optimization constraints.
#    * **Retrieve Parameters:** Load strategic weights ($w_{en}$) and risk coefficients ($r_{en}$) from `engagements`. Fetch optimization parameters ($\alpha$, $\beta$, $pse$) and the **ratio deviation tolerance** ($\delta$) from the `optimization_parameters` table (or use defaults per Appendix 3 if table not populated).
# 2. **Optimization Model Formulation (MILP)**

#    * **Framework:** Implemented using **Python `PuLP`**, a library suitable for defining and solving MILP problems.
#    * **Decision Variables:**

#      * $Hours_{c,en,w}$: Planned hours for consultant $c$ on engagement $en$ in week $w$ (continuous).
#      * $is\_switch_{c,en,w}$: Binary variable (0 or 1) indicating if consultant $c$ starts work on engagement $en$ in week $w$ (having not worked on it in $w-1$).
#    * **Objective Function (Linear - Demo Implementation):**

#      * **Note:** For this demo implementation using MILP, we are **using a hard boundary constraint** (with tolerance $\delta$, detailed below) to manage staffing ratios, **instead of the non-linear penalty term** ($\sum \text{Penalty}_{l,pr,en,w}$) described conceptually earlier in the document. Therefore, the objective function optimized in this demo is:

#      ```math
#      \max \sum_{en \in EN} \left[ w_{en} \times r_{en} \times (\alpha \times \text{Proj\_SPI\_Contrib}_{en} + \beta \times \text{Proj\_VEC\_Contrib}_{en}) \right] - \sum_{c,en,w} \text{pse} \times \text{is\_switch}_{c,en,w}
#      ```

#      * *Linearity Requirement:* For this MILP model, $\text{Proj\_SPI\_Contrib}_{en}$ and $\text{Proj\_VEC\_Contrib}_{en}$ must be defined as linear functions of the $Hours_{c,en,w}$ variables. Simplifications (e.g., assuming contribution is proportional to hours assigned relative to a target) may be necessary.
#    * **Constraints (Linear):**

#      * **Consultant Capacity:** Total planned hours for each consultant cannot exceed their adjusted weekly availability:
#        ```math
#        \sum_{en \in EN} Hours_{c,en,w} \leq \text{AdjustedCapacity}_c \quad \forall c, w
#        ```
#      * **Staffing Ratio Tolerance (Linearized Hard Constraint):** Enforces that the planned staffing mix for the target week ($w$) stays within the tolerance ($\delta$) of the *previous week's actual ratio* ($ActualRatio_{l,pr,en,w-1}$). For each engagement $en$, level $l$, practice $pr$, and week $w$:
#        * Let $\text{TargetRatio} = ActualRatio_{l,pr,en,w-1}$ (pre-calculated constant).
#        * Let $\text{SumHours}_{l,pr} = \sum_{c \in C_{l,pr}} Hours_{c,en,w}$.
#        * Let $\text{SumHours}_{\text{other}} = \sum_{c \notin C_{l,pr}} Hours_{c,en,w}$.
#        * Constraint 1 (Lower Bound): Ensures $\text{PlannedRatio} \ge \text{TargetRatio} \times (1-\delta)$
#          ```math
#          (\text{TargetRatio} \times (1-\delta) - 1) \times \text{SumHours}_{l,pr} + \text{TargetRatio} \times (1-\delta) \times \text{SumHours}_{\text{other}} \leq 0
#          ```
#        * Constraint 2 (Upper Bound): Ensures $\text{PlannedRatio} \le \text{TargetRatio} \times (1+\delta)$
#          ```math
#          (1 - \text{TargetRatio} \times (1+\delta)) \times \text{SumHours}_{l,pr} - \text{TargetRatio} \times (1+\delta) \times \text{SumHours}_{\text{other}} \leq 0
#          ```
#      * **Performance Thresholds (Simplified/Linearized):** If required, constraints like $SPI_{en} \ge 0.85$ must be represented linearly or checked post-optimization.
#      * **Benching Rate:** A constraint limiting total unassigned internal consultant hours relative to their total capacity.
#      * **Internal Priority:** Constraints ensuring $Hours_{c,en,w} = 0$ for external consultants unless specific internal consultants are fully assigned.
#      * **Switch Logic:** Constraints defining $is\_switch_{c,en,w}$ based on $Hours_{c,en,w}$ and assignment status in week $w-1$.
# 3. **Solver Execution**

#    * The PuLP model is passed to a compatible MILP solver (e.g., CBC, GLPK, Gurobi, CPLEX). The solver finds the optimal $Hours_{c,en,w}$ values.
# 4. **Post-Optimization Processing & Feedback Loop**

#    * **Output:** Optimal assignments ($Hours_{c,en,w}$) are saved (e.g., to `staffing_prediction`).
#    * **Visualization:** Recommendations presented on the Power BI dashboard.
#    * **Monitoring & Tuning:** Actual performance (`timesheets`) compared to predictions. Parameters ($\alpha$, $\beta$, $pse$, $\delta$) manually adjusted based on results.
# 5. **Demo Implementation Considerations**

#    * **Linearity & Simplification:** This strategy prioritizes a solvable MILP model using PuLP. **Crucially, this involved replacing the non-linear "soft boundary" penalty approach with the linearized "hard boundary" staffing ratio constraints (allowing $\delta$ tolerance) described above.** Projections for SPI/VEC within the model might also be simplified.
#    * **Dynamic Target:** Reliance on the previous week's actual ratio makes the plan adaptive but sensitive to past anomalies. $\delta$ provides flexibility.
#    * **Future Enhancements:** Could involve exploring non-linear solvers, adding skills matching, improving SPI/VEC predictions, and adding stability constraints.

import pulp
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os
import sys
import logging
from pathlib import Path

# Set up path to include shared modules
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
shared_dir = project_root / "scripts" / "shared"
utils_dir = current_dir / "utils"
sys.path.append(str(shared_dir))
sys.path.append(str(utils_dir))

# Import utilities
from fetcher import DataFetcher
from metric_utils import calculate_staffing_ratios, get_week_start_date
from utils.evm_metrics import (
    calculate_vec, calculate_spi, calculate_burn, 
    calculate_schedule_elapsed, calculate_planned_value, calculate_earned_value,
    compute_evm_metrics
)

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
        # Set target week
        if target_week_start is None:
            # Default to next Monday if not specified
            today = datetime.now().date()
            self.target_week = get_week_start_date(today + timedelta(days=7))  # Next Monday
        else:
            self.target_week = target_week_start
            if self.target_week.weekday() != 0:  # Not a Monday
                self.target_week = get_week_start_date(self.target_week)
        
        # Previous weeks for historical data (3-week window for rolling ratios)
        self.previous_week1 = self.target_week - timedelta(days=7)
        self.previous_week2 = self.target_week - timedelta(days=14)
        self.previous_week3 = self.target_week - timedelta(days=21)
        
        # Current date for filtering out future data
        self.current_date = datetime.now().date()
        
        # Initialize DataFetcher
        self.fetcher = DataFetcher(db_connection_string=db_connection_string)
        
        # Default optimization parameters
        self.default_params = {
            'alpha': 0.7,  # Weight for SPI contribution
            'beta': 0.3,   # Weight for VEC contribution
            'pse': 5.0,    # Penalty for switching engagements
            'delta': 0.2   # Ratio deviation tolerance (20%)
        }
        
        # Data containers
        self.employees = None
        self.engagements = None
        self.timesheets = None
        self.vacations = None
        self.actual_ratios = None
        self.opt_params = None
        self.previous_assignments = None
        
        # Add EVM metrics container
        self.evm_metrics = None

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
            self.timesheets['work_date'] = pd.to_datetime(self.timesheets['work_date'])
        elif 'Work Date' in self.timesheets.columns:
            self.timesheets['Work Date'] = pd.to_datetime(self.timesheets['Work Date'])
        
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
                ]
            elif 'Work Date' in self.timesheets.columns:
                week_data = self.timesheets[
                    (self.timesheets['Work Date'] >= start_date) & 
                    (self.timesheets['Work Date'] < end_date)
                ]
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
            
            # Calculate weighted average ratios
            weighted_ratios = (
                combined_ratios.groupby(['eng_no', 'eng_phase', 'staff_level', 'practice_id'])
                .apply(lambda x: (x['ratio'] * x['weight']).sum() / x['weight'].sum())
                .reset_index(name='ratio')
            )
            
            self.actual_ratios = weighted_ratios
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
        
        # Use the compute_evm_metrics function from evm_metrics.py
        try:
            # Get current date for calculations (target week start is appropriate)
            current_date = self.target_week
            
            # Compute comprehensive EVM metrics for all projects
            self.evm_metrics = compute_evm_metrics(current_date=current_date)
            
            if self.evm_metrics.empty:
                logger.warning("No EVM metrics calculated. Using default values.")
                self.create_default_evm_metrics()
            else:
                logger.info(f"Calculated EVM metrics for {len(self.evm_metrics)} engagements")
        except Exception as e:
            logger.error(f"Error calculating EVM metrics: {str(e)}")
            logger.warning("Using default EVM metrics")
            self.create_default_evm_metrics()

    def create_default_evm_metrics(self):
        """Create default EVM metrics when calculation fails"""
        logger.info("Creating default EVM metrics")
        
        # Create a dataframe with default values for each engagement
        metrics = []
        
        # For each engagement in our data
        for _, eng in self.engagements.iterrows():
            eng_no = eng['eng_no']
            eng_phase = eng['eng_phase']
            
            # Create key for lookups
            project_key = f"{eng_no}_{eng_phase}"
            
            # Default values
            metrics.append({
                'project_key': project_key,
                'eng_no': eng_no,
                'eng_phase': eng_phase,
                'spi': 1.0,  # Default SPI = 1.0 (on schedule)
                'vec': 1.0,  # Default VEC = 1.0 (standard value extraction)
                'burn': 0.5,  # Default Burn = 0.5 (halfway through budget)
                'current_date': self.target_week
            })
        
        self.evm_metrics = pd.DataFrame(metrics)

    def calculate_adjusted_capacity(self):
        """Calculate adjusted capacity for each consultant based on vacations"""
        # Start with standard employment basis
        self.employees['adjusted_capacity'] = self.employees['employment_basis']
        
        # Adjust for vacations
        if not self.vacations.empty:
            for _, vacation in self.vacations.iterrows():
                # Simple calculation: reduce capacity proportionally to days off
                personnel_no = vacation['personnel_no']
                days_off = vacation['days_off']
                
                # Find the employee
                if personnel_no in self.employees['personnel_no'].values:
                    employee_idx = self.employees[self.employees['personnel_no'] == personnel_no].index[0]
                    standard_capacity = self.employees.loc[employee_idx, 'employment_basis']
                    
                    # Reduce capacity proportionally (assuming 5-day work week)
                    reduction = standard_capacity * (days_off / 5.0)
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
                model += (
                    external_hours <= max(0, internal_unused - tolerance),
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
        
        return model, hours_vars

    def solve_model(self):
        """Solve the optimization model"""
        logger.info("Solving optimization model...")
        
        # Build the model
        model, hours_vars = self.build_optimization_model()
        
        # Solve
        solver = pulp.PULP_CBC_CMD(msg=False, timeLimit=600)  # 10-minute time limit
        model.solve(solver)
        
        # Check solution status
        if model.status == pulp.LpStatusOptimal:
            logger.info("Optimal solution found")
            return self.process_results(hours_vars, model)
        else:
            logger.warning(f"No optimal solution found. Status: {pulp.LpStatus[model.status]}")
            return None

    def process_results(self, hours_vars, model):
        """Process optimization results into a DataFrame"""
        logger.info("Processing optimization results")
        
        results = []
        
        # Extract values from solution
        for (c, en, ph), var in hours_vars.items():
            hours = var.value()
            
            # Only include non-zero assignments
            if hours is not None and hours > 0:
                hours = round(hours, 2)  # Round to 2 decimal places
                
                results.append({
                    'personnel_no': c,
                    'eng_no': en,
                    'eng_phase': ph,
                    'week_start_date': self.target_week,
                    'planned_hours': hours
                })
        
        # Create DataFrame
        results_df = pd.DataFrame(results)
        
        # Calculate some metrics for logging
        if not results_df.empty:
            total_hours = results_df['planned_hours'].sum()
            num_consultants = results_df['personnel_no'].nunique()
            num_engagements = results_df[['eng_no', 'eng_phase']].drop_duplicates().shape[0]
            
            logger.info(f"Optimization assigned {total_hours} hours to {num_consultants} consultants across {num_engagements} engagements")
        else:
            logger.warning("No assignments in optimization results")
        
        return results_df

    def save_results(self, results_df):
        """Save optimization results to the database"""
        if results_df is None or results_df.empty:
            logger.warning("No results to save")
            return False
        
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
                return True
            else:
                logger.error("No database connection available")
                return False
            
        except Exception as e:
            logger.error(f"Error saving results to database: {str(e)}")
            return False

    def run(self):
        """Run the complete optimization process"""
        try:
            # 1. Load all necessary data
            self.load_data()
            
            # 2. Build and solve the optimization model
            results = self.solve_model()
            
            # 3. Save results to database
            if results is not None:
                success = self.save_results(results)
                return success, results
            
            return False, None
            
        except Exception as e:
            logger.error(f"Error in optimization process: {str(e)}")
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