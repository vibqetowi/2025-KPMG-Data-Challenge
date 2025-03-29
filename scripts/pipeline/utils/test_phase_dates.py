import sys
import os

# 👇 Add the correct path to access advanced_data_analysis from utils/
current_dir = os.path.dirname(__file__)
scripts_dir = os.path.abspath(os.path.join(current_dir, "..", ".."))
sys.path.insert(0, scripts_dir)  # now scripts/ is in the path

# ✅ Now you can import properly
from advanced_data_analysis.fetcher import DataFetcher
from pipeline.utils.data_mock import DataMocker



# ✅ First, define your custom fetcher with the correct CSV path
fetcher = DataFetcher(source="csv", csv_base_path="C:\\Users\\elrom\\Documents\\2025-KPMG-Data-Challenge\\csv-dump")

# ✅ Then, pass that fetcher into DataMocker
mocker = DataMocker(fetcher=fetcher)

# 🔁 Now you can safely use mocker
data = fetcher.fetch_data(["phases", "staffing"])
phases_df = data["phases"]

print("📦 All Phase Dates")
for _, row in phases_df.iterrows():
    eng_no = row["eng_no"]
    eng_phase = row["eng_phase"]
    start, end = mocker.get_phase_dates(eng_no, eng_phase)
    print(f"  Engagement {eng_no}, Phase {eng_phase} → Start: {start}, End: {end}")

print("\n📁 All Engagement Dates")
engagements = phases_df["eng_no"].unique()
for eng_no in engagements:
    start, end = mocker.get_engagement_dates(eng_no)
    print(f"  Engagement {eng_no} → Start: {start}, End: {end}")
