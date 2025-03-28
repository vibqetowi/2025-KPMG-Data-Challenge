    import pandas as pd
        from pandas.tseries.offsets import BDay

        # ✅ Merge staffing info into phases
        merged = pd.merge(phases_df, staffing_df, on=["eng_no", "eng_phase"], how="left")

        # 📥 Load timesheet data and convert dates
        timesheets = self.fetcher.fetch_data("timesheets")["timesheets"]
        timesheets["work_date"] = pd.to_datetime(timesheets["work_date"])

        # 🗓 Extract earliest work date per phase
        first_work_dates = (
            timesheets
            .dropna(subset=["eng_no", "eng_phase", "work_date"])
            .groupby(["eng_no", "eng_phase"])["work_date"]
            .min()
            .reset_index()
            .rename(columns={"work_date": "start_date"})
        )

        print("📊 First work dates from timesheets:")
        print(first_work_dates.head())

        # 🔁 Merge start dates into main DataFrame
        merged = pd.merge(merged, first_work_dates, on=["eng_no", "eng_phase"], how="left")
        print("🔎 Columns after merge:", merged.columns)

        # 💸 Handle missing charge_out_rate
        if "charge_out_rate" not in merged.columns:
            merged["charge_out_rate"] = default_rate
        else:
            merged["charge_out_rate"] = merged["charge_out_rate"].fillna(default_rate)

        # Estimate effort in hours
        merged["effort_hours"] = merged["budget"] / merged["charge_out_rate"]

        # 👥 Calculate number of unique people per phase
        headcounts = (
            merged.groupby(["eng_no", "eng_phase"])["personnel_no"]
            .nunique()
            .reset_index()
            .rename(columns={"personnel_no": "headcount"})
        )
        merged = pd.merge(merged, headcounts, on=["eng_no", "eng_phase"], how="left")
        merged["headcount"] = merged["headcount"].fillna(1)

        # ⏱️ Compute estimated duration in business days
        merged["duration_days"] = (
            (merged["effort_hours"] / (merged["headcount"] * 8))
            .round()
            .astype(int)
        )

        # 🛟 Fill missing start_date with fallback
        if "start_date" in merged.columns:
            merged["start_date"] = pd.to_datetime(
                merged["start_date"]
            ).where(merged["start_date"].notna(), pd.to_datetime(start_reference))
        else:
            print("⚠️ 'start_date' column missing — using reference date.")
            merged["start_date"] = pd.to_datetime(start_reference)

        # 📆 Compute end_date
        merged["end_date"] = merged["start_date"] + merged["duration_days"] * BDay()

        # ✅ Return final result
        return merged[["eng_no", "eng_phase", "start_date", "end_date"]].drop_duplicates()
