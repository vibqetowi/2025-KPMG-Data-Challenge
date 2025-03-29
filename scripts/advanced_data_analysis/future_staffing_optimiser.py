import numpy as np
import pandas as pd
import logging
import os
import warnings

# Try to import PuLP - but make the script work even if it's not available
try:
    from pulp import LpMaximize, LpProblem, LpVariable, LpStatus, value, lpSum
    PULP_AVAILABLE = True
except ImportError:
    warnings.warn("PuLP is not installed. Optimization functionality will be limited. Run 'pip install pulp' to fix.")
    PULP_AVAILABLE = False

from fetcher import DataFetcher
