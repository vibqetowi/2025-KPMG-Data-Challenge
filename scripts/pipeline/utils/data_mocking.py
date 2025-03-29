import pandas as pd
from datetime import datetime, timedelta
import numpy as np
import random
from pandas.tseries.offsets import BDay
import sys
import os
from pathlib import Path
import logging

# Add parent directories to path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent.parent
shared_dir = project_root / "scripts" / "shared"
sys.path.append(str(shared_dir))

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class DataMocker:
    
    def __init__(self):
        """Initialize the DataMocker class for generating synthetic data."""
        self._phase_dates_cache = None
        self._charge_out_rates_df = None  # Store charge out rates here
        
        # Default parameters for duration calculations
        self.default_chargeout_rate = 1000  # Fallback rate if no data is available
        self.default_headcount = 3  # Default number of consultants per phase
        self.default_working_hours = 8  # Default working hours per day
        self.cpi_proxy = 0.98  # Cost Performance Index proxy as per README Appendix 3
        
        # Initialize reference date (for BDays calculation)
        self.reference_date = pd.Timestamp('2025-01-01')
        
        # Initialize staff level weights (for weighted average calculations)
        self.staff_level_rates = {
            'STAFF ACCOUNTANT/CONSULTA': 800,  # Junior
            'SPECIALIST/SENIOR CONSULT': 1100, # Senior Consultant
            'MANAGER': 1400,                   # Manager
            'SENIOR MANAGER': 1700,            # Senior Manager
            'DIRECTOR': 2000,                  # Director
            'PARTNER': 2500                    # Partner
        }
        
        logger.info("DataMocker initialized with duration calculation parameters")
    
    def set_charge_out_rates(self, charge_out_rates_df):
        """
        Set the charge out rates DataFrame from the transformer.
        
        Args:
            charge_out_rates_df: DataFrame containing standard chargeout rates
        """
        self._charge_out_rates_df = charge_out_rates_df
        logger.info(f"Received {len(charge_out_rates_df)} charge out rate records from transformer")
        
        # Log some statistics about the rates
        if not charge_out_rates_df.empty:
            rate_stats = charge_out_rates_df['standard_chargeout_rate'].describe()
            logger.info(f"Charge out rate statistics: min={rate_stats['min']:.2f}, max={rate_stats['max']:.2f}, avg={rate_stats['mean']:.2f}")

    def create_default_practices(self):
        """
        Create KPMG-specific practices, with SAP as practice ID 1
        """
        practices = [
            {
                'practice_id': 1,
                'practice_name': 'SAP',
                'description': 'SAP Implementation and Advisory Services'
            },
            {
                'practice_id': 2,
                'practice_name': 'Audit & Assurance',
                'description': 'Financial Statement Audits and Assurance Services'
            },
            {
                'practice_id': 3,
                'practice_name': 'Cloud Services',
                'description': 'AWS, Azure, and GCP Implementation Advisory'
            },
            {
                'practice_id': 4, 
                'practice_name': 'Management Consulting',
                'description': 'Strategy and Operations Consulting'
            },
            {
                'practice_id': 5,
                'practice_name': 'Deal Advisory',
                'description': 'Mergers & Acquisitions and Transaction Services'
            },
            {
                'practice_id': 6,
                'practice_name': 'Risk Consulting',
                'description': 'Risk Management, Compliance, and Governance'
            },
            {
                'practice_id': 7,
                'practice_name': 'Technology Consulting',
                'description': 'Digital Transformation and Enterprise Technologies'
            },
            {
                'practice_id': 8,
                'practice_name': 'ESG Advisory',
                'description': 'Environmental, Social, and Governance Services'
            }
        ]
        
        df_practices = pd.DataFrame(practices)
        print(f"Created {len(practices)} KPMG practice records (SAP is default with ID 1)")
        print("Available KPMG practices:")
        for _, practice in enumerate(practices):
            print(f"  - {practice['practice_id']}: {practice['practice_name']}")
        return df_practices

    def create_default_clients(self):
        """
        Create hardcoded client list from case data.
        """
        clients = [
            {
                'client_no': 1000017023,
                'client_name': 'Company X'
            },
            {
                'client_no': 1000017024,
                'client_name': 'Company Y'
            }
        ]
        
        df_clients = pd.DataFrame(clients)
        print(f"Created {len(clients)} default client records")
        return df_clients

    def create_default_employees(self):
        """
        Create hardcoded employee list from case data.
        """
        employees = [
            {'personnel_no': 14523, 'employee_name': 'Alice Dupont', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14524, 'employee_name': 'Bastien Lefèvre', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14525, 'employee_name': 'Camille Moreau', 'staff_level': 'MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14526, 'employee_name': 'Damien Girard', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14529, 'employee_name': 'Gaëlle Petit', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14528, 'employee_name': 'Fabien Martin', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14534, 'employee_name': 'Mathieu Dubois', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14536, 'employee_name': 'Olivier Robert', 'staff_level': 'STAFF ACCOUNTANT/CONSULTA', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14535, 'employee_name': 'Nina Simon', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14532, 'employee_name': 'Julien Thomas', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14533, 'employee_name': 'Léa Fournier', 'staff_level': 'MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14527, 'employee_name': 'Élodie Roux', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14537, 'employee_name': 'Sophie Garnier', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14530, 'employee_name': 'Hugo Lemoine', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14531, 'employee_name': 'Inès Bernard', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1}
        ]
        
        df_employees = pd.DataFrame(employees)
        print(f"Created {len(employees)} default employee records")
        return df_employees

    def generate_vacation_data(self, employees_df):
        """
        Generate vacation records based on realistic patterns.
        
        Args:
            employees_df: DataFrame containing employee information
            
        Returns:
            DataFrame with vacation records
        """
        if employees_df.empty:
            logger.warning("No employee data available to generate vacations")
            return pd.DataFrame()
        
        # Define common vacation periods as per README 
        vacation_periods = [
            ('2025-03-10', '2025-03-17'),  # Spring break
            ('2025-07-01', '2025-07-15'),  # Summer vacations
            ('2025-08-03', '2025-08-17'),  # Summer vacations  
            ('2025-10-20', '2025-10-27'),  # Fall break
            ('2025-12-22', '2025-12-31')   # Winter holidays
        ]
        
        personnel_nos = employees_df['personnel_no'].dropna().unique().tolist()
        
        if not personnel_nos:
            logger.warning("No valid personnel numbers found for vacation generation")
            return pd.DataFrame()
        
        # Select employees for vacations - at least 5 if available
        num_to_select = min(len(personnel_nos), 5)
        selected_employees = random.sample(personnel_nos, num_to_select)
        
        vacations = []
        for i, personnel_no in enumerate(selected_employees):
            # Select vacation period based on index
            period_idx = i % len(vacation_periods)
            start_date, end_date = vacation_periods[period_idx]
            
            vacations.append({
                'personnel_no': personnel_no,
                'start_date': pd.Timestamp(start_date),
                'end_date': pd.Timestamp(end_date)
            })
        
        df_vacations = pd.DataFrame(vacations)
        logger.info(f"Generated {len(vacations)} vacation records")
        
        return df_vacations

    def get_engagement_dates(self, eng_no, phases_df=None, staffing_df=None):
        """
        Get start and end dates for an engagement based on its phases.
        
        Args:
            eng_no: Engagement number
            phases_df: DataFrame containing phase information
            staffing_df: DataFrame containing staffing information
            
        Returns:
            Tuple of (start_date, end_date) or (None, None) if not found
        """
        if self._phase_dates_cache is None:
            if phases_df is not None and staffing_df is not None:
                self._phase_dates_cache = self.generate_phase_dates_from_budget(phases_df, staffing_df)
            else:
                logger.warning("Cannot get engagement dates: No phase data available")
                return (None, None)
        
        # Get all phases for this engagement
        rows = self._phase_dates_cache[self._phase_dates_cache["eng_no"] == eng_no]
        
        # Return the earliest start and latest end date
        if not rows.empty:
            start_date = rows["start_date"].min()
            end_date = rows["end_date"].max()
            return (start_date, end_date)
        else:
            return (None, None)

    def get_phase_dates(self, eng_no, eng_phase):
        """
        Get specific dates for a particular phase of an engagement.
        
        Args:
            eng_no: Engagement number
            eng_phase: Phase number
            
        Returns:
            Tuple of (start_date, end_date) or (None, None) if not found
        """
        if self._phase_dates_cache is None:
            logger.warning("Phase dates cache not initialized. Cannot retrieve phase dates.")
            return (None, None)
            
        # Find the specific phase
        row = self._phase_dates_cache[
            (self._phase_dates_cache["eng_no"] == eng_no) &
            (self._phase_dates_cache["eng_phase"] == eng_phase)
        ]
        
        # Return dates if found
        if not row.empty:
            return (row.iloc[0]["start_date"], row.iloc[0]["end_date"])
        else:
            return (None, None)

    def generate_phase_dates_from_budget(self, phases_df, staffing_df, reference_date="2025-01-01", charge_out_rates_df=None, timesheet_df=None):
        """
        Generate simple phase dates for initial data transformation.
        Note: More accurate dates will be calculated in the DataEnricher module.
        
        Args:
            phases_df: DataFrame containing phase information with budgets
            staffing_df: DataFrame containing staffing information 
            reference_date: Default start date string if not found in data
            charge_out_rates_df: DataFrame containing standard chargeout rates (optional)
            timesheet_df: DataFrame containing timesheet entries (optional)
            
        Returns:
            DataFrame with calculated start and end dates for each phase
        """
        logger.info("Generating simplified phase dates for initial transformation")
        
        # Create a copy of the phases DataFrame to avoid modifying the original
        phases = phases_df.copy()
        
        # Convert reference date to Timestamp if it's a string
        if isinstance(reference_date, str):
            reference_date = pd.Timestamp(reference_date)
        
        # Sort phases by eng_no and eng_phase
        phases = phases.sort_values(['eng_no', 'eng_phase'])
        
        # Initialize start and end date columns
        phases['start_date'] = None
        phases['end_date'] = None
        
        # Group by engagement
        for eng_no, eng_group in phases.groupby('eng_no'):
            # Start date for the first phase
            start_date = reference_date
            
            # For each phase in the engagement
            for idx, row in eng_group.iterrows():
                # Set start date
                phases.at[idx, 'start_date'] = start_date
                
                # Set end date (simple 30 business days duration)
                end_date = start_date + BDay(30)
                phases.at[idx, 'end_date'] = end_date
                
                # Next phase starts 1 business day after this phase ends
                start_date = end_date + BDay(1)
        
        # Convert dates to datetime64[ns]
        phases['start_date'] = pd.to_datetime(phases['start_date'])
        phases['end_date'] = pd.to_datetime(phases['end_date'])
        
        # Keep only necessary columns for the result
        result = phases[['eng_no', 'eng_phase', 'start_date', 'end_date']].copy()
        
        logger.info(f"Generated simple sequential dates for {len(result)} phases")
        
        # Store in cache for future reference
        self._phase_dates_cache = result
        
        return result

    def create_default_optimization_parameters(self):
        """
        Create default optimization parameters as specified in README Appendix 3.
        Based on the optimization formula:
        max_{A} \sum_{en \in EN} w_{en} \times r_{en} \times (\alpha \times \text{SPI}_{en} + \beta \times \text{VEC}_{en})
              - \sum_{c\in C, en \in EN, w \in W}\text{pse} \times \text{is\_switch}_{c,en,w}
        """
        current_time = datetime.now()
        
        # Parameters based on README Appendix 3 and 5
        optimization_parameters = [
            {
                'parameter_key': 'alpha',
                'parameter_value': 0.6,
                'description': 'Weight coefficient for SPI (Schedule Performance Index) in optimization objective function',
                'last_updated': current_time,
                'updated_by': 14526  # Default to a Senior Manager
            },
            {
                'parameter_key': 'beta',
                'parameter_value': 0.4,
                'description': 'Weight coefficient for VEC (Value Extraction Coefficient) in optimization objective function',
                'last_updated': current_time,
                'updated_by': 14526
            },
            {
                'parameter_key': 'pse',
                'parameter_value': 0.9,
                'description': 'Phase Switching Efficiency factor - productivity loss when consultants switch engagements',
                'last_updated': current_time,
                'updated_by': 14526
            },
            {
                'parameter_key': 'delta',
                'parameter_value': 0.2,
                'description': 'Acceptable variation in staffing ratios (±20%)',
                'last_updated': current_time,
                'updated_by': 14526
            },
            {
                'parameter_key': 'min_spi',
                'parameter_value': 0.85,
                'description': 'Minimum acceptable SPI for any engagement',
                'last_updated': current_time,
                'updated_by': 14526
            },
            {
                'parameter_key': 'default_strategic_weight',
                'parameter_value': 1.0,
                'description': 'Default strategic value weight (w_en) for engagements',
                'last_updated': current_time,
                'updated_by': 14526
            },
            {
                'parameter_key': 'default_risk_coefficient',
                'parameter_value': 1.0,
                'description': 'Default delivery risk coefficient (r_en) for engagements',
                'last_updated': current_time,
                'updated_by': 14526
            },
            {
                'parameter_key': 'cpi_proxy',
                'parameter_value': 0.98,
                'description': 'Cost Performance Index proxy value as per Appendix 3',
                'last_updated': current_time,
                'updated_by': 14526
            }
        ]
        
        df_optimization_parameters = pd.DataFrame(optimization_parameters)
        logger.info(f"Created {len(optimization_parameters)} default optimization parameters")
        return df_optimization_parameters



