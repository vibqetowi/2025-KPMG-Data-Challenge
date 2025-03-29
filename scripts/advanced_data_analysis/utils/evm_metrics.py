"""
EVM Metrics Module

This module provides functions to calculate Earned Value Management metrics as defined
in the project's methodology, including VEC (Value Extraction Coefficient), Burn rate,
SPI (Schedule Performance Index), and other related metrics.
"""
import pandas as pd
import numpy as np
from datetime import datetime

# Import DataFetcher for retrieving data
from utils.fetcher import DataFetcher

def calculate_rate_efficiency_factor(actual_chargeout, standard_chargeout):
    """
    Calculate the Rate Efficiency Factor (d_i) for a transaction
    
    Parameters:
        actual_chargeout (float): The actual chargeout rate used for the transaction
        standard_chargeout (float): The standard chargeout rate for the consultant
        
    Returns:
        float: Rate Efficiency Factor (d_i)
    """
    return actual_chargeout / standard_chargeout if standard_chargeout else 1.0


def calculate_external_adjustment_factor(is_external):
    """
    Calculate the External Adjustment Factor (ea_j) for a consultant
    
    Parameters:
        is_external (bool): Whether the consultant is external
        
    Returns:
        float: External Adjustment Factor (ea_j)
    """
    return 1.0 - (0.1 * is_external)


def calculate_onboarding_adjustment_factor(is_new):
    """
    Calculate the Onboarding/New Hire Adjustment Factor (eo_j) for a consultant
    
    Parameters:
        is_new (bool): Whether the consultant is a new hire
        
    Returns:
        float: Onboarding Adjustment Factor (eo_j)
    """
    return 1.0 - (0.2 * is_new)


def calculate_vec(transactions_df, bac, employees_df=None):
    """
    Calculate the Value Extraction Coefficient (VEC) for a phase or engagement
    
    VEC_ph = (1/BAC_ph) × ∑[AC_i × d_i × ea_j × eo_j]
    
    Parameters:
        transactions_df (pd.DataFrame): DataFrame containing timesheet data with columns:
                                        'personnel_no', 'charge_out_rate', 'std_price',
                                        'adm_surcharge'
        bac (float): Budget at Completion for the phase/engagement (from phases.budget)
        employees_df (pd.DataFrame, optional): DataFrame with employee information including
                                              'personnel_no', 'is_external'
                                               
    Returns:
        float: Value Extraction Coefficient (VEC)
    """
    if bac <= 0:
        return 0.0
        
    # If employees_df not provided, fetch it or create default
    if employees_df is None:
        try:
            fetcher = DataFetcher()
            employees_df = fetcher.fetch_data(['employees'])['employees']
        except:
            # Create default if fetcher fails
            employees_df = pd.DataFrame({
                'personnel_no': transactions_df['personnel_no'].unique(),
                'is_external': False,
                'is_new': False  # Assuming no new hires by default
            })
    
    # Get standard charge-out rates if available
    try:
        fetcher = DataFetcher()
        charge_rates_df = fetcher.fetch_data(['charge_out_rates'])['charge_out_rates']
        # Merge to get standard rates for each personnel and engagement
        transactions_df = pd.merge(
            transactions_df,
            charge_rates_df,
            on=['personnel_no', 'eng_no'],
            how='left'
        )
    except:
        # If can't get standard rates, use actual as proxy
        transactions_df['standard_chargeout_rate'] = transactions_df['charge_out_rate']
    
    # Merge employee data with transactions
    merged_df = pd.merge(
        transactions_df,
        employees_df[['personnel_no', 'is_external']],
        on='personnel_no',
        how='left'
    )
    
    # Fill NaN values with defaults
    merged_df['is_external'] = merged_df['is_external'].fillna(False)
    # is_new not in the ERD directly - could be derived from hire date if available
    merged_df['is_new'] = False  
    merged_df['standard_chargeout_rate'] = merged_df['standard_chargeout_rate'].fillna(merged_df['charge_out_rate'])
    
    # Calculate factors for each transaction
    merged_df['d_i'] = merged_df.apply(
        lambda row: calculate_rate_efficiency_factor(
            row['charge_out_rate'], row['standard_chargeout_rate']
        ), 
        axis=1
    )
    
    merged_df['ea_j'] = merged_df['is_external'].apply(calculate_external_adjustment_factor)
    merged_df['eo_j'] = merged_df['is_new'].apply(calculate_onboarding_adjustment_factor)
    
    # Calculate actual cost from timesheet data
    merged_df['actual_cost'] = merged_df['std_price'] + merged_df['adm_surcharge']
    
    # Calculate the sum component of VEC
    merged_df['vec_component'] = merged_df['actual_cost'] * merged_df['d_i'] * merged_df['ea_j'] * merged_df['eo_j']
    
    # Calculate VEC
    vec = merged_df['vec_component'].sum() / bac
    
    return vec


