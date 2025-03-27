-- T-SQL DML MERGE statements (upsert) generated from transformed CSV files
-- Generation timestamp: 2025-03-27 10:34:32

-- Use the database created by the DDL script
USE [KPMG_Data_Challenge];
GO

-- Turn off count of rows affected to improve performance
SET NOCOUNT ON;
GO

-- Enable identity insert where needed
PRINT 'Starting data upsert operations...';
GO

-- MERGE/INSERT statements for practices table
PRINT 'Upserting data into practices table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[practices] AS target
    USING (
        VALUES
        (1, N'SAP', N'SAP Implementation and Advisory Services'),
        (2, N'Audit & Assurance', N'Financial Statement Audits and Assurance Services'),
        (3, N'Cloud Services', N'AWS, Azure, and GCP Implementation Advisory'),
        (4, N'Management Consulting', N'Strategy and Operations Consulting'),
        (5, N'Deal Advisory', N'Mergers & Acquisitions and Transaction Services'),
        (6, N'Risk Consulting', N'Risk Management, Compliance, and Governance'),
        (7, N'Technology Consulting', N'Digital Transformation and Enterprise Technologies'),
        (8, N'ESG Advisory', N'Environmental, Social, and Governance Services')
    ) AS source (practice_id, practice_name, description)
    ON target.[practice_id] = source.[practice_id]
    WHEN MATCHED THEN
        UPDATE SET target.[practice_name] = source.[practice_name], target.[description] = source.[description]
    WHEN NOT MATCHED THEN
        INSERT ([practice_id], [practice_name], [description])
        VALUES (source.[practice_id], source.[practice_name], source.[description]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for practices';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into practices: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for clients table
PRINT 'Upserting data into clients table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[clients] AS target
    USING (
        VALUES
        (1000017023, N'Company X'),
        (1000017024, N'Company Y')
    ) AS source (client_no, client_name)
    ON target.[client_no] = source.[client_no]
    WHEN MATCHED THEN
        UPDATE SET target.[client_name] = source.[client_name]
    WHEN NOT MATCHED THEN
        INSERT ([client_no], [client_name])
        VALUES (source.[client_no], source.[client_name]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for clients';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into clients: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for employees table
PRINT 'Upserting data into employees table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[employees] AS target
    USING (
        VALUES
        (14523, N'Alice Dupont', N'SPECIALIST/SENIOR CONSULT', 0, 40.00, 1),
        (14524, N'Bastien Lefèvre', N'SPECIALIST/SENIOR CONSULT', 1, 40.00, 1),
        (14525, N'Camille Moreau', N'MANAGER', 0, 40.00, 1),
        (14526, N'Damien Girard', N'SENIOR MANAGER', 0, 40.00, 1),
        (14529, N'Gaëlle Petit', N'SENIOR MANAGER', 0, 40.00, 1),
        (14528, N'Fabien Martin', N'SENIOR MANAGER', 0, 40.00, 1),
        (14534, N'Mathieu Dubois', N'SENIOR MANAGER', 0, 40.00, 1),
        (14536, N'Olivier Robert', N'STAFF ACCOUNTANT/CONSULTA', 1, 40.00, 1),
        (14535, N'Nina Simon', N'SPECIALIST/SENIOR CONSULT', 0, 40.00, 1),
        (14532, N'Julien Thomas', N'SPECIALIST/SENIOR CONSULT', 1, 40.00, 1),
        (14533, N'Léa Fournier', N'MANAGER', 0, 40.00, 1),
        (14527, N'Élodie Roux', N'SPECIALIST/SENIOR CONSULT', 0, 40.00, 1),
        (14537, N'Sophie Garnier', N'SENIOR MANAGER', 0, 40.00, 1),
        (14530, N'Hugo Lemoine', N'SPECIALIST/SENIOR CONSULT', 0, 40.00, 1),
        (14531, N'Inès Bernard', N'SPECIALIST/SENIOR CONSULT', 1, 40.00, 1)
    ) AS source (personnel_no, employee_name, staff_level, is_external, employment_basis, practice_id)
    ON target.[personnel_no] = source.[personnel_no]
    WHEN MATCHED THEN
        UPDATE SET target.[employee_name] = source.[employee_name], target.[staff_level] = source.[staff_level], target.[is_external] = source.[is_external], target.[employment_basis] = source.[employment_basis], target.[practice_id] = source.[practice_id]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [employee_name], [staff_level], [is_external], [employment_basis], [practice_id])
        VALUES (source.[personnel_no], source.[employee_name], source.[staff_level], source.[is_external], source.[employment_basis], source.[practice_id]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for employees';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into employees: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for engagements table
PRINT 'Upserting data into engagements table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[engagements] AS target
    USING (
        VALUES
        (2001920365, N'Neptune', 1000017023, 1),
        (2002040046, N'Terra', 1000017023, 1),
        (3000512342, N'Flora', 1000017024, 1),
        (2002059395, N'Ventus', 1000017023, 1),
        (2002055111, N'Nexus', 1000017024, 1)
    ) AS source (eng_no, eng_description, client_no, primary_practice_id)
    ON target.[eng_no] = source.[eng_no]
    WHEN MATCHED THEN
        UPDATE SET target.[eng_description] = source.[eng_description], target.[client_no] = source.[client_no], target.[primary_practice_id] = source.[primary_practice_id]
    WHEN NOT MATCHED THEN
        INSERT ([eng_no], [eng_description], [client_no], [primary_practice_id])
        VALUES (source.[eng_no], source.[eng_description], source.[client_no], source.[primary_practice_id]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for engagements';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into engagements: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for phases table
PRINT 'Upserting data into phases table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[phases] AS target
    USING (
        VALUES
        (2001920365, 10, N'Mars', 2300000.00),
        (2001920365, 20, N'Solaris', 1150000.00),
        (2001920365, 30, N'Aquilon', 1250000.00),
        (2001920365, 40, N'Horizon', 1350000.00),
        (2002040046, 10, N'Livraison', 950000.00),
        (3000512342, 10, N'Gestion', 3000000.00),
        (2002059395, 10, N'Otientation', 170000.00),
        (2002055111, 10, N'Admin', 2500000.00)
    ) AS source (eng_no, eng_phase, phase_description, budget)
    ON target.[eng_no] = source.[eng_no] AND target.[eng_phase] = source.[eng_phase]
    WHEN MATCHED THEN
        UPDATE SET target.[phase_description] = source.[phase_description], target.[budget] = source.[budget]
    WHEN NOT MATCHED THEN
        INSERT ([eng_no], [eng_phase], [phase_description], [budget])
        VALUES (source.[eng_no], source.[eng_phase], source.[phase_description], source.[budget]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for phases';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into phases: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for dictionary table
PRINT 'Upserting data into dictionary table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[dictionary] AS target
    USING (
        VALUES
        (N'Eng. No.', N'Mandate key'),
        (N'Eng. Description', N'Mandate description'),
        (N'Eng. Phase', N'Mandate phase'),
        (N'Phase Description', N'Mandate phase description'),
        (N'Client No.', N'Client key'),
        (N'Client Name', N'Client name'),
        (N'Personnel No.', N'Employee key'),
        (N'Employee Name', N'Employenomn'),
        (N'Staff Level', N'Employee title'),
        (N'Work Date', N'Work day'),
        (N'Time Entry Date', N'Day when the employee entered the details of their timesheet'),
        (N'Posting Date', N'Day when the employee sent the details of their timesheet'),
        (N'Hours', N'Number of hours entered in the timesheet'),
        (N'Charge+AC0-Out Rate', N'Hourly wage of the employee which is charged to the client'),
        (N'Std. Price', N'Hourly wage +ACo- Number of hours worked'),
        (N'Adm. Surcharge', N'Administrative fees'),
        (N'PV', N'Planned Value - The authorized budget assigned to scheduled work'),
        (N'EV', N'Earned Value - The measure of work performed expressed in terms of the budget authorized for that work'),
        (N'AC', N'Actual Cost - The realized cost incurred for the work performed'),
        (N'SV', N'Schedule Variance - Indicates whether the project is ahead or behind schedule (EV-PV)'),
        (N'CV', N'Cost Variance - Indicates whether the project is under or over budget (EV-AC)'),
        (N'SPI', N'Schedule Performance Index - Measure of schedule efficiency (EV/PV)'),
        (N'CPI', N'Cost Performance Index - Measure of cost efficiency (EV/AC)'),
        (N'BAC', N'Budget At Completion - The total authorized budget for the project'),
        (N'EAC', N'Estimate At Completion - The expected total cost of the project when completed'),
        (N'ETC', N'Estimate To Complete - The expected cost to finish all remaining project work'),
        (N'VAC', N'Variance At Completion - Projection of the amount of budget deficit or surplus (BAC-EAC)'),
        (N'TCPI', N'To Complete Performance Index - The cost performance that must be achieved to complete remaining work within budget')
    ) AS source (key, description)
    ON target.[key] = source.[key]
    WHEN MATCHED THEN
        UPDATE SET target.[description] = source.[description]
    WHEN NOT MATCHED THEN
        INSERT ([key], [description])
        VALUES (source.[key], source.[description]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for dictionary';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into dictionary: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for staffing table
PRINT 'Upserting data into staffing table...';
BEGIN TRY
    BEGIN TRANSACTION;
    SET IDENTITY_INSERT [dbo].[staffing] ON;
    -- Batch 1/1
    MERGE [dbo].[staffing] AS target
    USING (
        VALUES
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 10.00),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 10.00),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 10.00),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 10.00),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 10.00),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 16.00),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 16.00),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 16.00),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 16.00),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-02', 120), 24.00),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 24.00),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 24.00),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-23', 120), 24.00),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-30', 120), 24.00),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 10.00),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 10.00),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-23', 120), 10.00),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-30', 120), 10.00),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-02', 120), 4.00),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 4.00),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 4.00),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-23', 120), 4.00),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-30', 120), 4.00),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 4.00),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 4.00),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 4.00),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 4.00),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 4.00),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 4.00),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 4.00),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 4.00),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 4.00),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-02', 120), 30.00),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 30.00),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 30.00),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 30.00),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-30', 120), 30.00),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 10.00),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 10.00),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 10.00),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-30', 120), 10.00),
        (14527, 3000512342, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14527, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14527, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14527, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14527, 3000512342, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 12.00),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 12.00),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 12.00),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 12.00),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 12.00),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 36.00),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 36.00),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 36.00),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 36.00),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 36.00),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 16.00),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 16.00),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 16.00),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 16.00),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 16.00),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 24.00),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 24.00),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 24.00),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 24.00),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-30', 120), 24.00)
    ) AS source (personnel_no, eng_no, eng_phase, week_start_date, planned_hours)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[week_start_date] = source.[week_start_date], target.[planned_hours] = source.[planned_hours]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours])
        VALUES (source.[personnel_no], source.[eng_no], source.[eng_phase], source.[week_start_date], source.[planned_hours]);
    SET IDENTITY_INSERT [dbo].[staffing] OFF;
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for staffing';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into staffing: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for timesheets table
PRINT 'Upserting data into timesheets table...';
BEGIN TRY
    BEGIN TRANSACTION;
    SET IDENTITY_INSERT [dbo].[timesheets] ON;
    -- Batch 1/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 2.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 525.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 4.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 840.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 420.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 2.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 420.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), -4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, -840.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), -1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, -210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), -1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, -210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), -2.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, -525.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 105.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 3.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 735.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 840.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 3.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 630.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, 210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 210.00, 210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, 210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 8.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 1680.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 8.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 1680.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 4.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 840.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 840.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 4.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 210.00, 945.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-17', 120), 2.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-17', 120), 210.00, 420.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 2.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-18', 120), 210.00, 525.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-19', 120), 2.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-19', 120), 210.00, 420.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-10', 120), 1.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-20', 120), 2.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-20', 120), 210.00, 525.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), -4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, -840.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 1.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 210.00, 315.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 3.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 735.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 1.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 315.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-11', 120), 1.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 210.00, 12.60),
        (14523, 2001920365, 10, CONVERT(DATE, '2025-02-14', 120), 0.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 105.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 4.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-16', 120), 210.00, 840.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-17', 120), 7.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), -7.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, -1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), 7.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), 5.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, 1050.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-06', 120), 8.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 1680.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-07', 120), 8.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 1680.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-11', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, -1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), -7.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, -1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 7.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 7.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 7.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 7.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, -1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, -1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-06', 120), -2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, -420.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-04', 120), -3.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, -630.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, 840.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-08', 120), 6.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-06', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 1050.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-04', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 1050.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-12', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-11', 120), 6.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 1365.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), 7.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 7.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, 1050.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), -5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, -1050.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), -4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, -840.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-12', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, -1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), 6.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 6.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 420.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-05', 120), 4.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 840.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-04', 120), 3.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 630.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-17', 120), 6.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-17', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-20', 120), 4.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-20', 120), 210.00, 840.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), -7.00, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, -1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 7.00, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 6.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, 1365.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-21', 120), 3.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 210.00, 630.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-19', 120), 7.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-19', 120), 210.00, 1470.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-18', 120), 5.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-18', 120), 210.00, 1050.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), 7.50, CONVERT(DATE, '2025-02-07', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), -7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, -1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-09', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-11', 120), 6.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-12', 120), 6.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2024-12-13', 120), 5.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 210.00, 1155.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-10', 120), 4.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 840.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-20', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 210.00, 1260.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 8.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, 1680.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-27', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), 8.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, 1680.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 8.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, 1680.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 8.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, 1680.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-22', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 210.00, 1575.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-14', 120), 3.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 735.00, 12.60),
        (14523, 3000512342, 10, CONVERT(DATE, '2025-01-13', 120), 4.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 840.00, 12.60),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-30', 120), 7.50, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-14', 120), CONVERT(DATE, '2025-01-13', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-03', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-02', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-02', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-24', 120), 7.50, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-24', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 7.50, CONVERT(DATE, '2024-12-23', 120), CONVERT(DATE, '2024-12-23', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 7.50, CONVERT(DATE, '2025-01-28', 120), CONVERT(DATE, '2025-01-28', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 7.50, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-29', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-14', 120), CONVERT(DATE, '2025-01-14', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-19', 120), 7.50, CONVERT(DATE, '2025-02-19', 120), CONVERT(DATE, '2025-02-19', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-20', 120), 7.50, CONVERT(DATE, '2025-02-20', 120), CONVERT(DATE, '2025-02-20', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 7.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-10', 120), 7.50, CONVERT(DATE, '2025-02-11', 120), CONVERT(DATE, '2025-02-10', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-11', 120), 7.50, CONVERT(DATE, '2025-02-11', 120), CONVERT(DATE, '2025-02-11', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-12', 120), 7.50, CONVERT(DATE, '2025-02-12', 120), CONVERT(DATE, '2025-02-12', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-13', 120), 7.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-03', 120), 7.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-03-03', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-04', 120), 7.50, CONVERT(DATE, '2025-03-04', 120), CONVERT(DATE, '2025-03-04', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-05', 120), 7.50, CONVERT(DATE, '2025-03-05', 120), CONVERT(DATE, '2025-03-05', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-06', 120), 7.50, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-06', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-07', 120), 7.50, CONVERT(DATE, '2025-02-07', 120), CONVERT(DATE, '2025-02-07', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-06', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-06', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-05', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-04', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-03', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-03', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-17', 120), 7.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-17', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 7.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-18', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-10', 120), 7.50, CONVERT(DATE, '2025-03-11', 120), CONVERT(DATE, '2025-03-10', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-25', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-25', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-20', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-22', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-23', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-27', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-16', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-15', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-26', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-26', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-11', 120), 7.50, CONVERT(DATE, '2025-03-11', 120), CONVERT(DATE, '2025-03-11', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-12', 120), 7.50, CONVERT(DATE, '2025-03-12', 120), CONVERT(DATE, '2025-03-12', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-13', 120), 7.50, CONVERT(DATE, '2025-03-13', 120), CONVERT(DATE, '2025-03-13', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-14', 120), 7.50, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-14', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-03-07', 120), 7.50, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-07', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-24', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-24', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-14', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-27', 120), 7.50, CONVERT(DATE, '2025-02-27', 120), CONVERT(DATE, '2025-02-27', 120), 196.00, 1470.00, 11.76),
        (14524, 2001920365, 10, CONVERT(DATE, '2025-02-28', 120), 7.50, CONVERT(DATE, '2025-02-28', 120), CONVERT(DATE, '2025-02-28', 120), 196.00, 1470.00, 11.76),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-03', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 548.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-06', 120), 274.00, 548.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 2.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 256.00, 512.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 0.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 548.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), 1.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 274.00, 411.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 274.00, 548.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 548.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-14', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-14', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-06', 120), 1.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-06', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 0.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-21', 120), 256.00, 128.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 0.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-18', 120), 256.00, 128.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-24', 120), 1.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-24', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-27', 120), 1.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 256.00, 384.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-03-04', 120), 1.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-04', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 1.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-28', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-31', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-31', 120), 256.00, 128.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-29', 120), 256.00, 128.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-12', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-12', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-02-13', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-13', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-08', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 256.00, 512.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 1.50, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-15', 120), 256.00, 384.00, 15.36)
    ) AS source (personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 2/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (14525, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 256.00, 512.00, 15.36),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), -0.50, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-02', 120), 274.00, -137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), -0.50, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-03', 120), 274.00, -137.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), -2.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, -548.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), -1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, -274.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), -2.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-06', 120), 274.00, -548.00, 16.44),
        (14525, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-02', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 274.00, 548.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2025-01-15', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-15', 120), 256.00, 256.00, 15.36),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), -1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, -274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), -1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, -274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 274.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 274.00, 137.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-11', 120), 1.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 274.00, 411.00, 16.44),
        (14525, 2001920365, 40, CONVERT(DATE, '2024-12-13', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 137.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 0.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 274.00, 137.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 7.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-06', 120), 256.00, 1792.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 1.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-05', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-13', 120), 1.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 411.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 274.00, 274.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 274.00, 274.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 274.00, 274.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), 3.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 822.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 1.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-16', 120), 274.00, 411.00, 16.44),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-21', 120), 1.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-21', 120), 256.00, 384.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-17', 120), 2.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-17', 120), 256.00, 512.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 2.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-14', 120), 256.00, 512.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 2.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-13', 120), 256.00, 512.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 0.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-12', 120), 256.00, 128.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 1.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-11', 120), 256.00, 384.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-10', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-31', 120), 256.00, 128.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 1.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-30', 120), 256.00, 384.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 1.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-29', 120), 256.00, 384.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-27', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-27', 120), 256.00, 128.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-20', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 256.00, 128.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-21', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-22', 120), 1.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 256.00, 384.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-23', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-03-04', 120), 0.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-04', 120), 256.00, 128.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-03-03', 120), 0.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-03', 120), 256.00, 128.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-26', 120), 1.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-26', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-27', 120), 1.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-02-28', 120), 0.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-28', 120), 256.00, 128.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-08', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-08', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-09', 120), 256.00, 512.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-10', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-10', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-14', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-16', 120), 256.00, 256.00, 15.36),
        (14525, 3000512342, 10, CONVERT(DATE, '2025-01-17', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 256.00, 512.00, 15.36),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 137.00, 16.44),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 548.00, 16.44),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-13', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 137.00, 16.44),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 274.00, 137.00, 16.44),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 137.00, 16.44),
        (14525, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 3.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-07', 120), 256.00, 768.00, 15.36),
        (14525, 2002040046, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-16', 120), 256.00, 256.00, 15.36),
        (14525, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), -0.50, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, -137.00, 16.44),
        (14525, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 3.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-08', 120), 256.00, 768.00, 15.36),
        (14525, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-09', 120), 256.00, 512.00, 15.36),
        (14525, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-10', 120), 256.00, 256.00, 15.36),
        (14525, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-16', 120), 256.00, 256.00, 15.36),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 15.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 5820.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 15.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 5820.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2910.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), 5.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 3104.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-13', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-13', 120), 388.00, 1552.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-12', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-12', 120), 388.00, 1552.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-11', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-11', 120), 388.00, 1552.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-10', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-10', 120), 388.00, 1552.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-18', 120), 388.00, 1164.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-19', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-19', 120), 388.00, 1164.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-20', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-20', 120), 388.00, 1164.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-21', 120), 388.00, 1164.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-24', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-24', 120), 388.00, 776.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-25', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-25', 120), 388.00, 776.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-26', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-26', 120), 388.00, 776.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-27', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 388.00, 776.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-28', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-28', 120), 388.00, 776.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-31', 120), 4.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-31', 120), 388.00, 1552.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-30', 120), 6.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-30', 120), 388.00, 2328.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 4.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 1552.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 4.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 1552.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), 5.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 1940.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-03', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-03', 120), 388.00, 2328.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-04', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-04', 120), 388.00, 2328.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-05', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-05', 120), 388.00, 2328.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-06', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-06', 120), 388.00, 2328.00, 23.28),
        (14526, 2001920365, 10, CONVERT(DATE, '2025-02-07', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-07', 120), 388.00, 2328.00, 23.28),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-02', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-02', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-03', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-28', 120), 7.50, CONVERT(DATE, '2025-02-28', 120), CONVERT(DATE, '2025-02-28', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-27', 120), 7.50, CONVERT(DATE, '2025-02-27', 120), CONVERT(DATE, '2025-02-27', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-26', 120), 6.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-26', 120), 210.00, 1365.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-25', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-25', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 6.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 1365.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 8.00, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 1680.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-24', 120), 9.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-24', 120), 210.00, 1995.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), -4.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, -945.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), -10.00, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, -2100.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-21', 120), 7.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 210.00, 1470.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-20', 120), 6.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-20', 120), 210.00, 1365.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-19', 120), 7.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-19', 120), 210.00, 1470.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-18', 120), 9.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-18', 120), 210.00, 1995.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 4.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 945.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 9.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 1995.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 10.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 2100.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), 5.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, 1050.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 6.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, 1365.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 8.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, 1680.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), 10.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, 2100.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), -7.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), -2.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, -525.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), -7.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, -1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), -7.00, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, -1470.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 6.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, 1365.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), 6.00, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, 1260.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 2.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, 525.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 5.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, 1155.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 2.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, 525.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 7.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), 7.00, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, 1470.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-27', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-17', 120), 11.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-17', 120), 210.00, 2415.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), 7.50, CONVERT(DATE, '2025-02-07', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-03', 120), 10.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-03', 120), 210.00, 2100.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-04', 120), 11.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-04', 120), 210.00, 2310.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-05', 120), 12.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-05', 120), 210.00, 2520.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-06', 120), 6.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-06', 120), 210.00, 1260.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-07', 120), 1.00, CONVERT(DATE, '2025-03-07', 120), CONVERT(DATE, '2025-03-07', 120), 210.00, 210.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-20', 120), 8.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 210.00, 1680.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-21', 120), 8.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 210.00, 1680.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-22', 120), 10.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 210.00, 2100.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 5.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 210.00, 1155.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-11', 120), 14.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-11', 120), 210.00, 2940.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-10', 120), 9.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-10', 120), 210.00, 1890.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-07', 120), -1.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-07', 120), 210.00, -210.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-07', 120), 8.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-07', 120), 210.00, 1680.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-12', 120), 12.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-12', 120), 210.00, 2520.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-13', 120), 9.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-13', 120), 210.00, 1890.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-03-14', 120), 7.50, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-14', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 210.00, 1575.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-16', 120), 10.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 210.00, 2205.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-15', 120), 10.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 210.00, 2205.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-14', 120), 11.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 2415.00, 12.60),
        (14527, 3000512342, 10, CONVERT(DATE, '2025-01-13', 120), 10.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 2100.00, 12.60),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-28', 120), 7.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-28', 120), 318.00, 2226.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-24', 120), 7.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 318.00, 2226.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-23', 120), 8.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-23', 120), 318.00, 2544.00, 19.08)
    ) AS source (personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 3/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-22', 120), 8.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-21', 120), 8.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-20', 120), 8.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-17', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-27', 120), 8.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-26', 120), 8.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-26', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-24', 120), 8.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-24', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-25', 120), 8.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-25', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-13', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-13', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-14', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-14', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-17', 120), 9.00, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-17', 120), 318.00, 2862.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-18', 120), 8.50, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-18', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-19', 120), 8.50, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-19', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-20', 120), 8.50, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-20', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-21', 120), 5.00, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-21', 120), 318.00, 1590.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-04', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 3104.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-05', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 3104.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-06', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2328.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-11', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 3298.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-12', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3298.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-13', 120), 6.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2522.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-02', 120), 9.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 3492.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-03', 120), 9.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 3492.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-09', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 3298.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3104.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-16', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 3298.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-17', 120), 9.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 3492.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2024-12-18', 120), 7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2716.00, 23.28),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-27', 120), 8.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-27', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-28', 120), 8.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-28', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-29', 120), 8.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-29', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-30', 120), 8.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-30', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-31', 120), 318.00, 2385.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-03', 120), 8.50, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-03', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-04', 120), 8.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-04', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-12', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-12', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-03-04', 120), 8.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-04', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-03-03', 120), 8.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-03', 120), 318.00, 2703.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-13', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-13', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-14', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-15', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-15', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-01-16', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-16', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-03-05', 120), 8.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-05', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-03-06', 120), 8.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-06', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-03-07', 120), 7.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-07', 120), 318.00, 2226.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-05', 120), 318.00, 2385.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-06', 120), 8.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-06', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-07', 120), 8.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-07', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-10', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-10', 120), 318.00, 2544.00, 19.08),
        (14528, 2001920365, 20, CONVERT(DATE, '2025-02-11', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-11', 120), 318.00, 2544.00, 19.08),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 8.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 3104.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), 9.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, 3492.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-23', 120), 7.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, 2716.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), 3.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, 1358.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 6.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 5.00, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 1940.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 6.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-02', 120), 3.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2025-01-02', 120), 388.00, 1358.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-31', 120), 3.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-31', 120), 388.00, 1358.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 6.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-30', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-27', 120), 2.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-27', 120), 388.00, 970.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 1.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 388.00, 582.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 7.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 2716.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 10.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 3880.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), 9.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 3686.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 6.00, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 8.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 3298.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), 5.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 2134.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 6.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-15', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, 388.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-27', 120), -2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-27', 120), 388.00, -970.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-30', 120), 388.00, -2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-31', 120), -3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-31', 120), 388.00, -1358.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-02', 120), -3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-02', 120), 388.00, -1358.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, -2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), -5.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, -1940.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, -2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), -7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, -2716.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), -10.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, -3880.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), -8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, -3104.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), -5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, -2134.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), -8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, -3104.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), -9.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, -3492.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-23', 120), -7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, -2716.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), -3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, -1358.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), -9.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, -3686.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, -2328.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), -8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, -3298.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 5.50, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 2134.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), -1.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-23', 120), 388.00, -582.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 2716.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 2.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 970.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2134.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3298.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 10.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 4074.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 3104.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, -2328.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-19', 120), -4.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, -1552.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-18', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), -5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, -2134.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, -2522.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-15', 120), -1.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, -388.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, -2328.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), -8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, -3104.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), -10.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, -4074.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), -8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, -3298.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), -5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, -2134.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), -2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, -970.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), -7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, -2716.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, -2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-22', 120), 9.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, 3492.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-20', 120), 8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 3104.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-03', 120), -4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, -1552.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), -6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, -2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-17', 120), 5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 2134.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), 6.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-15', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, 388.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-11', 120), 10.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 4074.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-10', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3298.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2134.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-05', 120), 2.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 970.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-04', 120), 7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 2716.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 1552.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-02-18', 120), 0.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-18', 120), 388.00, 194.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-02-17', 120), 2.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-17', 120), 388.00, 776.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2134.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-05', 120), 2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 970.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-04', 120), 7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 2716.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 1552.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-29', 120), 8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 3298.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-28', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-24', 120), 3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, 1358.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-23', 120), 7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, 2716.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-30', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-30', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-20', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-17', 120), 5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 2134.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-15', 120), 1.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, 388.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-11', 120), 10.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 4074.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-10', 120), 8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3298.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-04', 120), -7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, -2716.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-05', 120), -2.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, -970.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-06', 120), -5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, -2134.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), -7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-10', 120), -8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, -3298.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-11', 120), -10.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, -4074.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-12', 120), -8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, -3104.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-13', 120), -6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, -2328.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-15', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, -388.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), -6.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, -2522.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-17', 120), -5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, -2134.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-30', 120), 4.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-30', 120), 388.00, 1746.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-18', 120), -7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, -2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-19', 120), -4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, -1552.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-31', 120), 3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-31', 120), 388.00, 1358.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-27', 120), 9.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 3686.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-02', 120), 3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-02', 120), 388.00, 1358.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-23', 120), 1.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-23', 120), 388.00, 582.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2024-12-27', 120), 2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-27', 120), 388.00, 970.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-08', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-09', 120), 5.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 1940.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-10', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 2522.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 2910.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-14', 120), 7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 2716.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-15', 120), 10.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 3880.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-16', 120), 8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 3104.00, 23.28),
        (14529, 2001920365, 30, CONVERT(DATE, '2025-01-17', 120), 5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 2134.00, 23.28)
    ) AS source (personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 4/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-22', 120), -1.00, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-22', 120), 196.00, -196.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), -1.00, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, -196.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, 196.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-22', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 196.00, 196.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-02', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-02', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2025-01-03', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-03', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-20', 120), 7.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-19', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-17', 120), 7.50, CONVERT(DATE, '2024-12-17', 120), CONVERT(DATE, '2024-12-17', 120), 196.00, 1470.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 3.00, CONVERT(DATE, '2024-12-16', 120), CONVERT(DATE, '2024-12-16', 120), 196.00, 588.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-12', 120), 6.00, CONVERT(DATE, '2024-12-12', 120), CONVERT(DATE, '2024-12-12', 120), 196.00, 1176.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 196.00, 1176.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, 1176.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), -5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, -980.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2024-12-09', 120), CONVERT(DATE, '2024-12-06', 120), 196.00, 1078.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 5.00, CONVERT(DATE, '2024-12-09', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, 980.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), -3.00, CONVERT(DATE, '2024-12-09', 120), CONVERT(DATE, '2024-12-06', 120), 196.00, -588.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-11', 120), 6.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-11', 120), 196.00, 1176.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 3.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 196.00, 588.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-05', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 196.00, 686.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-04', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 196.00, 686.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-03', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 196.00, 686.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 196.00, 686.00, 11.76),
        (14530, 2002055111, 10, CONVERT(DATE, '2024-12-10', 120), 6.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-10', 120), 196.00, 1176.00, 11.76),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-17', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 210.00, 210.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 210.00, 210.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-15', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 210.00, 210.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-14', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 210.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-13', 120), 2.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-02', 120), 3.00, CONVERT(DATE, '2025-01-02', 120), CONVERT(DATE, '2025-01-02', 120), 210.00, 630.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-03', 120), 3.00, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 210.00, 630.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 2.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-16', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-12', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-11', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-24', 120), 3.00, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-24', 120), 210.00, 630.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 3.00, CONVERT(DATE, '2024-12-23', 120), CONVERT(DATE, '2024-12-23', 120), 210.00, 630.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 420.00, 12.60),
        (14531, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 420.00, 12.60),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-24', 120), 7.50, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-24', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-09', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-10', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-13', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-14', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-15', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-16', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 7.50, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-23', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-20', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 196.00, 980.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-02', 120), 4.00, CONVERT(DATE, '2025-01-02', 120), CONVERT(DATE, '2025-01-02', 120), 196.00, 784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-03', 120), 4.00, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 196.00, 784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), 4.00, CONVERT(DATE, '2025-01-09', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 4.00, CONVERT(DATE, '2025-01-09', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), 4.00, CONVERT(DATE, '2025-01-09', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), -4.00, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, -784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), -4.00, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, -784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), -4.00, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, -784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 3.00, CONVERT(DATE, '2024-12-03', 120), CONVERT(DATE, '2024-12-02', 120), 196.00, 588.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-03', 120), 3.00, CONVERT(DATE, '2024-12-03', 120), CONVERT(DATE, '2024-12-03', 120), 196.00, 588.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-10', 120), 5.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-10', 120), 196.00, 980.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-11', 120), 5.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-11', 120), 196.00, 980.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 196.00, 1568.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-13', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 196.00, 1568.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 5.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-16', 120), 196.00, 980.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 1470.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), 5.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 196.00, 980.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 4.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 196.00, 784.00, 11.76),
        (14532, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), 5.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 196.00, 980.00, 11.76),
        (14533, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 288.00, 2160.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-16', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-03', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-06', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-10', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-11', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-13', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 288.00, -288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 288.00, -288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 288.00, -288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 288.00, -288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 4.00, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 288.00, 1152.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-24', 120), 4.00, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-24', 120), 288.00, 1152.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 288.00, 288.00, 17.28),
        (14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 288.00, 288.00, 17.28),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-21', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-10', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-09', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-08', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-07', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-06', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-13', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-14', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-15', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-16', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-22', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-23', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-24', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-17', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 478.00, 478.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 478.00, 478.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-19', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2025-01-20', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 478.00, 2868.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-12', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-11', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 478.00, 956.00, 28.68),
        (14534, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 478.00, 956.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 478.00, 956.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 478.00, 956.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 478.00, 956.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 478.00, 478.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 478.00, 956.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 478.00, 956.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 478.00, 956.00, 28.68),
        (14534, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 478.00, 956.00, 28.68),
        (14534, 3000512342, 10, CONVERT(DATE, '2025-03-06', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-06', 120), 478.00, 956.00, 28.68),
        (14534, 3000512342, 10, CONVERT(DATE, '2025-03-13', 120), 2.00, CONVERT(DATE, '2025-03-13', 120), CONVERT(DATE, '2025-03-13', 120), 478.00, 956.00, 28.68),
        (14534, 3000512342, 10, CONVERT(DATE, '2025-03-12', 120), 1.00, CONVERT(DATE, '2025-03-13', 120), CONVERT(DATE, '2025-03-12', 120), 478.00, 478.00, 28.68),
        (14534, 3000512342, 10, CONVERT(DATE, '2025-03-05', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-05', 120), 478.00, 956.00, 28.68),
        (14534, 3000512342, 10, CONVERT(DATE, '2025-03-03', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-03', 120), 478.00, 956.00, 28.68),
        (14534, 3000512342, 10, CONVERT(DATE, '2025-03-04', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-04', 120), 478.00, 956.00, 28.68),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 478.00, 239.00, 28.68),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-12', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 478.00, 239.00, 28.68),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-10', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 478.00, 478.00, 28.68),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 478.00, 478.00, 28.68),
        (14534, 2002040046, 10, CONVERT(DATE, '2024-12-06', 120), 0.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 478.00, 239.00, 28.68),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 4.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 945.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), -5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, -1050.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 1050.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 1050.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 1050.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 5.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 1155.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 840.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 945.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 945.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 945.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 210.00, 945.00, 12.60),
        (14535, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 6.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 1365.00, 12.60),
        (14535, 2002040046, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 420.00, 12.60),
        (14535, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 420.00, 12.60),
        (14535, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 420.00, 12.60),
        (14535, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 420.00, 12.60),
        (14535, 2002040046, 10, CONVERT(DATE, '2025-01-10', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 420.00, 12.60),
        (14535, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 105.00, 12.60),
        (14535, 2002040046, 10, CONVERT(DATE, '2024-12-06', 120), 0.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 105.00, 12.60),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-19', 120), 3.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 148.00, 444.00, 8.88),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-18', 120), 4.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 148.00, 666.00, 8.88),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-20', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 148.00, 592.00, 8.88),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-17', 120), 2.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 148.00, 370.00, 8.88),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-13', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 148.00, 148.00, 8.88),
        (14536, 2001920365, 40, CONVERT(DATE, '2024-12-12', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 148.00, 74.00, 8.88)
    ) AS source (personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 5/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 8.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-11', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-10', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 8.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-09', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-17', 120), 5.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 148.00, 740.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 8.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-03', 120), 148.00, 1258.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 3.00, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-02', 120), 148.00, 444.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 5.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-02', 120), 148.00, 814.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 148.00, 592.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-20', 120), 3.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 148.00, 518.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 148.00, 592.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), -8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 148.00, -1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), -8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 148.00, -1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), -8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 148.00, -1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 3.00, CONVERT(DATE, '2024-12-17', 120), CONVERT(DATE, '2024-12-16', 120), 148.00, 444.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-18', 120), 3.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 148.00, 444.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-19', 120), 4.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 148.00, 666.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 8.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 8.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 148.00, 1184.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 5.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-04', 120), 148.00, 814.00, 8.88),
        (14536, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 2.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-04', 120), 148.00, 370.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-30', 120), 7.50, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-29', 120), 7.50, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-29', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-28', 120), 7.50, CONVERT(DATE, '2025-01-28', 120), CONVERT(DATE, '2025-01-28', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-01-28', 120), CONVERT(DATE, '2025-01-27', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-22', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-20', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 148.00, 1110.00, 8.88),
        (14536, 2002040046, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 148.00, 1110.00, 8.88),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 1552.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 1552.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 1552.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 1552.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 1552.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 776.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 776.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 776.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 776.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 776.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 776.00, 23.28),
        (14537, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 3.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 1164.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, -970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, -970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 2910.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-28', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-27', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-20', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-22', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-23', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-24', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, -970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, -970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, -970.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-31', 120), 1.00, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-30', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2025-01-29', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 388.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-20', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-18', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-17', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 776.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-12', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 776.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-11', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 776.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 776.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 776.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-05', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-04', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 1552.00, 23.28),
        (14537, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 4.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 1552.00, 23.28)
    ) AS source (personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    SET IDENTITY_INSERT [dbo].[timesheets] OFF;
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for timesheets';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into timesheets: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- MERGE/INSERT statements for vacations table
PRINT 'Upserting data into vacations table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[vacations] AS target
    USING (
        VALUES
        (14526, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-17', 120)),
        (14532, CONVERT(DATE, '2025-07-01', 120), CONVERT(DATE, '2025-07-15', 120)),
        (14523, CONVERT(DATE, '2025-08-03', 120), CONVERT(DATE, '2025-08-17', 120)),
        (14530, CONVERT(DATE, '2025-10-20', 120), CONVERT(DATE, '2025-10-27', 120)),
        (14535, CONVERT(DATE, '2025-12-22', 120), CONVERT(DATE, '2025-12-31', 120))
    ) AS source (personnel_no, start_date, end_date)
    ON target.[personnel_no] = source.[personnel_no] AND target.[start_date] = source.[start_date]
    WHEN MATCHED THEN
        UPDATE SET target.[end_date] = source.[end_date]
    WHEN NOT MATCHED THEN
        INSERT ([personnel_no], [start_date], [end_date])
        VALUES (source.[personnel_no], source.[start_date], source.[end_date]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for vacations';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into vacations: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- Turn count of rows affected back on
SET NOCOUNT OFF;
GO

PRINT 'Data upsert operations completed successfully.';
GO
