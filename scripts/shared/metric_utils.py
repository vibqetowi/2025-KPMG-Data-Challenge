"""
Shared utilities for calculating metrics used across different modules.

This module provides functions for:
- Calculating project performance metrics (SPI, VEC, etc.)
- Processing timesheet data for ratio calculations
- Date and calendar utilities
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import logging
import sys
import os
from pathlib import Path

# Add utils directory to path to import evm_metrics
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
utils_dir = project_root / "scripts" / "advanced_data_analysis" / "utils"
sys.path.append(str(utils_dir))

# Import EVM metrics functions
from evm_metrics import (
    calculate_spi, calculate_vec, calculate_burn, 
    calculate_schedule_elapsed, calculate_planned_value, calculate_earned_value
)

logger = logging.getLogger(__name__)

def calculate_staffing_ratios(timesheet_data, employee_data, engagement_id=None, phase_id=None, start_date=None, end_date=None):
    """
    Calculate staffing ratios by staff level and practice for engagements.
    
    Args:
        timesheet_data (DataFrame): Timesheet data
        employee_data (DataFrame): Employee information with staff level and practice
        engagement_id (int, optional): Filter for specific engagement
        phase_id (int, optional): Filter for specific phase
        start_date (datetime, optional): Start date for timesheet data
        end_date (datetime, optional): End date for timesheet data
        
    Returns:
        DataFrame: Ratios by engagement, phase, staff level, and practice
    """
    # Filter data if needed
    if engagement_id is not None:
        timesheet_data = timesheet_data[timesheet_data['eng_no'] == engagement_id]
    
    if phase_id is not None and 'eng_phase' in timesheet_data.columns:
        timesheet_data = timesheet_data[timesheet_data['eng_phase'] == phase_id]
    
    # Handle date columns with different names
    work_date_col = 'work_date'
    if work_date_col not in timesheet_data.columns and 'Work Date' in timesheet_data.columns:
        work_date_col = 'Work Date'
    
    # Filter by date if provided
    if start_date is not None and work_date_col in timesheet_data.columns:
        timesheet_data[work_date_col] = pd.to_datetime(timesheet_data[work_date_col], errors='coerce')
        timesheet_data = timesheet_data[timesheet_data[work_date_col] >= start_date]
    
    if end_date is not None and work_date_col in timesheet_data.columns:
        if not pd.to_datetime(timesheet_data[work_date_col], errors='coerce').dt.tz:
            timesheet_data = timesheet_data[timesheet_data[work_date_col] < end_date]
    
    # Merge with employee data to get staff level and practice
    personnel_col = 'personnel_no'
    if personnel_col not in timesheet_data.columns and 'Personnel No.' in timesheet_data.columns:
        personnel_col = 'Personnel No.'
    
    if personnel_col in timesheet_data.columns:
        merged_data = pd.merge(
            timesheet_data,
            employee_data,
            on=personnel_col,
            how='left'
        )
    else:
        logger.error("Cannot find personnel column in timesheet data")
        return pd.DataFrame()
    
    # Aggregate hours by engagement, phase, staff level, and practice
    hours_col = 'hours'
    if hours_col not in timesheet_data.columns and 'Hours' in timesheet_data.columns:
        hours_col = 'Hours'
    
    # Group by engagement and phase
    if 'eng_phase' in merged_data.columns:
        grouped = merged_data.groupby(['eng_no', 'eng_phase'])
    else:
        grouped = merged_data.groupby(['eng_no'])
    
    ratios = []
    
    for group_key, group_data in grouped:
        if isinstance(group_key, tuple):
            eng_no, eng_phase = group_key
        else:
            eng_no = group_key
            eng_phase = None
        
        total_hours = group_data[hours_col].sum()
        if total_hours > 0:
            # Staff level ratios
            if 'staff_level' in group_data.columns:
                for level, level_data in group_data.groupby('staff_level'):
                    level_hours = level_data[hours_col].sum()
                    level_ratio = level_hours / total_hours
                    
                    ratios.append({
                        'eng_no': eng_no,
                        'eng_phase': eng_phase,
                        'staff_level': level,
                        'practice_id': None,
                        'ratio': level_ratio
                    })
            
            # Practice ratios
            if 'practice_id' in group_data.columns:
                for practice, practice_data in group_data.groupby('practice_id'):
                    if pd.notna(practice):
                        practice_hours = practice_data[hours_col].sum()
                        practice_ratio = practice_hours / total_hours
                        
                        ratios.append({
                            'eng_no': eng_no,
                            'eng_phase': eng_phase,
                            'staff_level': None,
                            'practice_id': practice,
                            'ratio': practice_ratio
                        })
    
    return pd.DataFrame(ratios)

def get_week_start_date(date=None):
    """
    Get the Monday of the week containing the given date.
    
    Args:
        date (datetime, optional): Date to find week start for. Defaults to today.
        
    Returns:
        datetime.date: Monday of the week
    """
    if date is None:
        date = datetime.now().date()
    elif isinstance(date, str):
        date = pd.to_datetime(date).date()
    elif isinstance(date, pd.Timestamp):
        date = date.date()
    
    # Calculate days to subtract to get to Monday (weekday 0)
    days_to_subtract = date.weekday()
    monday = date - timedelta(days=days_to_subtract)
    return monday
