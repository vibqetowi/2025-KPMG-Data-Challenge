import pandas as pd
import numpy as np

def main():
    """
    Simple test script for comparing different VEC formulas:
    
    New Formula: VEC = (1/BAC) × Σ[AC_i × d_i × ea_j × eo_j]
    Where:
    - d_i = Chargeout_i / StandardChargeout_j (rate efficiency factor)
    - ea_j = External adjustment (1.0 for internal, 0.9 for external)
    - eo_j = Onboarding adjustment (1.0 for experienced, 0.8 for new)
    
    Variants tested:
    - Standard VEC: Uses all transactions
    - VEC-no-neg: Only counts positive transactions in numerator, but uses all in denominator
    - VEC-ignore-refunds: Completely ignores negative transactions (for both numerator and denominator)
    
    Each formula is calculated independently per phase, not as a project total.
    """
    print("Creating test data...")
    
    # Create fake timesheet data
    timesheet_data = {
        'personnel_no': [101, 101, 101, 101, 101, 101, 101, 101],  # Added two more entries
        'eng_no': [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
        'eng_phase': [1, 1, 1, 2, 2, 2, 1, 2],  # One more entry per phase
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
    
    print("\nPROBLEM ANALYSIS: Let's reason through issues with VEC calculation")
    print("---------------------------------------------------------------")
    print("1. Negative transaction values exist when hours are adjusted between phases")
    print("2. The new rate efficiency factor d_i = Chargeout/Standard directly represents pricing power:")
    print("   - When d_i > 1: Premium billing (more profitable)")
    print("   - When d_i = 1: Standard rate billing")
    print("   - When d_i < 1: Discounted billing (less profitable)")
    print("3. Each transaction directly contributes its value (AC_i) to the VEC calculation")
    
    # Process data and print raw transactions for analysis
    print("\nRaw transaction analysis:")
    print("-------------------------")
    for phase, group in timesheet_df.groupby('eng_phase'):
        print(f"\nPhase {phase}:")
        print("Hours\tRate\tValue\td_i")
        print("-----\t----\t-----\t----")
        for _, row in group.iterrows():
            value = row['std_price'] + row['adm_surcharge']
            d_i = row['charge_out_rate'] / 250  # New d_i calculation
            print(f"{row['hours']}\t{row['charge_out_rate']}\t{value}\t{d_i:.4f}")
    
    print("\nCalculating VEC with the new formula...")
    
    # Process data once and calculate formulas
    processed_data = prepare_data(timesheet_df, std_rates_df)
    
    # Print results with emphasis on per-phase calculation
    print("\nPHASE-SPECIFIC VEC COMPARISON (with BAC = AC for normalization):")
    print("=============================================================")
    print("Phase\tVEC\t\tVEC-no-neg\tVEC-ignore-refunds")
    print("-----\t--------\t--------\t----------------")
    
    for phase_key, phase_data in processed_data.items():
        # Get results
        vec = phase_data['vec']
        vec_no_neg = phase_data['vec_no_neg']
        vec_ignore_refunds = phase_data['vec_ignore_refunds']
        
        # Print results
        print(f"{phase_key}\t{vec:.4f}\t\t{vec_no_neg:.4f}\t\t{vec_ignore_refunds:.4f}")
    
    print("\nREASONING & CONCLUSION:")
    print("----------------------")
    print("1. Each phase's VEC is calculated independently based on its own transactions")
    print("2. Negative transactions represent adjustments that are already reflected in other phases")
    print("3. Including negative transactions in VEC can distort the metric's meaning")
    print("4. VEC > 1 indicates premium value extraction (charging above standard rates)")
    print("5. VEC = 1 indicates standard value extraction (charging exactly at standard rates)")
    print("6. VEC < 1 indicates discounted value extraction (charging below standard rates)")
    print("7. The VEC-ignore-refunds variant provides the clearest view by completely removing negative")
    print("   transactions from the calculation, avoiding any distortion from refunds or adjustments")
    
    # Print detailed calculation for each phase
    for phase_key in sorted(processed_data.keys()):
        print_detailed_calculation(processed_data[phase_key], phase_key)

def prepare_data(timesheet_df, std_rates_df):
    """
    Process input data and calculate the new VEC formula:
    VEC = (1/BAC) × Σ[AC_i × d_i × ea_j × eo_j]
    
    Each phase is processed independently for a phase-specific VEC
    Simplified: BAC = AC (for normalization), ea_j = 1, eo_j = 1
    """
    # Create merged dataframe with just the necessary columns
    merged_df = timesheet_df.copy()
    
    # Calculate all factors needed for VEC
    merged_df['transaction_value'] = merged_df['std_price'] + merged_df['adm_surcharge']
    
    # Merge with standard rates
    merged_df = pd.merge(
        merged_df,
        std_rates_df,
        on='personnel_no',
        how='left'
    )
    
    # Calculate rate efficiency factor d_i (now direct ratio)
    merged_df['d_i'] = merged_df['charge_out_rate'] / merged_df['standard_chargeout_rate']
    
    # Hardcode ea_j and eo_j to 1 (no external or new employee adjustments)
    merged_df['ea_j'] = 1
    merged_df['eo_j'] = 1
    
    # Initialize result dictionary
    result = {}
    
    # Group by project phase
    for eng_phase, group in merged_df.groupby('eng_phase'):
        # Calculate actual cost (AC) - use as BAC for normalization
        ac = group['transaction_value'].sum()
        
        vec_sum = 0
        vec_no_neg_sum = 0
        positive_transactions_value = 0
        transactions = []
        
        for idx, row in group.iterrows():
            # Calculate VEC component for this transaction: AC_i × d_i × ea_j × eo_j
            efficiency = row['d_i'] * row['ea_j'] * row['eo_j']
            vec_component = row['transaction_value'] * efficiency
            vec_sum += vec_component
            
            # For no-negatives calculations
            if row['transaction_value'] > 0:
                positive_transactions_value += row['transaction_value']
                vec_no_neg_sum += vec_component
            
            # Store transaction details for printing
            transactions.append({
                'idx': idx,
                'hours': row['hours'],
                'rate': row['charge_out_rate'],
                'value': row['transaction_value'],
                'd_i': row['d_i'],
                'ea_j': row['ea_j'],
                'eo_j': row['eo_j'],
                'efficiency': efficiency,
                'vec_component': vec_component
            })
        
        # Calculate normalized VEC values (using AC as BAC)
        vec = vec_sum / ac if ac != 0 else 0
        vec_no_neg = vec_no_neg_sum / positive_transactions_value if positive_transactions_value > 0 else 0
        
        # Calculate VEC that completely ignores refunds (negative transactions)
        vec_ignore_refunds = vec_no_neg  # Same formula, but with conceptual difference in interpretation
        
        # Store results
        result[eng_phase] = {
            'ac': ac, 
            'vec': vec,
            'vec_no_neg': vec_no_neg,
            'vec_ignore_refunds': vec_ignore_refunds,
            'transactions': transactions,
            'positive_transactions_value': positive_transactions_value,
            'vec_sum': vec_sum,
            'vec_no_neg_sum': vec_no_neg_sum
        }
    
    return result

def print_detailed_calculation(phase_data, phase_number):
    """Print detailed calculation steps for educational purposes"""
    print(f"\nDetailed VEC Calculation for Phase {phase_number}:")
    print(f"--------------------------------------")
    print(f"Phase AC = {phase_data['ac']}, Using BAC = AC for normalization")
    print(f"Total positive transaction value for this phase = {phase_data['positive_transactions_value']}")
    
    print("\nTransaction breakdown:")
    print("Idx\tHours\tRate\tValue\t\td_i\t\tVEC Component\tInclude in no-neg?")
    print("---\t-----\t----\t-----\t\t----\t\t------------\t-----------------")
    
    for t in phase_data['transactions']:
        include = "Yes" if t['value'] > 0 else "No (negative)"
        print(f"{t['idx']}\t{t['hours']}\t{t['rate']}\t{t['value']}\t\t{t['d_i']:.4f}\t\t{t['vec_component']:.2f}\t\t{include}")
    
    print(f"\nPhase {phase_number} VEC Calculation:")
    print(f"Sum of (AC_i × d_i × ea_j × eo_j) = {phase_data['vec_sum']:.2f}")
    print(f"BAC (normalized to AC) = {phase_data['ac']:.2f}")
    print(f"VEC = (1/BAC) × Sum = {phase_data['vec']:.4f}")
    
    print(f"\nPhase {phase_number} VEC (no negatives) Calculation:")
    print(f"Sum of positive (AC_i × d_i × ea_j × eo_j) = {phase_data['vec_no_neg_sum']:.2f}")
    print(f"Positive AC = {phase_data['positive_transactions_value']:.2f}")
    print(f"VEC (no negatives) = {phase_data['vec_no_neg']:.4f}")
    
    print(f"\nPhase {phase_number} VEC (ignore refunds) Calculation:")
    print(f"This method completely ignores negative transactions/refunds")
    print(f"Sum of positive (AC_i × d_i × ea_j × eo_j) = {phase_data['vec_no_neg_sum']:.2f}")
    print(f"Denominator (positive AC only) = {phase_data['positive_transactions_value']:.2f}")
    print(f"VEC (ignore refunds) = {phase_data['vec_ignore_refunds']:.4f}")
    
    print("\nInterpretation:")
    if phase_data['vec'] > 1:
        print("VEC > 1: This phase is extracting premium value (charging above standard rates)")
    elif phase_data['vec'] < 1:
        print("VEC < 1: This phase is extracting discounted value (charging below standard rates)")
    else:
        print("VEC = 1: This phase is extracting standard value (charging at standard rates)")

if __name__ == '__main__':
    main()