def calculate_burn(transactions_df, bac):
    """
    Calculate the Budget Burn for a phase or engagement
    
    Burn_ph = ∑AC_i / BAC_ph
    
    Parameters:
        transactions_df (pd.DataFrame): DataFrame containing timesheet data with
                                       'std_price' and 'adm_surcharge' columns
        bac (float): Budget at Completion for the phase/engagement
        
    Returns:
        float: Budget Burn
    """
    if bac <= 0:
        return 0.0
    
    # Calculate actual cost from timesheet data
    transactions_df['actual_cost'] = transactions_df['std_price'] + transactions_df['adm_surcharge']
    total_actual_cost = transactions_df['actual_cost'].sum()
    burn = total_actual_cost / bac
    
    return burn


def calculate_schedule_elapsed(start_date, planned_duration, current_date=None):
    """
    Calculate the percentage of schedule elapsed
    
    Parameters:
        start_date (datetime): The start date of the phase/engagement
        planned_duration (int): The planned duration in days
        current_date (datetime, optional): The current date for calculation, defaults to today
        
    Returns:
        float: Percentage of schedule elapsed (0.0 to 1.0)
    """
    if current_date is None:
        current_date = datetime.now()
        
    if not isinstance(start_date, pd.Timestamp) and not isinstance(start_date, datetime):
        start_date = pd.to_datetime(start_date)
        
    days_elapsed = (current_date - start_date).days
    
    if planned_duration <= 0:
        return 1.0  # Prevent division by zero
        
    percentage_elapsed = days_elapsed / planned_duration
    
    # Cap at 1.0 to handle cases where project has exceeded planned duration
    return min(max(percentage_elapsed, 0.0), 1.0)


def calculate_planned_value(bac, schedule_elapsed):
    """
    Calculate the Planned Value (PV)
    
    PV = BAC × Percentage Schedule Elapsed
    
    Parameters:
        bac (float): Budget at Completion
        schedule_elapsed (float): Percentage of schedule elapsed (0.0 to 1.0)
        
    Returns:
        float: Planned Value (PV)
    """
    return bac * schedule_elapsed


def calculate_earned_value(transactions_df, bac, cpi_proxy=0.98):
    """
    Calculate the Earned Value (EV)
    
    For PoC: EV = ∑AC_to_date × CPI_proxy
    
    Parameters:
        transactions_df (pd.DataFrame): DataFrame containing transaction data with
                                        an 'actual_cost' column
        bac (float): Budget at Completion for reference
        cpi_proxy (float, optional): CPI proxy value, defaults to 0.98
        
    Returns:
        float: Earned Value (EV)
    """
    total_actual_cost = transactions_df['actual_cost'].sum()
    
    # Basic PoC method (should be refined in production)
    ev = total_actual_cost * cpi_proxy
    
    # Cap at BAC to handle cases where project has exceeded budget
    return min(ev, bac)


def calculate_spi(earned_value, planned_value):
    """
    Calculate the Schedule Performance Index (SPI)
    
    SPI = EV / PV
    
    Parameters:
        earned_value (float): Earned Value (EV)
        planned_value (float): Planned Value (PV)
        
    Returns:
        float: Schedule Performance Index (SPI)
    """
    if planned_value <= 0:
        return 1.0  # Prevent division by zero
        
    spi = earned_value / planned_value
    
    return spi


def calculate_benching_rate(assigned_hours, standard_capacity):
    """
    Calculate the Weekly Benching Rate for a consultant
    
    Benching Rate = (1 - (Assigned Hours / Standard Weekly Capacity)) × 100%
    
    Parameters:
        assigned_hours (float): Total hours assigned to the consultant
        standard_capacity (float): Standard weekly capacity of the consultant
        
    Returns:
        float: Benching Rate as a percentage
    """
    if standard_capacity <= 0:
        return 0.0  # Prevent division by zero
        
    benching_rate = (1.0 - (assigned_hours / standard_capacity)) * 100.0
    
    # Cap at 100% to handle negative benching rates
    return max(min(benching_rate, 100.0), 0.0)


def calculate_capacity_utilization(actual_billable_hours, standard_capacity):
    """
    Calculate the Weekly Capacity Utilization Rate for a consultant
    
    Capacity Utilization = (Actual Billable Hours / Standard Weekly Capacity) × 100%
    
    Parameters:
        actual_billable_hours (float): Total actual billable hours logged by the consultant
        standard_capacity (float): Standard weekly capacity of the consultant
        
    Returns:
        float: Capacity Utilization Rate as a percentage
    """
    if standard_capacity <= 0:
        return 0.0  # Prevent division by zero
        
    utilization_rate = (actual_billable_hours / standard_capacity) * 100.0
    
    # Cap at 100% for visualization purposes (though technically can exceed)
    return max(min(utilization_rate, 100.0), 0.0)


