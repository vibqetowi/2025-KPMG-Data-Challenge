import pandas as pd

def calculate_ev(phases_df: pd.DataFrame) -> pd.Series:
    """
    Calculates Earned Value (EV) for each phase.
    EV = Budget × % Complete
    """
    if "budget" not in phases_df or "percent_complete" not in phases_df:
        raise ValueError("phases_df must contain 'budget' and 'percent_complete' columns")

    return phases_df["budget"] * (phases_df["percent_complete"] / 100)


def calculate_pv(phases_df: pd.DataFrame) -> pd.Series:
    """
    Calculates Planned Value (PV) for each phase.
    PV = Budget × % Planned (can be based on planned duration / total duration)
    """
    if "budget" not in phases_df or "planned_percent" not in phases_df:
        raise ValueError("phases_df must contain 'budget' and 'planned_percent' columns")

    return phases_df["budget"] * (phases_df["planned_percent"] / 100)


def calculate_spi(ev: pd.Series, pv: pd.Series) -> pd.Series:
    """
    Calculates Schedule Performance Index (SPI).
    SPI = EV / PV
    """
    return ev / pv.replace(0, pd.NA)
