
        elif table_name == "employees":
            # Example mapping from Staffing CSV to employees table
            if "Personnel No." in df.columns and "Employee Name" in df.columns:
                df = df[
                    ["Personnel No.", "Employee Name", "Staff Level"]
                ].drop_duplicates()
                df = df.rename(
                    columns={
                        "Personnel No.": "personnel_no",
                        "Employee Name": "employee_name",
                        "Staff Level": "staff_level",
                    }
                )
                # Add default values for missing columns
                if "is_external" not in df.columns:
                    df["is_external"] = False
                if "employment_basis" not in df.columns:
                    df["employment_basis"] = 40.0
                if "practice_id" not in df.columns:
                    df["practice_id"] = 1  # Default to SAP practice

        elif table_name == "clients":
            # Extract client info from staffing data
            if "Client No." in df.columns and "Client Name" in df.columns:
                df = df[["Client No.", "Client Name"]].drop_duplicates()
                df = df.rename(
                    columns={"Client No.": "client_no", "Client Name": "client_name"}
                )
                df = df.dropna(subset=["client_no", "client_name"])

        # Add more transformations for other tables as needed
        elif table_name == 'phases':
           column_mapping = {
           "Eng. No.": "eng_no",
           "Eng. Phase": "eng_phase",
           "Budget": "budget"
           }
           df = df.rename(columns={k: v for k, v in column_mapping.items() if k in df.columns})
           
        elif table_name == 'staffing':
           column_mapping = {
           "Eng. No.": "eng_no",
           "Eng. Phase": "eng_phase",
           "Personnel No.": "personnel_no"
           }
           df = df.rename(columns={k: v for k, v in column_mapping.items() if k in df.columns})
           
        # Add more transformations for other tables as needed