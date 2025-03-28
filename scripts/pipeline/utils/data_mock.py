import pandas as pd
from datetime import datetime
import random
from pandas.tseries.offsets import BDay

class DataMocker:
    
    def __init__(self, fetcher=None):
        from advanced_data_analysis.fetcher import DataFetcher
        self.fetcher = fetcher if fetcher else DataFetcher(source="csv")
        
    def create_default_practices(self):
        """
        Create KPMG-specific practices, with SAP as practice ID 1
        """
        practices = [
            {
                'practice_id': 1,
                'practice_name': 'SAP',
                'description': 'SAP Implementation and Advisory Services'
            },
            {
                'practice_id': 2,
                'practice_name': 'Audit & Assurance',
                'description': 'Financial Statement Audits and Assurance Services'
            },
            {
                'practice_id': 3,
                'practice_name': 'Cloud Services',
                'description': 'AWS, Azure, and GCP Implementation Advisory'
            },
            {
                'practice_id': 4, 
                'practice_name': 'Management Consulting',
                'description': 'Strategy and Operations Consulting'
            },
            {
                'practice_id': 5,
                'practice_name': 'Deal Advisory',
                'description': 'Mergers & Acquisitions and Transaction Services'
            },
            {
                'practice_id': 6,
                'practice_name': 'Risk Consulting',
                'description': 'Risk Management, Compliance, and Governance'
            },
            {
                'practice_id': 7,
                'practice_name': 'Technology Consulting',
                'description': 'Digital Transformation and Enterprise Technologies'
            },
            {
                'practice_id': 8,
                'practice_name': 'ESG Advisory',
                'description': 'Environmental, Social, and Governance Services'
            }
        ]
        
        df_practices = pd.DataFrame(practices)
        print(f"Created {len(practices)} KPMG practice records (SAP is default with ID 1)")
        print("Available KPMG practices:")
        for _, practice in enumerate(practices):
            print(f"  - {practice['practice_id']}: {practice['practice_name']}")
        return df_practices

    def create_default_clients(self):
        """
        Create hardcoded client list from case data.
        """
        clients = [
            {
                'client_no': 1000017023,
                'client_name': 'Company X'
            },
            {
                'client_no': 1000017024,
                'client_name': 'Company Y'
            }
        ]
        
        df_clients = pd.DataFrame(clients)
        print(f"Created {len(clients)} default client records")
        return df_clients

    def create_default_employees(self):
        """
        Create hardcoded employee list from case data.
        """
        employees = [
            {'personnel_no': 14523, 'employee_name': 'Alice Dupont', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14524, 'employee_name': 'Bastien Lefèvre', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14525, 'employee_name': 'Camille Moreau', 'staff_level': 'MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14526, 'employee_name': 'Damien Girard', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14529, 'employee_name': 'Gaëlle Petit', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14528, 'employee_name': 'Fabien Martin', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14534, 'employee_name': 'Mathieu Dubois', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14536, 'employee_name': 'Olivier Robert', 'staff_level': 'STAFF ACCOUNTANT/CONSULTA', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14535, 'employee_name': 'Nina Simon', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14532, 'employee_name': 'Julien Thomas', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14533, 'employee_name': 'Léa Fournier', 'staff_level': 'MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14527, 'employee_name': 'Élodie Roux', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14537, 'employee_name': 'Sophie Garnier', 'staff_level': 'SENIOR MANAGER', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14530, 'employee_name': 'Hugo Lemoine', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': False, 'employment_basis': 40.0, 'practice_id': 1},
            {'personnel_no': 14531, 'employee_name': 'Inès Bernard', 'staff_level': 'SPECIALIST/SENIOR CONSULT', 'is_external': True, 'employment_basis': 40.0, 'practice_id': 1}
        ]
        
        df_employees = pd.DataFrame(employees)
        print(f"Created {len(employees)} default employee records")
        return df_employees

    def generate_vacation_data(self, employees_df):
        """
        Generate exactly 5 vacation records, with 1 vacation per employee.
        """
        if employees_df.empty:
            print("No employee data available to generate vacation placeholders")
            return pd.DataFrame()
        
        vacation_periods = [
            ('2025-03-10', '2025-03-17'),  # Spring break
            ('2025-07-01', '2025-07-15'),  # Summer vacations
            ('2025-08-03', '2025-08-17'),
            ('2025-10-20', '2025-10-27'),  # Fall break
            ('2025-12-22', '2025-12-31')   # Winter holidays
        ]
        
        personnel_nos = employees_df['personnel_no'].dropna().unique().tolist()
        
        if not personnel_nos or len(personnel_nos) < 5:
            print(f"Not enough employees ({len(personnel_nos)}) to generate 5 vacations")
            return pd.DataFrame()
        
        selected_employees = random.sample(personnel_nos, 5)
        
        vacations = []
        for i, personnel_no in enumerate(selected_employees):
            start_date, end_date = vacation_periods[i]
            vacations.append({
                'personnel_no': personnel_no,
                'start_date': pd.Timestamp(start_date),
                'end_date': pd.Timestamp(end_date)
            })
        
        df_vacations = pd.DataFrame(vacations)
        print(f"Generated exactly 5 vacation records, 1 per employee")
        
        return df_vacations

    def get_engagement_dates(self, eng_no):
        """
        Returns mock start and end date for an engagement, based on its phases.
        """
        fetcher = self.fetcher
        data = fetcher.fetch_data(["phases", "staffing"])

        phases_df = data["phases"]
        staffing_df = data["staffing"]
  
        # Generate dates for all phases
        phases_with_dates = self.generate_phase_dates_from_budget(phases_df, staffing_df)
        
        print(phases_with_dates[["eng_no", "eng_phase", "start_date", "end_date"]])

       # Filter only phases for this engagement
        rows = phases_with_dates[phases_with_dates["eng_no"] == eng_no]

        if rows.empty:
            return None, None
    
        start_date = rows["start_date"].min()
        end_date = rows["end_date"].max()

        return start_date, end_date

    def get_phase_dates(self, eng_no, eng_phase):
        """
        Returns mock start and end dates for a specific engagement phase.
        """
        fetcher = self.fetcher
        data = fetcher.fetch_data(["phases", "staffing"])

        phases_df = data["phases"]
        staffing_df = data["staffing"]

        # Generate all phase dates
        phases_with_dates = self.generate_phase_dates_from_budget(phases_df, staffing_df)

        # Extract the matching row
        row = phases_with_dates[
        (phases_with_dates["eng_no"] == eng_no) &
        (phases_with_dates["eng_phase"] == eng_phase)
        ]

        if not row.empty:
            return row.iloc[0]["start_date"], row.iloc[0]["end_date"]
        else:
            return None, None
        
    def generate_phase_dates_from_budget(self, phases_df, staffing_df, start_reference="2025-01-01", default_rate=100):
        import pandas as pd
        from datetime import timedelta
        from pandas.tseries.offsets import BDay

        # Merge phase and staffing
        merged = pd.merge(phases_df, staffing_df, on=["eng_no", "eng_phase"], how="left")
        
        # 📥 Load timesheet data to determine actual start dates
        timesheets_df = self.fetcher.fetch_data("timesheets")["timesheets"]

        # 🗓 Get the first work_date per phase
        first_dates = (
            timesheets_df
            .dropna(subset=["eng_no", "eng_phase", "work_date"])
            .groupby(["eng_no", "eng_phase"])["work_date"]
            .min()
            .reset_index()
            .rename(columns={"work_date": "start_date"})
          )


        # Fill missing charge rates if needed
        if "charge_out_rate" not in merged.columns:
            merged["charge_out_rate"] = default_rate
        else:
            merged["charge_out_rate"] = merged["charge_out_rate"].fillna(default_rate)

        # Estimate effort per person (budget ÷ rate)
        merged["effort_hours"] = merged["budget"] / merged["charge_out_rate"]

        # Group by phase and count personnel
        headcounts = (
            merged.groupby(["eng_no", "eng_phase"])["personnel_no"]
            .nunique()
            .reset_index()
        )
        headcounts.rename(columns={"personnel_no": "headcount"}, inplace=True)

        # Merge again
        merged = pd.merge(merged, headcounts, on=["eng_no", "eng_phase"], how="left")

        # Avoid division by zero
        merged["headcount"] = merged["headcount"].replace(0, 1)

        # Duration in days = effort ÷ (headcount × 8)
        merged["duration_days"] = (
            (merged["effort_hours"] / (merged["headcount"] * 8)).round().astype(int)
        )

        # ⬇️ NEW LOGIC: Fetch timesheet data and compute first work date
        timesheets = self.fetcher.fetch_data("timesheets")["timesheets"]
        if "work_date" in timesheets.columns:
            timesheets["work_date"] = pd.to_datetime(timesheets["work_date"])
            first_work_dates = (
                timesheets.groupby(["eng_no", "eng_phase"])["work_date"]
                .min()
                .reset_index()
                .rename(columns={"work_date": "start_date"})
            )
            merged = pd.merge(merged, first_work_dates, on=["eng_no", "eng_phase"], how="left")
        else:
            merged["start_date"] = pd.NaT

        # ⬇️ Fill missing start_date with fallback reference date
        merged["start_date"] = pd.to_datetime(merged["start_date"].fillna(start_reference))

        # Compute end_date using business days (8 hours/day)
        merged["end_date"] = merged["start_date"] + merged["duration_days"].astype(int) * BDay()

        # Return grouped result
        return merged[["eng_no", "eng_phase", "start_date", "end_date"]].drop_duplicates()

    
    def __init__(self, fetcher=None):
        from advanced_data_analysis.fetcher import DataFetcher
        self.fetcher = fetcher if fetcher else DataFetcher(source="csv")


