"""
Shared utilities for financial health interpretation based on VEC and Burn metrics.

This module implements the financial health interpretation table from the README:

|                 | VEC > Burn (Premium) | VEC ≈ Burn (Standard) | VEC < Burn (Dilution) |
| :-------------- | :------------------- | :-------------------- | :-------------------- |
| **Burn < 1**    | Excellent            | On Track              | Warning               |
| **Burn ≈ 1**    | Excellent            | On Track              | Warning               |
| **Burn > 1**    | Ambiguous            | Critical              | Critical              |

"""

import pandas as pd
import numpy as np

def classify_financial_state(vec, burn, tolerance=0.05):
    """
    Classify financial state based on relationship between VEC and Burn.
    
    Args:
        vec (float): Value Extraction Coefficient
        burn (float): Budget Burn rate
        tolerance (float): Tolerance for considering VEC ≈ Burn
        
    Returns:
        str: 'Premium Realization', 'Standard Realization', or 'Value Dilution'
    """
    if vec > burn + tolerance:
        return 'Premium Realization'
    elif abs(vec - burn) <= tolerance:
        return 'Standard Realization'
    else:
        return 'Value Dilution'

def classify_budget_state(burn, under_threshold=0.9, over_threshold=1.1):
    """
    Classify budget state based on Burn rate.
    
    Args:
        burn (float): Budget Burn rate
        under_threshold (float): Threshold for considering 'Under Budget'
        over_threshold (float): Threshold for considering 'Over Budget'
        
    Returns:
        str: 'Under Budget', 'At Budget', or 'Over Budget'
    """
    if burn < under_threshold:
        return 'Under Budget'
    elif burn <= over_threshold:
        return 'At Budget'
    else:
        return 'Over Budget'

def determine_financial_health(vec, burn, tolerance=0.05, 
                              under_threshold=0.9, over_threshold=1.1):
    """
    Determine financial health status based on VEC and Burn metrics.
    
    Args:
        vec (float): Value Extraction Coefficient
        burn (float): Budget Burn rate
        tolerance (float): Tolerance for considering VEC ≈ Burn
        under_threshold (float): Threshold for considering 'Under Budget'
        over_threshold (float): Threshold for considering 'Over Budget'
        
    Returns:
        str: 'Excellent', 'On Track', 'Warning', 'Ambiguous', or 'Critical'
    """
    financial_state = classify_financial_state(vec, burn, tolerance)
    budget_state = classify_budget_state(burn, under_threshold, over_threshold)
    
    # Implement the lookup table from the README
    if financial_state == 'Premium Realization':
        if budget_state == 'Over Budget':
            return 'Ambiguous'
        else:
            return 'Excellent'
    elif financial_state == 'Standard Realization':
        if budget_state == 'Over Budget':
            return 'Critical'
        else:
            return 'On Track'
    else:  # Value Dilution
        if budget_state == 'Over Budget':
            return 'Critical'
        else:
            return 'Warning'

def interpret_financial_health(vec, burn):
    """
    Generate a detailed interpretation of financial health based on VEC and Burn.
    
    Args:
        vec (float): Value Extraction Coefficient
        burn (float): Budget Burn rate
        
    Returns:
        dict: Dictionary with financial health interpretation
    """
    financial_state = classify_financial_state(vec, burn)
    budget_state = classify_budget_state(burn)
    health_status = determine_financial_health(vec, burn)
    
    interpretations = {
        'Excellent': "High efficiency, within or at budget. Strong performance.",
        'On Track': "Project progressing with minimal dilution.",
        'Warning': "Inefficiency (dilution) detected, even if currently within budget. "
                  "Potential future problems if trend continues.",
        'Ambiguous': "Over budget, but spend appears efficient. Needs investigation: "
                    "Is the high efficiency justifying the cost (e.g., scope change, premium value), "
                    "or masking poor cost control?",
        'Critical': "Over budget combined with standard or poor efficiency. "
                   "Clear problem with cost control and/or value realization. "
                   "Requires immediate attention."
    }
    
    return {
        'vec': vec,
        'burn': burn,
        'financial_state': financial_state,
        'budget_state': budget_state,
        'health_status': health_status,
        'interpretation': interpretations.get(health_status, 'Unknown status'),
        'vec_vs_burn': f"VEC {'>' if vec > burn else '≈' if abs(vec - burn) <= 0.05 else '<'} Burn"
    }

def analyze_portfolio_health(df, vec_col='vec', burn_col='burn'):
    """
    Analyze financial health across a portfolio of engagements.
    
    Args:
        df (DataFrame): DataFrame with VEC and Burn columns
        vec_col (str): Name of VEC column
        burn_col (str): Name of Burn column
        
    Returns:
        DataFrame: Original DataFrame with additional financial health columns
    """
    result = df.copy()
    
    # Apply financial health classification
    result['financial_state'] = result.apply(
        lambda row: classify_financial_state(row[vec_col], row[burn_col]), axis=1)
    
    result['budget_state'] = result.apply(
        lambda row: classify_budget_state(row[burn_col]), axis=1)
    
    result['health_status'] = result.apply(
        lambda row: determine_financial_health(row[vec_col], row[burn_col]), axis=1)
    
    # Count engagements by health status
    health_counts = result['health_status'].value_counts()
    
    print("\nPortfolio Health Summary:")
    for status, count in health_counts.items():
        pct = count / len(result) * 100
        print(f"{status}: {count} engagements ({pct:.1f}%)")
    
    # Flag critical engagements
    critical_count = sum(result['health_status'].isin(['Critical', 'Warning']))
    if critical_count > 0:
        print(f"\nAttention needed: {critical_count} engagements require attention")
    
    return result