def calculate_assignment_realization_rate(actual_billable_hours, assigned_hours):
    """
    Calculate the Weekly Assignment Realization Rate for a consultant
    
    Assignment Realization Rate = Actual Billable Hours / Assigned Hours
    
    Parameters:
        actual_billable_hours (float): Total actual billable hours logged by the consultant
        assigned_hours (float): Total hours assigned to the consultant
        
    Returns:
        float: Assignment Realization Rate
    """
    if assigned_hours <= 0:
        return 0.0  # Prevent division by zero
        
    realization_rate = actual_billable_hours / assigned_hours
    
    return realization_rate


def compute_evm_metrics(eng_no=None, eng_phase=None, current_date=None):
    """
    Compute comprehensive EVM metrics for projects based on timesheet data.
    Uses DataFetcher to retrieve necessary data.
    
    Parameters:
        eng_no (int/str, optional): Engagement number to filter calculations
        eng_phase (int, optional): Engagement phase to filter calculations
        current_date (datetime, optional): Date for calculations, defaults to today
        
    Returns:
        pd.DataFrame: DataFrame with EVM metrics for each project
    """
    if current_date is None:
        current_date = pd.Timestamp.now()
    
    # Use DataFetcher to get necessary data
    fetcher = DataFetcher()
    data = fetcher.fetch_data(['timesheets', 'phases', 'employees', 'charge_out_rates'])
    
    df_time = data['timesheets']
    df_phases = data['phases']
    df_employees = data['employees']
    df_charge_rates = data['charge_out_rates']
    
    # Filter for specific engagement/phase if provided
    if eng_no is not None:
        df_time = df_time[df_time['eng_no'] == eng_no]
        df_phases = df_phases[df_phases['eng_no'] == eng_no]
        
        if eng_phase is not None:
            df_time = df_time[df_time['eng_phase'] == eng_phase]
            df_phases = df_phases[df_phases['eng_phase'] == eng_phase]
    
    # Ensure date columns are datetime
    df_time['work_date'] = pd.to_datetime(df_time['work_date'])
    df_phases['start_date'] = pd.to_datetime(df_phases['start_date'])
    df_phases['end_date'] = pd.to_datetime(df_phases['end_date'])
    
    # Create project key
    df_time['project_key'] = df_time['eng_no'].astype(str) + '_' + df_time['eng_phase'].astype(str)
    df_phases['project_key'] = df_phases['eng_no'].astype(str) + '_' + df_phases['eng_phase'].astype(str)
    
    # Get project-level data
    projects = []
    
    # For each unique project phase
    for project_key in df_time['project_key'].unique():
        # Filter data for this project
        project_data = df_time[df_time['project_key'] == project_key].copy()
        
        # Extract eng_no and eng_phase
        eng_no, eng_phase = project_key.split('_')
        
        # Get phase data including budget (BAC)
        phase_data = df_phases[df_phases['project_key'] == project_key]
        
        if phase_data.empty:
            # Skip if no phase data found
            continue
            
        # Get BAC and dates from phases table
        bac = phase_data['budget'].iloc[0]
        start_date = phase_data['start_date'].iloc[0]
        planned_end_date = phase_data['end_date'].iloc[0]
        
        # Calculate planned duration in days
        if pd.notna(start_date) and pd.notna(planned_end_date):
            planned_duration = (planned_end_date - start_date).days
        else:
            # Fallback calculation if dates not available
            total_hours = project_data['hours'].sum()
            avg_daily_hours = 8 * 5  # Assumption: 5 people working 8 hours/day
            planned_duration = max(1, total_hours / avg_daily_hours)  # in days, minimum 1
        
        # Calculate EVM metrics
        schedule_elapsed = calculate_schedule_elapsed(start_date, planned_duration, current_date)
        planned_value = calculate_planned_value(bac, schedule_elapsed)
        earned_value = calculate_earned_value(project_data, bac)
        spi = calculate_spi(earned_value, planned_value)
        
        # Calculate VEC and Burn
        vec = calculate_vec(project_data, bac, df_employees)
        burn = calculate_burn(project_data, bac)
        
        # Add to projects list
        projects.append({
            'project_key': project_key,
            'eng_no': eng_no,
            'eng_phase': eng_phase,
            'phase_description': phase_data['phase_description'].iloc[0] if 'phase_description' in phase_data else '',
            'bac': bac,
            'start_date': start_date,
            'planned_end_date': planned_end_date,
            'planned_duration': planned_duration,
            'actual_hours': project_data['hours'].sum(),
            'actual_cost': (project_data['std_price'] + project_data['adm_surcharge']).sum(),
            'schedule_elapsed': schedule_elapsed,
            'planned_value': planned_value,
            'earned_value': earned_value,
            'spi': spi,
            'vec': vec,
            'burn': burn,
            'current_date': current_date
        })
    
    # Convert to DataFrame
    return pd.DataFrame(projects)
