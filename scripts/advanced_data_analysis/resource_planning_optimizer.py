"""
Resource allocation analysis for KPMG Data Challenge.

This script analyzes resource allocation across projects and phases
to identify optimization opportunities.
"""
import os
import sys
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta
import logging

# Add directories to sys.path
current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
project_root = current_dir.parent.parent
shared_dir = project_root / "scripts" / "shared"
sys.path.append(str(shared_dir))
sys.path.append(str(current_dir))

# Import from shared modules
from config import TRANSFORMED_DIR, CSV_DUMP_DIR
from db_utils import test_db_connection, create_sqlalchemy_engine

# Import from local modules
from utils.fetcher import DataFetcher

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def analyze_resource_allocation():
    """
    Analyze resource allocation patterns across projects and consultants.
    """
    # Create fetcher instance
    fetcher = DataFetcher()
    
    # First test database connection using shared utility
    db_available = test_db_connection(timeout=3)
    logger.info(f"Database connection available: {db_available}")
    
    # Use 'db' source if available, otherwise fallback to 'csv'
    source = 'db' if db_available else 'csv'
    fetcher = DataFetcher(source=source)
    
    # Fetch all required data
    logger.info("Fetching data for resource allocation analysis...")
    data = fetcher.fetch_data([
        'timesheets', 
        'employees', 
        'engagements',
        'phases', 
        'staffing'
    ])
    
    # Process and analyze the data
    timesheets = data['timesheets']
    employees = data['employees']
    engagements = data['engagements']
    phases = data['phases']
    staffing = data['staffing']
    
    # Print data stats
    logger.info(f"Loaded {len(timesheets)} timesheet records")
    logger.info(f"Loaded {len(employees)} employee records")
    logger.info(f"Loaded {len(engagements)} engagement records")
    logger.info(f"Loaded {len(phases)} phase records")
    logger.info(f"Loaded {len(staffing)} staffing records")
    
    # Example: Calculate engagement-level metrics
    engagement_hours = timesheets.groupby('eng_no')['hours'].sum().reset_index()
    engagement_hours = pd.merge(
        engagement_hours, 
        engagements[['eng_no', 'eng_description']], 
        on='eng_no', 
        how='left'
    )
    
    # Return some analysis results
    return {
        'engagement_hours': engagement_hours
    }

if __name__ == "__main__":
    # Run the analysis
    logger.info("Starting resource allocation analysis")
    results = analyze_resource_allocation()
    
    # Print top engagements by hours
    if 'engagement_hours' in results and not results['engagement_hours'].empty:
        top_engagements = results['engagement_hours'].sort_values('hours', ascending=False).head(10)
        logger.info("\nTop 10 Engagements by Hours:")
        print(top_engagements)
