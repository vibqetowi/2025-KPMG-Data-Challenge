import pandas as pd
from datetime import datetime
import random
from pandas.tseries.offsets import BDay

class DataMocker:
    
    
    def __init__(self, fetcher):
        self.fetcher = fetcher
        self._phase_dates_cache = None



        
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
        if self._phase_dates_cache is None:
            data = self.fetcher.fetch_data(["phases", "staffing"])
            self._phase_dates_cache = self.generate_phase_dates_from_budget(data["phases"], data["staffing"])
        rows = self._phase_dates_cache[self._phase_dates_cache["eng_no"] == eng_no]
        return (rows["start_date"].min(), rows["end_date"].max()) if not rows.empty else (None, None)

    def get_phase_dates(self, eng_no, eng_phase):
        if self._phase_dates_cache is None:
            data = self.fetcher.fetch_data(["phases", "staffing"])
            self._phase_dates_cache = self.generate_phase_dates_from_budget(data["phases"], data["staffing"])
        row = self._phase_dates_cache[
            (self._phase_dates_cache["eng_no"] == eng_no) &
            (self._phase_dates_cache["eng_phase"] == eng_phase)
        ]
        return (row.iloc[0]["start_date"], row.iloc[0]["end_date"]) if not row.empty else (None, None)

    def generate_phase_dates_from_budget(self, phases_df, staffing_df, start_reference="2025-01-01", default_rate=100):
        merged = pd.merge(phases_df, staffing_df, on=["eng_no", "eng_phase"], how="left")
        timesheets = self.fetcher.fetch_data("timesheets")["timesheets"]
        timesheets["work_date"] = pd.to_datetime(timesheets["work_date"])
        first_work_dates = (
            timesheets.dropna(subset=["eng_no", "eng_phase", "work_date"])
            .groupby(["eng_no", "eng_phase"])["work_date"]
            .min()
            .reset_index()
            .rename(columns={"work_date": "start_date"})
        )
        merged = pd.merge(merged, first_work_dates, on=["eng_no", "eng_phase"], how="left")
        rate_col = "charge_out_rate"
        merged[rate_col] = merged.get(rate_col, default_rate)
        merged[rate_col] = merged[rate_col].fillna(default_rate)
        merged["effort_hours"] = merged["budget"] / merged[rate_col]
        headcounts = (
            merged.groupby(["eng_no", "eng_phase"])["personnel_no"]
            .nunique()
            .reset_index()
            .rename(columns={"personnel_no": "headcount"})
        )
        merged = pd.merge(merged, headcounts, on=["eng_no", "eng_phase"], how="left")
        merged["headcount"] = merged["headcount"].fillna(1)
        merged["duration_days"] = (merged["effort_hours"] / (merged["headcount"] * 8)).round().astype(int)

        if "start_date_y" in merged.columns:
            start_col = "start_date_y"
        elif "start_date_x" in merged.columns:
            start_col = "start_date_x"
        else:
            start_col = None

        merged["start_date"] = pd.to_datetime(
            merged[start_col] if start_col else start_reference
        ).where(
            merged[start_col].notna() if start_col else False,
            pd.to_datetime(start_reference)
        )

        merged["end_date"] = pd.to_datetime(merged["start_date"]) + merged["duration_days"].apply(lambda x: BDay(x))

        return merged.drop_duplicates(subset=["eng_no", "eng_phase"])[["eng_no", "eng_phase", "start_date", "end_date"]]

    

