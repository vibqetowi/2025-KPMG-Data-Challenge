# evm_metrics.py
import pandas as pd

def compute_evm_metrics(df_time, default_bac=100000, avg_rate=100, num_employees=5, hours_per_day=8):
    """
    Computes EV, PV, and SPI for each project based on timesheet data.

    Parameters:
        df_time (pd.DataFrame): The timesheet data containing work_date, Posting Date, Hours, eng_no, eng_phase.
        default_bac (float): Default Budget at Completion if not available.
        avg_rate (float): Average charge-out rate ($/hour).
        num_employees (int): Estimated number of people assigned per project.
        hours_per_day (int): Estimated hours worked per person per day.

    Returns:
        pd.DataFrame: Summary with EV, PV, SPI, and additional metrics.
    """

    # Create a unique key for each phase of a project
    df_time["project_key"] = df_time["eng_no"].astype(str) + "_" + df_time["eng_phase"].astype(str)

    # Ensure work_date and Posting Date are datetime
    df_time["work_date"] = pd.to_datetime(df_time["work_date"])
    df_time["posting_date"] = pd.to_datetime(df_time["posting_date"])

    # Compute cumulative actual hours worked (Earned Value)
    ev = (
        df_time.groupby("project_key")["hours"]
        .sum()
        .reset_index()
        .rename(columns={"hours": "ev_hours"})
            )


    # Convert EV from hours to dollars using average rate
    ev["EV"] = ev["ev_hours"] * avg_rate

    # Get the start and end of the work period per project
    phase_periods = df_time.groupby("project_key")["work_date"].agg(["min", "max"]).reset_index()
    phase_periods = phase_periods.rename(columns={"min": "start_date", "max": "end_date"})

    # Calculate project duration in business days
    phase_periods["duration_days"] = (phase_periods["end_date"] - phase_periods["start_date"]).dt.days.clip(lower=1)

    # Merge EV and project durations
    merged = pd.merge(ev, phase_periods, on="project_key")

    # Assume default BAC and compute PV based on time elapsed
    merged["BAC"] = default_bac
    merged["days_elapsed"] = (pd.Timestamp.today() - merged["start_date"]).dt.days.clip(lower=1)
    merged["days_elapsed"] = merged[["days_elapsed", "duration_days"]].min(axis=1)

    # Planned Value: how much should have been earned by now
    merged["PV"] = (merged["days_elapsed"] / merged["duration_days"]) * merged["BAC"]

    # Schedule Performance Index
    merged["SPI"] = merged["EV"] / merged["PV"]

    # Optional: Cost Performance Index
    merged["AC"] = merged["ev_hours"] * avg_rate
    merged["CPI"] = merged["EV"] / merged["AC"]

    return merged[[
        "project_key", "EV", "PV", "SPI", "CPI", "BAC", "days_elapsed",
        "duration_days", "start_date", "end_date"
    ]].sort_values("project_key")
