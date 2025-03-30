import pandas as pd
import sys
import os
from pathlib import Path

# Add parent directories to path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
sys.path.append(str(project_root))

# Import shared modules using project-root relative imports
from scripts.shared.metric_utils import get_week_start_date
from scripts.advanced_data_analysis.utils.evm_metrics import (
    calculate_vec, calculate_burn, calculate_spi,
    calculate_rate_efficiency_factor, calculate_external_adjustment_factor, 
    calculate_onboarding_adjustment_factor
)

def main():
    """
    Simple test script for testing the VEC formula:
    
    VEC_ph = (1/BAC_ph) × ∑[AC_i × d_i × ea_j × eo_j]
    
    Where:
    * d_i = Chargeout_i / StandardChargeout_j (rate efficiency factor)
    * ea_j = 1 - 0.1 × isExternal_j (external adjustment factor)
    * eo_j = 1 - 0.2 × isNew_j (onboarding adjustment factor)
    
    This matches the formula in the README.md documentation.
    """
    print("Creating test data...")
    
    # Create test timesheet data
    timesheet_data = {
        'personnel_no': [101, 101, 101, 101, 101, 101, 101, 101],
        'eng_no': [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
        'eng_phase': [1, 1, 1, 2, 2, 2, 1, 2],
        'work_date': ['2025-01-01', '2025-01-02', '2025-01-03', '2025-01-01', '2025-01-02', '2025-01-03', '2025-01-04', '2025-01-04'],
        'hours': [8.0, 8.0, -2.0, 8.0, 8.0, 2.0, 4.0, 4.0],  # Additional hours entries
        'charge_out_rate': [250, 275, 250, 240, 250, 300, 210, 225],  # Added discounted rates (210, 225)
        'std_price': [2000, 2200, -500, 1920, 2000, 600, 840, 900],  # 210*4=840, 225*4=900
        'adm_surcharge': [200, 220, -50, 192, 200, 60, 84, 90]  # 10% of std_price
    }
    timesheet_df = pd.DataFrame(timesheet_data)
    
    # Standard chargeout rates
    std_rates = {
        'personnel_no': [101],
        'standard_chargeout_rate': [250]
    }
    std_rates_df = pd.DataFrame(std_rates)
    
    # Employee data
    employee_data = {
        'personnel_no': [101],
        'is_external': [False],
        'is_new': [False]
    }
    employee_df = pd.DataFrame(employee_data)

    # Test BAC value
    bac = 10000.0
    
    # Calculate VEC using the shared function
    vec = calculate_vec(timesheet_df, bac, employee_df)
    
    # Calculate Burn using the shared function
    burn = calculate_burn(timesheet_df, bac)
    
    # Print results
    print(f"Value Extraction Coefficient (VEC): {vec:.4f}")
    print(f"Budget Burn: {burn:.4f}")
    
    # Demonstrate component calculations
    print("\nComponent calculations based on README formulas:")
    # Get the first transaction for demonstration
    transaction = timesheet_df.iloc[0]
    standard_rate = std_rates_df.iloc[0]['standard_chargeout_rate']
    
    # Calculate rate efficiency factor
    d_i = calculate_rate_efficiency_factor(transaction['charge_out_rate'], standard_rate)
    print(f"Rate Efficiency Factor (d_i): {d_i:.4f}")
    
    # Calculate external adjustment factor
    ea_j = calculate_external_adjustment_factor(employee_df.iloc[0]['is_external'])
    print(f"External Adjustment Factor (ea_j): {ea_j:.4f}")
    
    # Calculate onboarding adjustment factor
    eo_j = calculate_onboarding_adjustment_factor(employee_df.iloc[0]['is_new'])
    print(f"Onboarding Adjustment Factor (eo_j): {eo_j:.4f}")
    
    # Show week start date calculation
    date = pd.Timestamp('2025-01-03')
    week_start = get_week_start_date(date)
    print(f"\nWeek start date for {date.strftime('%Y-%m-%d')}: {week_start.strftime('%Y-%m-%d')}")
    
    # Add additional financial health interpretation as per README table
    print("\nFinancial Health Interpretation:")
    if vec > burn:
        financial_state = "Premium Realization"
    elif abs(vec - burn) < 0.05:  # Approximate equality check
        financial_state = "Standard Realization"
    else:
        financial_state = "Value Dilution"
        
    if burn < 0.9:
        burn_state = "Under Budget"
    elif burn <= 1.1:
        burn_state = "At Budget"
    else:
        burn_state = "Over Budget"
        
    print(f"VEC ({vec:.2f}) vs Burn ({burn:.2f}): {financial_state}")
    print(f"Budget Status: {burn_state}")
    
    # Determine financial health based on the README table
    if financial_state == "Premium Realization":
        if burn_state != "Over Budget":
            health = "Excellent"
        else:
            health = "Ambiguous"
    elif financial_state == "Standard Realization":
        if burn_state != "Over Budget":
            health = "On Track"
        else:
            health = "Critical"
    else:  # Value Dilution
        if burn_state != "Over Budget":
            health = "Warning"
        else:
            health = "Critical"
            
    print(f"Financial Health: {health}")

if __name__ == "__main__":
    main()