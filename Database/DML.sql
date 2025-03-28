-- T-SQL DML MERGE statements (upsert) generated from transformed CSV files
-- Generation timestamp: 2025-03-27 23:09:01

-- Use the database created by the DDL script
USE [KPMG_Data_Challenge];
GO

-- Turn off count of rows affected to improve performance
SET NOCOUNT ON;
GO

-- Starting data upsert operations with MERGE statements
PRINT 'Starting data upsert operations...';
GO

-- MERGE statements for practices table
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

-- MERGE statements for clients table
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

-- MERGE statements for employees table
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

-- MERGE statements for engagements table
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

-- MERGE statements for phases table
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

-- MERGE statements for dictionary table
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

-- MERGE statements for staffing table
PRINT 'Upserting data into staffing table...';
BEGIN TRY
    BEGIN TRANSACTION;
    SET IDENTITY_INSERT [dbo].[staffing] ON;
    -- Batch 1/1
    MERGE [dbo].[staffing] AS target
    USING (
        VALUES
        (1, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 10.00),
        (2, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 10.00),
        (3, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 10.00),
        (4, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 10.00),
        (5, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 10.00),
        (6, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (7, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (8, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (9, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (10, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (11, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 16.00),
        (12, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 16.00),
        (13, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 16.00),
        (14, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 16.00),
        (15, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (16, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (17, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (18, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (19, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (20, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (21, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (22, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (23, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (24, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (25, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (26, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (27, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (28, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (29, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (30, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-02', 120), 24.00),
        (31, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 24.00),
        (32, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 24.00),
        (33, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-23', 120), 24.00),
        (34, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-30', 120), 24.00),
        (35, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 10.00),
        (36, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 10.00),
        (37, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-23', 120), 10.00),
        (38, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-30', 120), 10.00),
        (39, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-02', 120), 4.00),
        (40, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 4.00),
        (41, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 4.00),
        (42, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-23', 120), 4.00),
        (43, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-30', 120), 4.00),
        (44, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 4.00),
        (45, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 4.00),
        (46, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 4.00),
        (47, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 4.00),
        (48, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (49, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (50, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (51, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (52, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (53, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (54, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (55, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (56, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (57, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (58, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 4.00),
        (59, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 4.00),
        (60, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 4.00),
        (61, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 4.00),
        (62, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-30', 120), 4.00),
        (63, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-02', 120), 30.00),
        (64, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 30.00),
        (65, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 30.00),
        (66, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 30.00),
        (67, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-30', 120), 30.00),
        (68, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 10.00),
        (69, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 10.00),
        (70, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 10.00),
        (71, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-30', 120), 10.00),
        (72, 14527, 3000512342, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (73, 14527, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (74, 14527, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (75, 14527, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (76, 14527, 3000512342, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (77, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 12.00),
        (78, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 12.00),
        (79, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 12.00),
        (80, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 12.00),
        (81, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 12.00),
        (82, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (83, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (84, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (85, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (86, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (87, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 36.00),
        (88, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 36.00),
        (89, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 36.00),
        (90, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 36.00),
        (91, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 36.00),
        (92, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 16.00),
        (93, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 16.00),
        (94, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 16.00),
        (95, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-23', 120), 16.00),
        (96, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-30', 120), 16.00),
        (97, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (98, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (99, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (100, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (101, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (102, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 40.00),
        (103, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 40.00),
        (104, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 40.00),
        (105, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 40.00),
        (106, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-30', 120), 40.00),
        (107, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 24.00),
        (108, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 24.00),
        (109, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 24.00),
        (110, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 24.00),
        (111, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-30', 120), 24.00)
    ) AS source (id, personnel_no, eng_no, eng_phase, week_start_date, planned_hours)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[week_start_date] = source.[week_start_date], target.[planned_hours] = source.[planned_hours]
    WHEN NOT MATCHED THEN
        INSERT ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours])
        VALUES (source.[id], source.[personnel_no], source.[eng_no], source.[eng_phase], source.[week_start_date], source.[planned_hours]);
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

-- MERGE statements for timesheets table
PRINT 'Upserting data into timesheets table...';
BEGIN TRY
    BEGIN TRANSACTION;
    SET IDENTITY_INSERT [dbo].[timesheets] ON;
    -- Batch 1/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (1, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 210.00, 12.60),
        (2, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 2.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 525.00, 12.60),
        (3, 14523, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 4.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 840.00, 12.60),
        (4, 14523, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 420.00, 12.60),
        (5, 14523, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 2.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 420.00, 12.60),
        (6, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), -4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, -840.00, 12.60),
        (7, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), -1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, -210.00, 12.60),
        (8, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), -1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, -210.00, 12.60),
        (9, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), -2.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, -525.00, 12.60),
        (10, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 105.00, 12.60),
        (11, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 3.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 735.00, 12.60),
        (12, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 840.00, 12.60),
        (13, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 3.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 630.00, 12.60),
        (14, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, 210.00, 12.60),
        (15, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 210.00, 210.00, 12.60),
        (16, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, 210.00, 12.60),
        (17, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 8.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 1680.00, 12.60),
        (18, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 8.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 1680.00, 12.60),
        (19, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 4.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 840.00, 12.60),
        (20, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 840.00, 12.60),
        (21, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 210.00, 12.60),
        (22, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 4.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 210.00, 945.00, 12.60),
        (23, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-17', 120), 2.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-17', 120), 210.00, 420.00, 12.60),
        (24, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 2.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-18', 120), 210.00, 525.00, 12.60),
        (25, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-19', 120), 2.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-19', 120), 210.00, 420.00, 12.60),
        (26, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-10', 120), 1.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 210.00, 12.60),
        (27, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-20', 120), 2.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-20', 120), 210.00, 525.00, 12.60),
        (28, 14523, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), -4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, -840.00, 12.60),
        (29, 14523, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 1.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 210.00, 315.00, 12.60),
        (30, 14523, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 3.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 735.00, 12.60),
        (31, 14523, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 1.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 315.00, 12.60),
        (32, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-11', 120), 1.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 210.00, 12.60),
        (33, 14523, 2001920365, 10, CONVERT(DATE, '2025-02-14', 120), 0.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 105.00, 12.60),
        (34, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 4.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-16', 120), 210.00, 840.00, 12.60),
        (35, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-17', 120), 7.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 210.00, 1470.00, 12.60),
        (36, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, 1575.00, 12.60),
        (37, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), -7.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, -1575.00, 12.60),
        (38, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), 7.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, 1470.00, 12.60),
        (39, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), 5.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, 1050.00, 12.60),
        (40, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-06', 120), 8.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 1680.00, 12.60),
        (41, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-07', 120), 8.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 1680.00, 12.60),
        (42, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-11', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, -1260.00, 12.60),
        (43, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), -7.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, -1575.00, 12.60),
        (44, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 7.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, 1575.00, 12.60),
        (45, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 7.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, 1470.00, 12.60),
        (46, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 7.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 1470.00, 12.60),
        (47, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 7.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 1470.00, 12.60),
        (48, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, -1260.00, 12.60),
        (49, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, -1260.00, 12.60),
        (50, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-06', 120), -2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, -420.00, 12.60),
        (51, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-04', 120), -3.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, -630.00, 12.60),
        (52, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, 840.00, 12.60),
        (53, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-08', 120), 6.00, CONVERT(DATE, '2025-01-08', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 1260.00, 12.60),
        (54, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-06', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 1050.00, 12.60),
        (55, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-04', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 1050.00, 12.60),
        (56, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-12', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 1260.00, 12.60),
        (57, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-11', 120), 6.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 1365.00, 12.60),
        (58, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), 7.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 1470.00, 12.60),
        (59, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 7.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 1470.00, 12.60),
        (60, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, 1260.00, 12.60),
        (61, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, 1050.00, 12.60),
        (62, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), -5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 210.00, -1050.00, 12.60),
        (63, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), -4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 210.00, -840.00, 12.60),
        (64, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-12', 120), -6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, -1260.00, 12.60),
        (65, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), 6.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 1260.00, 12.60),
        (66, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-09', 120), 6.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 1260.00, 12.60),
        (67, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 420.00, 12.60),
        (68, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-05', 120), 4.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 840.00, 12.60),
        (69, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-04', 120), 3.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 630.00, 12.60),
        (70, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-17', 120), 6.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-17', 120), 210.00, 1260.00, 12.60),
        (71, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-20', 120), 4.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-20', 120), 210.00, 840.00, 12.60),
        (72, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, 1575.00, 12.60),
        (73, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), -7.00, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, -1470.00, 12.60),
        (74, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 7.00, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 1470.00, 12.60),
        (75, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 6.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, 1365.00, 12.60),
        (76, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-21', 120), 3.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 210.00, 630.00, 12.60),
        (77, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-19', 120), 7.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-19', 120), 210.00, 1470.00, 12.60),
        (78, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-18', 120), 5.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-18', 120), 210.00, 1050.00, 12.60),
        (79, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), 7.50, CONVERT(DATE, '2025-02-07', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, 1575.00, 12.60),
        (80, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, 1575.00, 12.60),
        (81, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, 1575.00, 12.60),
        (82, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, 1575.00, 12.60),
        (83, 14523, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, 1575.00, 12.60),
        (84, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), -7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, -1575.00, 12.60),
        (85, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-09', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 1260.00, 12.60),
        (86, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-11', 120), 6.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 1260.00, 12.60),
        (87, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-12', 120), 6.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 1260.00, 12.60),
        (88, 14523, 3000512342, 10, CONVERT(DATE, '2024-12-13', 120), 5.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 210.00, 1155.00, 12.60),
        (89, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-10', 120), 4.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 840.00, 12.60),
        (90, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 210.00, 1575.00, 12.60),
        (91, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-20', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 210.00, 1260.00, 12.60),
        (92, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 8.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, 1680.00, 12.60),
        (93, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-27', 120), 210.00, 1575.00, 12.60),
        (94, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), 8.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, 1680.00, 12.60),
        (95, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 8.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, 1680.00, 12.60),
        (96, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, 1575.00, 12.60),
        (97, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 8.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, 1680.00, 12.60),
        (98, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 210.00, 1575.00, 12.60),
        (99, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, 1575.00, 12.60),
        (100, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-22', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 210.00, 1575.00, 12.60),
        (101, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-14', 120), 3.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 735.00, 12.60),
        (102, 14523, 3000512342, 10, CONVERT(DATE, '2025-01-13', 120), 4.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 840.00, 12.60),
        (103, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-30', 120), 7.50, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 196.00, 1470.00, 11.76),
        (104, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-14', 120), CONVERT(DATE, '2025-01-13', 120), 196.00, 1470.00, 11.76),
        (105, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 196.00, 1470.00, 11.76),
        (106, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 196.00, 1470.00, 11.76),
        (107, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 1470.00, 11.76),
        (108, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 1470.00, 11.76),
        (109, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 1470.00, 11.76),
        (110, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-03', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 196.00, 1470.00, 11.76),
        (111, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-02', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-02', 120), 196.00, 1470.00, 11.76),
        (112, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 196.00, 1470.00, 11.76),
        (113, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-24', 120), 7.50, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-24', 120), 196.00, 1470.00, 11.76),
        (114, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 7.50, CONVERT(DATE, '2024-12-23', 120), CONVERT(DATE, '2024-12-23', 120), 196.00, 1470.00, 11.76),
        (115, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 196.00, 1470.00, 11.76),
        (116, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 196.00, 1470.00, 11.76),
        (117, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 196.00, 1470.00, 11.76),
        (118, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, 1470.00, 11.76),
        (119, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 196.00, 1470.00, 11.76),
        (120, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 196.00, 1470.00, 11.76),
        (121, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 196.00, 1470.00, 11.76),
        (122, 14524, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 7.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 196.00, 1470.00, 11.76),
        (123, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 7.50, CONVERT(DATE, '2025-01-28', 120), CONVERT(DATE, '2025-01-28', 120), 196.00, 1470.00, 11.76),
        (124, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 7.50, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-29', 120), 196.00, 1470.00, 11.76),
        (125, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-14', 120), CONVERT(DATE, '2025-01-14', 120), 196.00, 1470.00, 11.76),
        (126, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-19', 120), 7.50, CONVERT(DATE, '2025-02-19', 120), CONVERT(DATE, '2025-02-19', 120), 196.00, 1470.00, 11.76),
        (127, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-20', 120), 7.50, CONVERT(DATE, '2025-02-20', 120), CONVERT(DATE, '2025-02-20', 120), 196.00, 1470.00, 11.76),
        (128, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 7.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 196.00, 1470.00, 11.76),
        (129, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-10', 120), 7.50, CONVERT(DATE, '2025-02-11', 120), CONVERT(DATE, '2025-02-10', 120), 196.00, 1470.00, 11.76),
        (130, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-11', 120), 7.50, CONVERT(DATE, '2025-02-11', 120), CONVERT(DATE, '2025-02-11', 120), 196.00, 1470.00, 11.76),
        (131, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-12', 120), 7.50, CONVERT(DATE, '2025-02-12', 120), CONVERT(DATE, '2025-02-12', 120), 196.00, 1470.00, 11.76),
        (132, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-13', 120), 7.50, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-13', 120), 196.00, 1470.00, 11.76),
        (133, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-03', 120), 7.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-03-03', 120), 196.00, 1470.00, 11.76),
        (134, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-04', 120), 7.50, CONVERT(DATE, '2025-03-04', 120), CONVERT(DATE, '2025-03-04', 120), 196.00, 1470.00, 11.76),
        (135, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-05', 120), 7.50, CONVERT(DATE, '2025-03-05', 120), CONVERT(DATE, '2025-03-05', 120), 196.00, 1470.00, 11.76),
        (136, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-06', 120), 7.50, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-06', 120), 196.00, 1470.00, 11.76),
        (137, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-07', 120), 7.50, CONVERT(DATE, '2025-02-07', 120), CONVERT(DATE, '2025-02-07', 120), 196.00, 1470.00, 11.76),
        (138, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-06', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-06', 120), 196.00, 1470.00, 11.76),
        (139, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-05', 120), 196.00, 1470.00, 11.76),
        (140, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-04', 120), 196.00, 1470.00, 11.76),
        (141, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-03', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-03', 120), 196.00, 1470.00, 11.76),
        (142, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-17', 120), 7.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-17', 120), 196.00, 1470.00, 11.76),
        (143, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 7.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-18', 120), 196.00, 1470.00, 11.76),
        (144, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-10', 120), 7.50, CONVERT(DATE, '2025-03-11', 120), CONVERT(DATE, '2025-03-10', 120), 196.00, 1470.00, 11.76),
        (145, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-25', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-25', 120), 196.00, 1470.00, 11.76),
        (146, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-20', 120), 196.00, 1470.00, 11.76),
        (147, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, 1470.00, 11.76),
        (148, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-22', 120), 196.00, 1470.00, 11.76),
        (149, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-23', 120), CONVERT(DATE, '2025-01-23', 120), 196.00, 1470.00, 11.76),
        (150, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 196.00, 1470.00, 11.76),
        (151, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-27', 120), 196.00, 1470.00, 11.76),
        (152, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 196.00, 1470.00, 11.76),
        (153, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-16', 120), 196.00, 1470.00, 11.76),
        (154, 14524, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-15', 120), 196.00, 1470.00, 11.76),
        (155, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-26', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-26', 120), 196.00, 1470.00, 11.76),
        (156, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-11', 120), 7.50, CONVERT(DATE, '2025-03-11', 120), CONVERT(DATE, '2025-03-11', 120), 196.00, 1470.00, 11.76),
        (157, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-12', 120), 7.50, CONVERT(DATE, '2025-03-12', 120), CONVERT(DATE, '2025-03-12', 120), 196.00, 1470.00, 11.76),
        (158, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-13', 120), 7.50, CONVERT(DATE, '2025-03-13', 120), CONVERT(DATE, '2025-03-13', 120), 196.00, 1470.00, 11.76),
        (159, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-14', 120), 7.50, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-14', 120), 196.00, 1470.00, 11.76),
        (160, 14524, 2001920365, 10, CONVERT(DATE, '2025-03-07', 120), 7.50, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-07', 120), 196.00, 1470.00, 11.76),
        (161, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-24', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-24', 120), 196.00, 1470.00, 11.76),
        (162, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-14', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 196.00, 1470.00, 11.76),
        (163, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-27', 120), 7.50, CONVERT(DATE, '2025-02-27', 120), CONVERT(DATE, '2025-02-27', 120), 196.00, 1470.00, 11.76),
        (164, 14524, 2001920365, 10, CONVERT(DATE, '2025-02-28', 120), 7.50, CONVERT(DATE, '2025-02-28', 120), CONVERT(DATE, '2025-02-28', 120), 196.00, 1470.00, 11.76),
        (165, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-03', 120), 274.00, 137.00, 16.44),
        (166, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 548.00, 16.44),
        (167, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (168, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-06', 120), 274.00, 548.00, 16.44),
        (169, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 137.00, 16.44),
        (170, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 2.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 256.00, 512.00, 15.36),
        (171, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 256.00, 256.00, 15.36),
        (172, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 256.00, 256.00, 15.36),
        (173, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 0.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 274.00, 137.00, 16.44),
        (174, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 274.00, 274.00, 16.44),
        (175, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 548.00, 16.44),
        (176, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), 1.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 274.00, 411.00, 16.44),
        (177, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 274.00, 274.00, 16.44),
        (178, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 274.00, 274.00, 16.44),
        (179, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 274.00, 137.00, 16.44),
        (180, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 274.00, 137.00, 16.44),
        (181, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 274.00, 548.00, 16.44),
        (182, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (183, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 548.00, 16.44),
        (184, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 274.00, 137.00, 16.44),
        (185, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 274.00, 137.00, 16.44),
        (186, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-14', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-14', 120), 256.00, 256.00, 15.36),
        (187, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-06', 120), 1.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-06', 120), 256.00, 256.00, 15.36),
        (188, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 0.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-21', 120), 256.00, 128.00, 15.36),
        (189, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 0.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-18', 120), 256.00, 128.00, 15.36),
        (190, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-24', 120), 1.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-24', 120), 256.00, 256.00, 15.36),
        (191, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-27', 120), 1.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 256.00, 384.00, 15.36),
        (192, 14525, 2001920365, 10, CONVERT(DATE, '2025-03-04', 120), 1.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-04', 120), 256.00, 256.00, 15.36),
        (193, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 1.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-28', 120), 256.00, 256.00, 15.36),
        (194, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-31', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-31', 120), 256.00, 128.00, 15.36),
        (195, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-29', 120), 256.00, 128.00, 15.36),
        (196, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-12', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-12', 120), 256.00, 256.00, 15.36),
        (197, 14525, 2001920365, 10, CONVERT(DATE, '2025-02-13', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-13', 120), 256.00, 256.00, 15.36),
        (198, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-08', 120), 256.00, 256.00, 15.36),
        (199, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 256.00, 512.00, 15.36),
        (200, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 1.50, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-15', 120), 256.00, 384.00, 15.36)
    ) AS source (id, personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([id], [personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[id], source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 2/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (201, 14525, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 256.00, 512.00, 15.36),
        (202, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), -0.50, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-02', 120), 274.00, -137.00, 16.44),
        (203, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), -0.50, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-03', 120), 274.00, -137.00, 16.44),
        (204, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), -2.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, -548.00, 16.44),
        (205, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), -1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, -274.00, 16.44),
        (206, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), -2.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-06', 120), 274.00, -548.00, 16.44),
        (207, 14525, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-02', 120), 274.00, 137.00, 16.44),
        (208, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 274.00, 16.44),
        (209, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (210, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 274.00, 274.00, 16.44),
        (211, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 274.00, 16.44),
        (212, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 274.00, 548.00, 16.44),
        (213, 14525, 2001920365, 40, CONVERT(DATE, '2025-01-15', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-15', 120), 256.00, 256.00, 15.36),
        (214, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), -1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, -274.00, 16.44),
        (215, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), -1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, -274.00, 16.44),
        (216, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 274.00, 274.00, 16.44),
        (217, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 274.00, 16.44),
        (218, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 274.00, 137.00, 16.44),
        (219, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-11', 120), 1.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 274.00, 411.00, 16.44),
        (220, 14525, 2001920365, 40, CONVERT(DATE, '2024-12-13', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 137.00, 16.44),
        (221, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-23', 120), 0.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 274.00, 137.00, 16.44),
        (222, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 7.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-06', 120), 256.00, 1792.00, 15.36),
        (223, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 1.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-05', 120), 256.00, 256.00, 15.36),
        (224, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-13', 120), 1.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 411.00, 16.44),
        (225, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-10', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 274.00, 274.00, 16.44),
        (226, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 274.00, 274.00, 16.44),
        (227, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 274.00, 274.00, 16.44),
        (228, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-18', 120), 3.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 822.00, 16.44),
        (229, 14525, 3000512342, 10, CONVERT(DATE, '2024-12-16', 120), 1.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-16', 120), 274.00, 411.00, 16.44),
        (230, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-21', 120), 1.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-21', 120), 256.00, 384.00, 15.36),
        (231, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-17', 120), 2.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-17', 120), 256.00, 512.00, 15.36),
        (232, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 2.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-14', 120), 256.00, 512.00, 15.36),
        (233, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 2.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-13', 120), 256.00, 512.00, 15.36),
        (234, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 0.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-12', 120), 256.00, 128.00, 15.36),
        (235, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 1.50, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-11', 120), 256.00, 384.00, 15.36),
        (236, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 1.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-10', 120), 256.00, 256.00, 15.36),
        (237, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-31', 120), 256.00, 128.00, 15.36),
        (238, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 1.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-30', 120), 256.00, 384.00, 15.36),
        (239, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 1.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-29', 120), 256.00, 384.00, 15.36),
        (240, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-27', 120), 0.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-27', 120), 256.00, 128.00, 15.36),
        (241, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-20', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 256.00, 128.00, 15.36),
        (242, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-21', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 256.00, 256.00, 15.36),
        (243, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-22', 120), 1.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 256.00, 384.00, 15.36),
        (244, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-23', 120), 256.00, 256.00, 15.36),
        (245, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 1.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 256.00, 256.00, 15.36),
        (246, 14525, 3000512342, 10, CONVERT(DATE, '2025-03-04', 120), 0.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-04', 120), 256.00, 128.00, 15.36),
        (247, 14525, 3000512342, 10, CONVERT(DATE, '2025-03-03', 120), 0.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-03', 120), 256.00, 128.00, 15.36),
        (248, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-26', 120), 1.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-26', 120), 256.00, 256.00, 15.36),
        (249, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-27', 120), 1.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 256.00, 256.00, 15.36),
        (250, 14525, 3000512342, 10, CONVERT(DATE, '2025-02-28', 120), 0.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-28', 120), 256.00, 128.00, 15.36),
        (251, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-08', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-08', 120), 256.00, 256.00, 15.36),
        (252, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-09', 120), 256.00, 512.00, 15.36),
        (253, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-10', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-10', 120), 256.00, 256.00, 15.36),
        (254, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-14', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 256.00, 256.00, 15.36),
        (255, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-16', 120), 256.00, 256.00, 15.36),
        (256, 14525, 3000512342, 10, CONVERT(DATE, '2025-01-17', 120), 2.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 256.00, 512.00, 15.36),
        (257, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), 0.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 137.00, 16.44),
        (258, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 274.00, 548.00, 16.44),
        (259, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-13', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 274.00, 137.00, 16.44),
        (260, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 274.00, 137.00, 16.44),
        (261, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, 137.00, 16.44),
        (262, 14525, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 3.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-07', 120), 256.00, 768.00, 15.36),
        (263, 14525, 2002040046, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-16', 120), 256.00, 256.00, 15.36),
        (264, 14525, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), -0.50, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2024-12-04', 120), 274.00, -137.00, 16.44),
        (265, 14525, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 3.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-08', 120), 256.00, 768.00, 15.36),
        (266, 14525, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-09', 120), 256.00, 512.00, 15.36),
        (267, 14525, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-10', 120), 256.00, 256.00, 15.36),
        (268, 14525, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-22', 120), CONVERT(DATE, '2025-01-16', 120), 256.00, 256.00, 15.36),
        (269, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 1940.00, 23.28),
        (270, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 1940.00, 23.28),
        (271, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 1940.00, 23.28),
        (272, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 1940.00, 23.28),
        (273, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 1940.00, 23.28),
        (274, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 1940.00, 23.28),
        (275, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 1940.00, 23.28),
        (276, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 1940.00, 23.28),
        (277, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 1940.00, 23.28),
        (278, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 5.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 1940.00, 23.28),
        (279, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 15.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 5820.00, 23.28),
        (280, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 15.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 5820.00, 23.28),
        (281, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 3104.00, 23.28),
        (282, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 3104.00, 23.28),
        (283, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 3104.00, 23.28),
        (284, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 3104.00, 23.28),
        (285, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2910.00, 23.28),
        (286, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), 5.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 1940.00, 23.28),
        (287, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (288, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 3104.00, 23.28),
        (289, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3104.00, 23.28),
        (290, 14526, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 3104.00, 23.28),
        (291, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-13', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-13', 120), 388.00, 1552.00, 23.28),
        (292, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-12', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-12', 120), 388.00, 1552.00, 23.28),
        (293, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-11', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-11', 120), 388.00, 1552.00, 23.28),
        (294, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-10', 120), 4.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-10', 120), 388.00, 1552.00, 23.28),
        (295, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-18', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-18', 120), 388.00, 1164.00, 23.28),
        (296, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-19', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-19', 120), 388.00, 1164.00, 23.28),
        (297, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-20', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-20', 120), 388.00, 1164.00, 23.28),
        (298, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-21', 120), 3.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-21', 120), 388.00, 1164.00, 23.28),
        (299, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-24', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-24', 120), 388.00, 776.00, 23.28),
        (300, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-25', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-25', 120), 388.00, 776.00, 23.28),
        (301, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-26', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-26', 120), 388.00, 776.00, 23.28),
        (302, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-27', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 388.00, 776.00, 23.28),
        (303, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-28', 120), 2.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-28', 120), 388.00, 776.00, 23.28),
        (304, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-31', 120), 4.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-31', 120), 388.00, 1552.00, 23.28),
        (305, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-30', 120), 6.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-30', 120), 388.00, 2328.00, 23.28),
        (306, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 4.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 1552.00, 23.28),
        (307, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 4.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 1552.00, 23.28),
        (308, 14526, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), 5.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 1940.00, 23.28),
        (309, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-03', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-03', 120), 388.00, 2328.00, 23.28),
        (310, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-04', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-04', 120), 388.00, 2328.00, 23.28),
        (311, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-05', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-05', 120), 388.00, 2328.00, 23.28),
        (312, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-06', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-06', 120), 388.00, 2328.00, 23.28),
        (313, 14526, 2001920365, 10, CONVERT(DATE, '2025-02-07', 120), 6.00, CONVERT(DATE, '2025-02-13', 120), CONVERT(DATE, '2025-02-07', 120), 388.00, 2328.00, 23.28),
        (314, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-02', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-02', 120), 210.00, 1575.00, 12.60),
        (315, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-03', 120), 7.50, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 210.00, 1575.00, 12.60),
        (316, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, -1575.00, 12.60),
        (317, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, -1575.00, 12.60),
        (318, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-28', 120), 7.50, CONVERT(DATE, '2025-02-28', 120), CONVERT(DATE, '2025-02-28', 120), 210.00, 1575.00, 12.60),
        (319, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-27', 120), 7.50, CONVERT(DATE, '2025-02-27', 120), CONVERT(DATE, '2025-02-27', 120), 210.00, 1575.00, 12.60),
        (320, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-26', 120), 6.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-26', 120), 210.00, 1365.00, 12.60),
        (321, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-25', 120), 7.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-25', 120), 210.00, 1575.00, 12.60),
        (322, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 6.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 1365.00, 12.60),
        (323, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 8.00, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 1680.00, 12.60),
        (324, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-24', 120), 9.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-24', 120), 210.00, 1995.00, 12.60),
        (325, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), -4.50, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, -945.00, 12.60),
        (326, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), -10.00, CONVERT(DATE, '2025-02-26', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, -2100.00, 12.60),
        (327, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-21', 120), 7.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-21', 120), 210.00, 1470.00, 12.60),
        (328, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-20', 120), 6.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-20', 120), 210.00, 1365.00, 12.60),
        (329, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-19', 120), 7.00, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-19', 120), 210.00, 1470.00, 12.60),
        (330, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-18', 120), 9.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-18', 120), 210.00, 1995.00, 12.60),
        (331, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 4.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 945.00, 12.60),
        (332, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 9.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 1995.00, 12.60),
        (333, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 10.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 2100.00, 12.60),
        (334, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), 5.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, 1050.00, 12.60),
        (335, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 6.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, 1365.00, 12.60),
        (336, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 8.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, 1680.00, 12.60),
        (337, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, 1575.00, 12.60),
        (338, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), 10.00, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, 2100.00, 12.60),
        (339, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, -1575.00, 12.60),
        (340, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, -1575.00, 12.60),
        (341, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, -1575.00, 12.60),
        (342, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, -1575.00, 12.60),
        (343, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, -1575.00, 12.60),
        (344, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, -1575.00, 12.60),
        (345, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, -1575.00, 12.60),
        (346, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), -7.50, CONVERT(DATE, '2025-02-15', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, -1575.00, 12.60),
        (347, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), -7.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, -1575.00, 12.60),
        (348, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), -2.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, -525.00, 12.60),
        (349, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), -7.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, -1575.00, 12.60),
        (350, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), -7.00, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, -1470.00, 12.60),
        (351, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 6.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, 1365.00, 12.60),
        (352, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), 6.00, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, 1260.00, 12.60),
        (353, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 2.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, 525.00, 12.60),
        (354, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 5.50, CONVERT(DATE, '2025-02-02', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, 1155.00, 12.60),
        (355, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-31', 120), 210.00, 1575.00, 12.60),
        (356, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-30', 120), 2.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-30', 120), 210.00, 525.00, 12.60),
        (357, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-29', 120), 7.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-29', 120), 210.00, 1575.00, 12.60),
        (358, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-28', 120), 7.00, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-28', 120), 210.00, 1470.00, 12.60),
        (359, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-02-01', 120), CONVERT(DATE, '2025-01-27', 120), 210.00, 1575.00, 12.60),
        (360, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-14', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-14', 120), 210.00, 1575.00, 12.60),
        (361, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-13', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-13', 120), 210.00, 1575.00, 12.60),
        (362, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-12', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-12', 120), 210.00, 1575.00, 12.60),
        (363, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-11', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-11', 120), 210.00, 1575.00, 12.60),
        (364, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-10', 120), 7.50, CONVERT(DATE, '2025-02-14', 120), CONVERT(DATE, '2025-02-10', 120), 210.00, 1575.00, 12.60),
        (365, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-17', 120), 11.50, CONVERT(DATE, '2025-02-21', 120), CONVERT(DATE, '2025-02-17', 120), 210.00, 2415.00, 12.60),
        (366, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-07', 120), 7.50, CONVERT(DATE, '2025-02-07', 120), CONVERT(DATE, '2025-02-07', 120), 210.00, 1575.00, 12.60),
        (367, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-06', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-06', 120), 210.00, 1575.00, 12.60),
        (368, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-05', 120), 210.00, 1575.00, 12.60),
        (369, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-04', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-04', 120), 210.00, 1575.00, 12.60),
        (370, 14527, 3000512342, 10, CONVERT(DATE, '2025-02-03', 120), 7.50, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-02-03', 120), 210.00, 1575.00, 12.60),
        (371, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-03', 120), 10.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-03', 120), 210.00, 2100.00, 12.60),
        (372, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-04', 120), 11.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-04', 120), 210.00, 2310.00, 12.60),
        (373, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-05', 120), 12.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-05', 120), 210.00, 2520.00, 12.60),
        (374, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-06', 120), 6.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-06', 120), 210.00, 1260.00, 12.60),
        (375, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-07', 120), 1.00, CONVERT(DATE, '2025-03-07', 120), CONVERT(DATE, '2025-03-07', 120), 210.00, 210.00, 12.60),
        (376, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-20', 120), 8.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 210.00, 1680.00, 12.60),
        (377, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-21', 120), 8.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 210.00, 1680.00, 12.60),
        (378, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-22', 120), 10.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 210.00, 2100.00, 12.60),
        (379, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 210.00, 1575.00, 12.60),
        (380, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 5.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 210.00, 1155.00, 12.60),
        (381, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-11', 120), 14.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-11', 120), 210.00, 2940.00, 12.60),
        (382, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-10', 120), 9.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-10', 120), 210.00, 1890.00, 12.60),
        (383, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-07', 120), -1.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-07', 120), 210.00, -210.00, 12.60),
        (384, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-07', 120), 8.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-07', 120), 210.00, 1680.00, 12.60),
        (385, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-12', 120), 12.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-12', 120), 210.00, 2520.00, 12.60),
        (386, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-13', 120), 9.00, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-13', 120), 210.00, 1890.00, 12.60),
        (387, 14527, 3000512342, 10, CONVERT(DATE, '2025-03-14', 120), 7.50, CONVERT(DATE, '2025-03-14', 120), CONVERT(DATE, '2025-03-14', 120), 210.00, 1575.00, 12.60),
        (388, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 1575.00, 12.60),
        (389, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 1575.00, 12.60),
        (390, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 1575.00, 12.60),
        (391, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 1575.00, 12.60),
        (392, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 1575.00, 12.60),
        (393, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 210.00, 1575.00, 12.60),
        (394, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-16', 120), 10.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 210.00, 2205.00, 12.60),
        (395, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-15', 120), 10.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 210.00, 2205.00, 12.60),
        (396, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-14', 120), 11.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 2415.00, 12.60),
        (397, 14527, 3000512342, 10, CONVERT(DATE, '2025-01-13', 120), 10.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 2100.00, 12.60),
        (398, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-28', 120), 7.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-28', 120), 318.00, 2226.00, 19.08),
        (399, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-24', 120), 7.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 318.00, 2226.00, 19.08),
        (400, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-23', 120), 8.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-23', 120), 318.00, 2544.00, 19.08)
    ) AS source (id, personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([id], [personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[id], source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 3/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (401, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-22', 120), 8.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 318.00, 2703.00, 19.08),
        (402, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-21', 120), 8.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 318.00, 2544.00, 19.08),
        (403, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-20', 120), 8.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 318.00, 2703.00, 19.08),
        (404, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-17', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 318.00, 2544.00, 19.08),
        (405, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-27', 120), 8.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-27', 120), 318.00, 2544.00, 19.08),
        (406, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-26', 120), 8.00, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-26', 120), 318.00, 2544.00, 19.08),
        (407, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-24', 120), 8.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-24', 120), 318.00, 2703.00, 19.08),
        (408, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-25', 120), 8.50, CONVERT(DATE, '2025-03-03', 120), CONVERT(DATE, '2025-02-25', 120), 318.00, 2703.00, 19.08),
        (409, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-13', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-13', 120), 318.00, 2544.00, 19.08),
        (410, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-14', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-14', 120), 318.00, 2544.00, 19.08),
        (411, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-17', 120), 9.00, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-17', 120), 318.00, 2862.00, 19.08),
        (412, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-18', 120), 8.50, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-18', 120), 318.00, 2703.00, 19.08),
        (413, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-19', 120), 8.50, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-19', 120), 318.00, 2703.00, 19.08),
        (414, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-20', 120), 8.50, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-20', 120), 318.00, 2703.00, 19.08),
        (415, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-21', 120), 5.00, CONVERT(DATE, '2025-02-25', 120), CONVERT(DATE, '2025-02-21', 120), 318.00, 1590.00, 19.08),
        (416, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-04', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 3104.00, 23.28),
        (417, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-05', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 3104.00, 23.28),
        (418, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-06', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2328.00, 23.28),
        (419, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-11', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 3298.00, 23.28),
        (420, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-12', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3298.00, 23.28),
        (421, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-13', 120), 6.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2522.00, 23.28),
        (422, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-02', 120), 9.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 3492.00, 23.28),
        (423, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-03', 120), 9.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 3492.00, 23.28),
        (424, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-09', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 3298.00, 23.28),
        (425, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3104.00, 23.28),
        (426, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-16', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 3298.00, 23.28),
        (427, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-17', 120), 9.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 3492.00, 23.28),
        (428, 14528, 2001920365, 20, CONVERT(DATE, '2024-12-18', 120), 7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2716.00, 23.28),
        (429, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-27', 120), 8.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-27', 120), 318.00, 2544.00, 19.08),
        (430, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-28', 120), 8.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-28', 120), 318.00, 2544.00, 19.08),
        (431, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-29', 120), 8.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-29', 120), 318.00, 2703.00, 19.08),
        (432, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-30', 120), 8.00, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-30', 120), 318.00, 2544.00, 19.08),
        (433, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-02-03', 120), CONVERT(DATE, '2025-01-31', 120), 318.00, 2385.00, 19.08),
        (434, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-03', 120), 8.50, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-03', 120), 318.00, 2703.00, 19.08),
        (435, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-04', 120), 8.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-04', 120), 318.00, 2544.00, 19.08),
        (436, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-12', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-12', 120), 318.00, 2544.00, 19.08),
        (437, 14528, 2001920365, 20, CONVERT(DATE, '2025-03-04', 120), 8.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-04', 120), 318.00, 2703.00, 19.08),
        (438, 14528, 2001920365, 20, CONVERT(DATE, '2025-03-03', 120), 8.50, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-03', 120), 318.00, 2703.00, 19.08),
        (439, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-13', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-13', 120), 318.00, 2544.00, 19.08),
        (440, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-14', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 318.00, 2544.00, 19.08),
        (441, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-15', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-15', 120), 318.00, 2544.00, 19.08),
        (442, 14528, 2001920365, 20, CONVERT(DATE, '2025-01-16', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-16', 120), 318.00, 2544.00, 19.08),
        (443, 14528, 2001920365, 20, CONVERT(DATE, '2025-03-05', 120), 8.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-05', 120), 318.00, 2544.00, 19.08),
        (444, 14528, 2001920365, 20, CONVERT(DATE, '2025-03-06', 120), 8.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-06', 120), 318.00, 2544.00, 19.08),
        (445, 14528, 2001920365, 20, CONVERT(DATE, '2025-03-07', 120), 7.00, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-07', 120), 318.00, 2226.00, 19.08),
        (446, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-05', 120), 7.50, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-05', 120), 318.00, 2385.00, 19.08),
        (447, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-06', 120), 8.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-06', 120), 318.00, 2544.00, 19.08),
        (448, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-07', 120), 8.00, CONVERT(DATE, '2025-02-10', 120), CONVERT(DATE, '2025-02-07', 120), 318.00, 2544.00, 19.08),
        (449, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-10', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-10', 120), 318.00, 2544.00, 19.08),
        (450, 14528, 2001920365, 20, CONVERT(DATE, '2025-02-11', 120), 8.00, CONVERT(DATE, '2025-02-18', 120), CONVERT(DATE, '2025-02-11', 120), 318.00, 2544.00, 19.08),
        (451, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), 8.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 3104.00, 23.28),
        (452, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 2910.00, 23.28),
        (453, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), 9.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, 3492.00, 23.28),
        (454, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-23', 120), 7.00, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, 2716.00, 23.28),
        (455, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), 3.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, 1358.00, 23.28),
        (456, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), 6.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 2522.00, 23.28),
        (457, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), 5.00, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 1940.00, 23.28),
        (458, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), 6.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 2522.00, 23.28),
        (459, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 2910.00, 23.28),
        (460, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 2910.00, 23.28),
        (461, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-02', 120), 3.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2025-01-02', 120), 388.00, 1358.00, 23.28),
        (462, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-31', 120), 3.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-31', 120), 388.00, 1358.00, 23.28),
        (463, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), 6.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-30', 120), 388.00, 2522.00, 23.28),
        (464, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-27', 120), 2.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-27', 120), 388.00, 970.00, 23.28),
        (465, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), 1.50, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 388.00, 582.00, 23.28),
        (466, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 2910.00, 23.28),
        (467, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), 7.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 2716.00, 23.28),
        (468, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), 10.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 3880.00, 23.28),
        (469, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), 9.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 3686.00, 23.28),
        (470, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), 6.00, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 2328.00, 23.28),
        (471, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), 8.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 3298.00, 23.28),
        (472, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, 2328.00, 23.28),
        (473, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (474, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2910.00, 23.28),
        (475, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), 5.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 2134.00, 23.28),
        (476, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), 6.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 2522.00, 23.28),
        (477, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-15', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, 388.00, 23.28),
        (478, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-27', 120), -2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-27', 120), 388.00, -970.00, 23.28),
        (479, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-30', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-30', 120), 388.00, -2522.00, 23.28),
        (480, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-31', 120), -3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-31', 120), 388.00, -1358.00, 23.28),
        (481, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-02', 120), -3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-02', 120), 388.00, -1358.00, 23.28),
        (482, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-06', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, -2910.00, 23.28),
        (483, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-07', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, -2910.00, 23.28),
        (484, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-08', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, -2522.00, 23.28),
        (485, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-09', 120), -5.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, -1940.00, 23.28),
        (486, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-10', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, -2522.00, 23.28),
        (487, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-13', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, -2910.00, 23.28),
        (488, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-14', 120), -7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, -2716.00, 23.28),
        (489, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-15', 120), -10.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, -3880.00, 23.28),
        (490, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), -8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, -3104.00, 23.28),
        (491, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), -5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, -2134.00, 23.28),
        (492, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-20', 120), -8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, -3104.00, 23.28),
        (493, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-21', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, -2910.00, 23.28),
        (494, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-22', 120), -9.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, -3492.00, 23.28),
        (495, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-23', 120), -7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, -2716.00, 23.28),
        (496, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-24', 120), -3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, -1358.00, 23.28),
        (497, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-27', 120), -9.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, -3686.00, 23.28),
        (498, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-28', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, -2328.00, 23.28),
        (499, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-29', 120), -8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, -3298.00, 23.28),
        (500, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-17', 120), 5.50, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 2134.00, 23.28),
        (501, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-23', 120), -1.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-23', 120), 388.00, -582.00, 23.28),
        (502, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 2328.00, 23.28),
        (503, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 2910.00, 23.28),
        (504, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), 7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 2716.00, 23.28),
        (505, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), 2.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 970.00, 23.28),
        (506, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2134.00, 23.28),
        (507, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 2910.00, 23.28),
        (508, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3298.00, 23.28),
        (509, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), 10.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 4074.00, 23.28),
        (510, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (511, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2328.00, 23.28),
        (512, 14529, 2001920365, 10, CONVERT(DATE, '2025-01-16', 120), 8.00, CONVERT(DATE, '2025-01-20', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 3104.00, 23.28),
        (513, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-20', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, -2328.00, 23.28),
        (514, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-19', 120), -4.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, -1552.00, 23.28),
        (515, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-18', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, -2910.00, 23.28),
        (516, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-17', 120), -5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, -2134.00, 23.28),
        (517, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-16', 120), -6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, -2522.00, 23.28),
        (518, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-15', 120), -1.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, -388.00, 23.28),
        (519, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-13', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, -2328.00, 23.28),
        (520, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-12', 120), -8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, -3104.00, 23.28),
        (521, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-11', 120), -10.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, -4074.00, 23.28),
        (522, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-10', 120), -8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, -3298.00, 23.28),
        (523, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-09', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, -2910.00, 23.28),
        (524, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-06', 120), -5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, -2134.00, 23.28),
        (525, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-05', 120), -2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, -970.00, 23.28),
        (526, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-04', 120), -7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, -2716.00, 23.28),
        (527, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-03', 120), -7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, -2910.00, 23.28),
        (528, 14529, 2001920365, 10, CONVERT(DATE, '2024-12-02', 120), -6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, -2328.00, 23.28),
        (529, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-22', 120), 9.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, 3492.00, 23.28),
        (530, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 2910.00, 23.28),
        (531, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-20', 120), 8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 3104.00, 23.28),
        (532, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-03', 120), -4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, -1552.00, 23.28),
        (533, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), -6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, -2328.00, 23.28),
        (534, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (535, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2910.00, 23.28),
        (536, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-17', 120), 5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 2134.00, 23.28),
        (537, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), 6.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 2522.00, 23.28),
        (538, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-15', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, 388.00, 23.28),
        (539, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2328.00, 23.28),
        (540, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (541, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-11', 120), 10.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 4074.00, 23.28),
        (542, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-10', 120), 8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3298.00, 23.28),
        (543, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 2910.00, 23.28),
        (544, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2134.00, 23.28),
        (545, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-05', 120), 2.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 970.00, 23.28),
        (546, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-04', 120), 7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 2716.00, 23.28),
        (547, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 1552.00, 23.28),
        (548, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), 6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 2328.00, 23.28),
        (549, 14529, 2001920365, 30, CONVERT(DATE, '2025-02-18', 120), 0.50, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-18', 120), 388.00, 194.00, 23.28),
        (550, 14529, 2001920365, 30, CONVERT(DATE, '2025-02-17', 120), 2.00, CONVERT(DATE, '2025-02-24', 120), CONVERT(DATE, '2025-02-17', 120), 388.00, 776.00, 23.28),
        (551, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 2134.00, 23.28),
        (552, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-05', 120), 2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 970.00, 23.28),
        (553, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-04', 120), 7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 2716.00, 23.28),
        (554, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 1552.00, 23.28),
        (555, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-02', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 2328.00, 23.28),
        (556, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-29', 120), 8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 3298.00, 23.28),
        (557, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-28', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 2328.00, 23.28),
        (558, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-24', 120), 3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, 1358.00, 23.28),
        (559, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-23', 120), 7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, 2716.00, 23.28),
        (560, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-30', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-30', 120), 388.00, 2522.00, 23.28),
        (561, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-20', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, 2328.00, 23.28),
        (562, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (563, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 2910.00, 23.28),
        (564, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-17', 120), 5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 2134.00, 23.28),
        (565, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 2522.00, 23.28),
        (566, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-15', 120), 1.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, 388.00, 23.28),
        (567, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 2328.00, 23.28),
        (568, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 3104.00, 23.28),
        (569, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-11', 120), 10.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 4074.00, 23.28),
        (570, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-10', 120), 8.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 3298.00, 23.28),
        (571, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 2910.00, 23.28),
        (572, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-04', 120), -7.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, -2716.00, 23.28),
        (573, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-05', 120), -2.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, -970.00, 23.28),
        (574, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-06', 120), -5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, -2134.00, 23.28),
        (575, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-09', 120), -7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, -2910.00, 23.28),
        (576, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-10', 120), -8.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, -3298.00, 23.28),
        (577, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-11', 120), -10.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, -4074.00, 23.28),
        (578, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-12', 120), -8.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, -3104.00, 23.28),
        (579, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-13', 120), -6.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, -2328.00, 23.28),
        (580, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-15', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-15', 120), 388.00, -388.00, 23.28),
        (581, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-16', 120), -6.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, -2522.00, 23.28),
        (582, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-17', 120), -5.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, -2134.00, 23.28),
        (583, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-30', 120), 4.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-30', 120), 388.00, 1746.00, 23.28),
        (584, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-18', 120), -7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, -2910.00, 23.28),
        (585, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-19', 120), -4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, -1552.00, 23.28),
        (586, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-31', 120), 3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-31', 120), 388.00, 1358.00, 23.28),
        (587, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-27', 120), 9.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 3686.00, 23.28),
        (588, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-02', 120), 3.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-02', 120), 388.00, 1358.00, 23.28),
        (589, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-23', 120), 1.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-23', 120), 388.00, 582.00, 23.28),
        (590, 14529, 2001920365, 30, CONVERT(DATE, '2024-12-27', 120), 2.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2024-12-27', 120), 388.00, 970.00, 23.28),
        (591, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 2910.00, 23.28),
        (592, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 2910.00, 23.28),
        (593, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-08', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 2522.00, 23.28),
        (594, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-09', 120), 5.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 1940.00, 23.28),
        (595, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-10', 120), 6.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 2522.00, 23.28),
        (596, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 2910.00, 23.28),
        (597, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-14', 120), 7.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 2716.00, 23.28),
        (598, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-15', 120), 10.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 3880.00, 23.28),
        (599, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-16', 120), 8.00, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 3104.00, 23.28),
        (600, 14529, 2001920365, 30, CONVERT(DATE, '2025-01-17', 120), 5.50, CONVERT(DATE, '2025-02-17', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 2134.00, 23.28)
    ) AS source (id, personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([id], [personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[id], source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 4/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (601, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 196.00, 1470.00, 11.76),
        (602, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 196.00, 1470.00, 11.76),
        (603, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 196.00, 1470.00, 11.76),
        (604, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 196.00, 1470.00, 11.76),
        (605, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 196.00, 1470.00, 11.76),
        (606, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, 1470.00, 11.76),
        (607, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-22', 120), -1.00, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-22', 120), 196.00, -196.00, 11.76),
        (608, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), -1.00, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, -196.00, 11.76),
        (609, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 196.00, 196.00, 11.76),
        (610, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-22', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 196.00, 196.00, 11.76),
        (611, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 1470.00, 11.76),
        (612, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 1470.00, 11.76),
        (613, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 1470.00, 11.76),
        (614, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 196.00, 1470.00, 11.76),
        (615, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 196.00, 1470.00, 11.76),
        (616, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-02', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-02', 120), 196.00, 1470.00, 11.76),
        (617, 14530, 2002055111, 10, CONVERT(DATE, '2025-01-03', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-03', 120), 196.00, 1470.00, 11.76),
        (618, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-20', 120), 7.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 196.00, 1470.00, 11.76),
        (619, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-19', 120), 7.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 196.00, 1470.00, 11.76),
        (620, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-18', 120), 7.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 196.00, 1470.00, 11.76),
        (621, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-17', 120), 7.50, CONVERT(DATE, '2024-12-17', 120), CONVERT(DATE, '2024-12-17', 120), 196.00, 1470.00, 11.76),
        (622, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 3.00, CONVERT(DATE, '2024-12-16', 120), CONVERT(DATE, '2024-12-16', 120), 196.00, 588.00, 11.76),
        (623, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-12', 120), 6.00, CONVERT(DATE, '2024-12-12', 120), CONVERT(DATE, '2024-12-12', 120), 196.00, 1176.00, 11.76),
        (624, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-13', 120), 6.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 196.00, 1176.00, 11.76),
        (625, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 6.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, 1176.00, 11.76),
        (626, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), -5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, -980.00, 11.76),
        (627, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 5.50, CONVERT(DATE, '2024-12-09', 120), CONVERT(DATE, '2024-12-06', 120), 196.00, 1078.00, 11.76),
        (628, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 5.00, CONVERT(DATE, '2024-12-09', 120), CONVERT(DATE, '2024-12-09', 120), 196.00, 980.00, 11.76),
        (629, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), -3.00, CONVERT(DATE, '2024-12-09', 120), CONVERT(DATE, '2024-12-06', 120), 196.00, -588.00, 11.76),
        (630, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-11', 120), 6.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-11', 120), 196.00, 1176.00, 11.76),
        (631, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 3.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 196.00, 588.00, 11.76),
        (632, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-05', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 196.00, 686.00, 11.76),
        (633, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-04', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 196.00, 686.00, 11.76),
        (634, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-03', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 196.00, 686.00, 11.76),
        (635, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 3.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 196.00, 686.00, 11.76),
        (636, 14530, 2002055111, 10, CONVERT(DATE, '2024-12-10', 120), 6.00, CONVERT(DATE, '2024-12-10', 120), CONVERT(DATE, '2024-12-10', 120), 196.00, 1176.00, 11.76),
        (637, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-17', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 210.00, 210.00, 12.60),
        (638, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 210.00, 210.00, 12.60),
        (639, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-15', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 210.00, 210.00, 12.60),
        (640, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-14', 120), 1.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 210.00, 210.00, 12.60),
        (641, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-13', 120), 2.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 210.00, 420.00, 12.60),
        (642, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-02', 120), 3.00, CONVERT(DATE, '2025-01-02', 120), CONVERT(DATE, '2025-01-02', 120), 210.00, 630.00, 12.60),
        (643, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-03', 120), 3.00, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 210.00, 630.00, 12.60),
        (644, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 420.00, 12.60),
        (645, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 420.00, 12.60),
        (646, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 420.00, 12.60),
        (647, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 420.00, 12.60),
        (648, 14531, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 2.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 420.00, 12.60),
        (649, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 210.00, 420.00, 12.60),
        (650, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 210.00, 420.00, 12.60),
        (651, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 2.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-16', 120), 210.00, 420.00, 12.60),
        (652, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 420.00, 12.60),
        (653, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 420.00, 12.60),
        (654, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 420.00, 12.60),
        (655, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 210.00, 420.00, 12.60),
        (656, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-12', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 420.00, 12.60),
        (657, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-11', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 420.00, 12.60),
        (658, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 420.00, 12.60),
        (659, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 420.00, 12.60),
        (660, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-24', 120), 3.00, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-24', 120), 210.00, 630.00, 12.60),
        (661, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-23', 120), 3.00, CONVERT(DATE, '2024-12-23', 120), CONVERT(DATE, '2024-12-23', 120), 210.00, 630.00, 12.60),
        (662, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 420.00, 12.60),
        (663, 14531, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 420.00, 12.60),
        (664, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-24', 120), 7.50, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-24', 120), 196.00, 1470.00, 11.76),
        (665, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 1470.00, 11.76),
        (666, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-09', 120), 196.00, 1470.00, 11.76),
        (667, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-10', 120), 196.00, 1470.00, 11.76),
        (668, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-13', 120), 196.00, 1470.00, 11.76),
        (669, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-14', 120), 196.00, 1470.00, 11.76),
        (670, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-15', 120), 196.00, 1470.00, 11.76),
        (671, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-16', 120), 196.00, 1470.00, 11.76),
        (672, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 196.00, 1470.00, 11.76),
        (673, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 7.50, CONVERT(DATE, '2024-12-24', 120), CONVERT(DATE, '2024-12-23', 120), 196.00, 1470.00, 11.76),
        (674, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-20', 120), 5.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 196.00, 980.00, 11.76),
        (675, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-02', 120), 4.00, CONVERT(DATE, '2025-01-02', 120), CONVERT(DATE, '2025-01-02', 120), 196.00, 784.00, 11.76),
        (676, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-03', 120), 4.00, CONVERT(DATE, '2025-01-03', 120), CONVERT(DATE, '2025-01-03', 120), 196.00, 784.00, 11.76),
        (677, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), 4.00, CONVERT(DATE, '2025-01-09', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 784.00, 11.76),
        (678, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 4.00, CONVERT(DATE, '2025-01-09', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 784.00, 11.76),
        (679, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), 4.00, CONVERT(DATE, '2025-01-09', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, 784.00, 11.76),
        (680, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), -4.00, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, -784.00, 11.76),
        (681, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), -4.00, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, -784.00, 11.76),
        (682, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), -4.00, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 196.00, -784.00, 11.76),
        (683, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 196.00, 1470.00, 11.76),
        (684, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 3.00, CONVERT(DATE, '2024-12-03', 120), CONVERT(DATE, '2024-12-02', 120), 196.00, 588.00, 11.76),
        (685, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-03', 120), 3.00, CONVERT(DATE, '2024-12-03', 120), CONVERT(DATE, '2024-12-03', 120), 196.00, 588.00, 11.76),
        (686, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-10', 120), 5.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-10', 120), 196.00, 980.00, 11.76),
        (687, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-11', 120), 5.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-11', 120), 196.00, 980.00, 11.76),
        (688, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-12', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 196.00, 1568.00, 11.76),
        (689, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-13', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 196.00, 1568.00, 11.76),
        (690, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 5.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-16', 120), 196.00, 980.00, 11.76),
        (691, 14532, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 196.00, 1470.00, 11.76),
        (692, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), 5.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 196.00, 980.00, 11.76),
        (693, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 4.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-18', 120), 196.00, 784.00, 11.76),
        (694, 14532, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), 5.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 196.00, 980.00, 11.76),
        (695, 14533, 3000512342, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-27', 120), CONVERT(DATE, '2025-01-24', 120), 288.00, 2160.00, 17.28),
        (696, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-02', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-02', 120), 288.00, 288.00, 17.28),
        (697, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 288.00, 288.00, 17.28),
        (698, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-19', 120), 288.00, 288.00, 17.28),
        (699, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-18', 120), 288.00, 288.00, 17.28),
        (700, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-17', 120), 288.00, 288.00, 17.28),
        (701, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-16', 120), 288.00, 288.00, 17.28),
        (702, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-03', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-03', 120), 288.00, 288.00, 17.28),
        (703, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-04', 120), 288.00, 288.00, 17.28),
        (704, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-06', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-06', 120), 288.00, 288.00, 17.28),
        (705, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-05', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-05', 120), 288.00, 288.00, 17.28),
        (706, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-09', 120), 288.00, 288.00, 17.28),
        (707, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-10', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-10', 120), 288.00, 288.00, 17.28),
        (708, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-11', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-11', 120), 288.00, 288.00, 17.28),
        (709, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-13', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-13', 120), 288.00, 288.00, 17.28),
        (710, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 288.00, -288.00, 17.28),
        (711, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 288.00, -288.00, 17.28),
        (712, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 288.00, -288.00, 17.28),
        (713, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), -1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 288.00, -288.00, 17.28),
        (714, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-23', 120), 4.00, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-23', 120), 288.00, 1152.00, 17.28),
        (715, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-24', 120), 4.00, CONVERT(DATE, '2025-01-07', 120), CONVERT(DATE, '2024-12-24', 120), 288.00, 1152.00, 17.28),
        (716, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 288.00, 288.00, 17.28),
        (717, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 288.00, 288.00, 17.28),
        (718, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 288.00, 288.00, 17.28),
        (719, 14533, 2002040046, 10, CONVERT(DATE, '2024-12-16', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 288.00, 288.00, 17.28),
        (720, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-21', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 478.00, 2868.00, 28.68),
        (721, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-10', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-10', 120), 478.00, 2868.00, 28.68),
        (722, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-09', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-09', 120), 478.00, 2868.00, 28.68),
        (723, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-08', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-08', 120), 478.00, 2868.00, 28.68),
        (724, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-07', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-07', 120), 478.00, 2868.00, 28.68),
        (725, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-06', 120), 6.00, CONVERT(DATE, '2025-01-10', 120), CONVERT(DATE, '2025-01-06', 120), 478.00, 2868.00, 28.68),
        (726, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-13', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 478.00, 2868.00, 28.68),
        (727, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-14', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 478.00, 2868.00, 28.68),
        (728, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-15', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 478.00, 2868.00, 28.68),
        (729, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-16', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 478.00, 2868.00, 28.68),
        (730, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-22', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 478.00, 2868.00, 28.68),
        (731, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-23', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 478.00, 2868.00, 28.68),
        (732, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-24', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 478.00, 2868.00, 28.68),
        (733, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-17', 120), 6.00, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 478.00, 2868.00, 28.68),
        (734, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-16', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 478.00, 956.00, 28.68),
        (735, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 478.00, 956.00, 28.68),
        (736, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 478.00, 956.00, 28.68),
        (737, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-04', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 478.00, 478.00, 28.68),
        (738, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 478.00, 956.00, 28.68),
        (739, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 478.00, 956.00, 28.68),
        (740, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 478.00, 478.00, 28.68),
        (741, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-19', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 478.00, 956.00, 28.68),
        (742, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-18', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 478.00, 956.00, 28.68),
        (743, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 478.00, 956.00, 28.68),
        (744, 14534, 2001920365, 40, CONVERT(DATE, '2025-01-20', 120), 6.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 478.00, 2868.00, 28.68),
        (745, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 478.00, 956.00, 28.68),
        (746, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-12', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 478.00, 956.00, 28.68),
        (747, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-11', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 478.00, 956.00, 28.68),
        (748, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 478.00, 956.00, 28.68),
        (749, 14534, 2001920365, 40, CONVERT(DATE, '2024-12-09', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 478.00, 478.00, 28.68),
        (750, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 478.00, 956.00, 28.68),
        (751, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 478.00, 956.00, 28.68),
        (752, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 478.00, 478.00, 28.68),
        (753, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 478.00, 478.00, 28.68),
        (754, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 478.00, 956.00, 28.68),
        (755, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-19', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 478.00, 478.00, 28.68),
        (756, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-20', 120), 1.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 478.00, 478.00, 28.68),
        (757, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 478.00, 956.00, 28.68),
        (758, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-17', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 478.00, 478.00, 28.68),
        (759, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-18', 120), 1.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 478.00, 478.00, 28.68),
        (760, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 1.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 478.00, 478.00, 28.68),
        (761, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 478.00, 956.00, 28.68),
        (762, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 478.00, 956.00, 28.68),
        (763, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 478.00, 956.00, 28.68),
        (764, 14534, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 478.00, 956.00, 28.68),
        (765, 14534, 3000512342, 10, CONVERT(DATE, '2025-03-06', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-06', 120), 478.00, 956.00, 28.68),
        (766, 14534, 3000512342, 10, CONVERT(DATE, '2025-03-13', 120), 2.00, CONVERT(DATE, '2025-03-13', 120), CONVERT(DATE, '2025-03-13', 120), 478.00, 956.00, 28.68),
        (767, 14534, 3000512342, 10, CONVERT(DATE, '2025-03-12', 120), 1.00, CONVERT(DATE, '2025-03-13', 120), CONVERT(DATE, '2025-03-12', 120), 478.00, 478.00, 28.68),
        (768, 14534, 3000512342, 10, CONVERT(DATE, '2025-03-05', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-05', 120), 478.00, 956.00, 28.68),
        (769, 14534, 3000512342, 10, CONVERT(DATE, '2025-03-03', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-03', 120), 478.00, 956.00, 28.68),
        (770, 14534, 3000512342, 10, CONVERT(DATE, '2025-03-04', 120), 2.00, CONVERT(DATE, '2025-03-06', 120), CONVERT(DATE, '2025-03-04', 120), 478.00, 956.00, 28.68),
        (771, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-18', 120), 0.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 478.00, 239.00, 28.68),
        (772, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-12', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 478.00, 239.00, 28.68),
        (773, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-10', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 478.00, 478.00, 28.68),
        (774, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 478.00, 478.00, 28.68),
        (775, 14534, 2002040046, 10, CONVERT(DATE, '2024-12-06', 120), 0.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 478.00, 239.00, 28.68),
        (776, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 4.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 945.00, 12.60),
        (777, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), -5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, -1050.00, 12.60),
        (778, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 1050.00, 12.60),
        (779, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 210.00, 1050.00, 12.60),
        (780, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 5.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-04', 120), 210.00, 1050.00, 12.60),
        (781, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 5.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-03', 120), 210.00, 1155.00, 12.60),
        (782, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 840.00, 12.60),
        (783, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 210.00, 945.00, 12.60),
        (784, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 210.00, 945.00, 12.60),
        (785, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 210.00, 945.00, 12.60),
        (786, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 4.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 210.00, 945.00, 12.60),
        (787, 14535, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 6.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-02', 120), 210.00, 1365.00, 12.60),
        (788, 14535, 2002040046, 10, CONVERT(DATE, '2025-01-09', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-09', 120), 210.00, 420.00, 12.60),
        (789, 14535, 2002040046, 10, CONVERT(DATE, '2025-01-08', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-08', 120), 210.00, 420.00, 12.60),
        (790, 14535, 2002040046, 10, CONVERT(DATE, '2025-01-07', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-07', 120), 210.00, 420.00, 12.60),
        (791, 14535, 2002040046, 10, CONVERT(DATE, '2025-01-06', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-06', 120), 210.00, 420.00, 12.60),
        (792, 14535, 2002040046, 10, CONVERT(DATE, '2025-01-10', 120), 2.00, CONVERT(DATE, '2025-02-06', 120), CONVERT(DATE, '2025-01-10', 120), 210.00, 420.00, 12.60),
        (793, 14535, 2002040046, 10, CONVERT(DATE, '2024-12-09', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 210.00, 105.00, 12.60),
        (794, 14535, 2002040046, 10, CONVERT(DATE, '2024-12-06', 120), 0.50, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 210.00, 105.00, 12.60),
        (795, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-19', 120), 3.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 148.00, 444.00, 8.88),
        (796, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-18', 120), 4.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 148.00, 666.00, 8.88),
        (797, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-20', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 148.00, 592.00, 8.88),
        (798, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-17', 120), 2.50, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 148.00, 370.00, 8.88),
        (799, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-13', 120), 1.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 148.00, 148.00, 8.88),
        (800, 14536, 2001920365, 40, CONVERT(DATE, '2024-12-12', 120), 0.50, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 148.00, 74.00, 8.88)
    ) AS source (id, personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([id], [personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[id], source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
    -- Batch 5/5
    MERGE [dbo].[timesheets] AS target
    USING (
        VALUES
        (801, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 8.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-11', 120), 148.00, 1184.00, 8.88),
        (802, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-10', 120), 148.00, 1184.00, 8.88),
        (803, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 8.00, CONVERT(DATE, '2024-12-11', 120), CONVERT(DATE, '2024-12-09', 120), 148.00, 1184.00, 8.88),
        (804, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-17', 120), 5.00, CONVERT(DATE, '2024-12-18', 120), CONVERT(DATE, '2024-12-17', 120), 148.00, 740.00, 8.88),
        (805, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 8.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-03', 120), 148.00, 1258.00, 8.88),
        (806, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 3.00, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-02', 120), 148.00, 444.00, 8.88),
        (807, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 5.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-02', 120), 148.00, 814.00, 8.88),
        (808, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 148.00, 592.00, 8.88),
        (809, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-20', 120), 3.50, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 148.00, 518.00, 8.88),
        (810, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 148.00, 592.00, 8.88),
        (811, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), -8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 148.00, -1184.00, 8.88),
        (812, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), -8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 148.00, -1184.00, 8.88),
        (813, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), -8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 148.00, -1184.00, 8.88),
        (814, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 148.00, 1184.00, 8.88),
        (815, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 148.00, 1184.00, 8.88),
        (816, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 8.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 148.00, 1184.00, 8.88),
        (817, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 3.00, CONVERT(DATE, '2024-12-17', 120), CONVERT(DATE, '2024-12-16', 120), 148.00, 444.00, 8.88),
        (818, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-18', 120), 3.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 148.00, 444.00, 8.88),
        (819, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-19', 120), 4.50, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 148.00, 666.00, 8.88),
        (820, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 8.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 148.00, 1184.00, 8.88),
        (821, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 8.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-05', 120), 148.00, 1184.00, 8.88),
        (822, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 5.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-04', 120), 148.00, 814.00, 8.88),
        (823, 14536, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 2.50, CONVERT(DATE, '2024-12-04', 120), CONVERT(DATE, '2024-12-04', 120), 148.00, 370.00, 8.88),
        (824, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-31', 120), 7.50, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 148.00, 1110.00, 8.88),
        (825, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-30', 120), 7.50, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 148.00, 1110.00, 8.88),
        (826, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-29', 120), 7.50, CONVERT(DATE, '2025-01-29', 120), CONVERT(DATE, '2025-01-29', 120), 148.00, 1110.00, 8.88),
        (827, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-28', 120), 7.50, CONVERT(DATE, '2025-01-28', 120), CONVERT(DATE, '2025-01-28', 120), 148.00, 1110.00, 8.88),
        (828, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-27', 120), 7.50, CONVERT(DATE, '2025-01-28', 120), CONVERT(DATE, '2025-01-27', 120), 148.00, 1110.00, 8.88),
        (829, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-24', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 148.00, 1110.00, 8.88),
        (830, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-23', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 148.00, 1110.00, 8.88),
        (831, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-22', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 148.00, 1110.00, 8.88),
        (832, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-21', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 148.00, 1110.00, 8.88),
        (833, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-20', 120), 7.50, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 148.00, 1110.00, 8.88),
        (834, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-15', 120), 148.00, 1110.00, 8.88),
        (835, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-14', 120), 148.00, 1110.00, 8.88),
        (836, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-13', 120), 148.00, 1110.00, 8.88),
        (837, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 148.00, 1110.00, 8.88),
        (838, 14536, 2002040046, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-16', 120), 148.00, 1110.00, 8.88),
        (839, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-09', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 1552.00, 23.28),
        (840, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-10', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 1552.00, 23.28),
        (841, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-11', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 1552.00, 23.28),
        (842, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-13', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 1552.00, 23.28),
        (843, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-12', 120), 4.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 1552.00, 23.28),
        (844, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-17', 120), 2.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 776.00, 23.28),
        (845, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-06', 120), 2.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 776.00, 23.28),
        (846, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-05', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 776.00, 23.28),
        (847, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-04', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 776.00, 23.28),
        (848, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-03', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 776.00, 23.28),
        (849, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-02', 120), 2.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 776.00, 23.28),
        (850, 14537, 2002059395, 10, CONVERT(DATE, '2024-12-16', 120), 3.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 1164.00, 23.28),
        (851, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-17', 120), 7.50, CONVERT(DATE, '2025-01-17', 120), CONVERT(DATE, '2025-01-17', 120), 388.00, 2910.00, 23.28),
        (852, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-16', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-16', 120), 388.00, 2910.00, 23.28),
        (853, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-02', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-02', 120), 388.00, 1552.00, 23.28),
        (854, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, -970.00, 23.28),
        (855, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, -970.00, 23.28),
        (856, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 2910.00, 23.28),
        (857, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 2910.00, 23.28),
        (858, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 2910.00, 23.28),
        (859, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 2910.00, 23.28),
        (860, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 7.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 2910.00, 23.28),
        (861, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-13', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-13', 120), 388.00, 2910.00, 23.28),
        (862, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-14', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-14', 120), 388.00, 2910.00, 23.28),
        (863, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-15', 120), 7.50, CONVERT(DATE, '2025-01-16', 120), CONVERT(DATE, '2025-01-15', 120), 388.00, 2910.00, 23.28),
        (864, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-28', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-28', 120), 388.00, 388.00, 23.28),
        (865, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-27', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-27', 120), 388.00, 388.00, 23.28),
        (866, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-20', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-20', 120), 388.00, 388.00, 23.28),
        (867, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-21', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-21', 120), 388.00, 388.00, 23.28),
        (868, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-22', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-22', 120), 388.00, 388.00, 23.28),
        (869, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-23', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-23', 120), 388.00, 388.00, 23.28),
        (870, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-24', 120), 1.00, CONVERT(DATE, '2025-01-24', 120), CONVERT(DATE, '2025-01-24', 120), 388.00, 388.00, 23.28),
        (871, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, 970.00, 23.28),
        (872, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, 970.00, 23.28),
        (873, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, 970.00, 23.28),
        (874, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-09', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-09', 120), 388.00, 970.00, 23.28),
        (875, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-10', 120), 2.50, CONVERT(DATE, '2025-01-13', 120), CONVERT(DATE, '2025-01-10', 120), 388.00, 970.00, 23.28),
        (876, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-06', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-06', 120), 388.00, -970.00, 23.28),
        (877, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-07', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-07', 120), 388.00, -970.00, 23.28),
        (878, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-08', 120), -2.50, CONVERT(DATE, '2025-01-15', 120), CONVERT(DATE, '2025-01-08', 120), 388.00, -970.00, 23.28),
        (879, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-31', 120), 1.00, CONVERT(DATE, '2025-01-31', 120), CONVERT(DATE, '2025-01-31', 120), 388.00, 388.00, 23.28),
        (880, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-30', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-30', 120), 388.00, 388.00, 23.28),
        (881, 14537, 2002055111, 10, CONVERT(DATE, '2025-01-29', 120), 1.00, CONVERT(DATE, '2025-01-30', 120), CONVERT(DATE, '2025-01-29', 120), 388.00, 388.00, 23.28),
        (882, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-20', 120), 4.00, CONVERT(DATE, '2024-12-20', 120), CONVERT(DATE, '2024-12-20', 120), 388.00, 1552.00, 23.28),
        (883, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-19', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-19', 120), 388.00, 1552.00, 23.28),
        (884, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-18', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-18', 120), 388.00, 1552.00, 23.28),
        (885, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-17', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-17', 120), 388.00, 1552.00, 23.28),
        (886, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-16', 120), 4.00, CONVERT(DATE, '2024-12-19', 120), CONVERT(DATE, '2024-12-16', 120), 388.00, 1552.00, 23.28),
        (887, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-13', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-13', 120), 388.00, 776.00, 23.28),
        (888, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-12', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-12', 120), 388.00, 776.00, 23.28),
        (889, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-11', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-11', 120), 388.00, 776.00, 23.28),
        (890, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-10', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-10', 120), 388.00, 776.00, 23.28),
        (891, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-09', 120), 2.00, CONVERT(DATE, '2024-12-13', 120), CONVERT(DATE, '2024-12-09', 120), 388.00, 776.00, 23.28),
        (892, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-05', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-05', 120), 388.00, 1552.00, 23.28),
        (893, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-04', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-04', 120), 388.00, 1552.00, 23.28),
        (894, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-03', 120), 4.00, CONVERT(DATE, '2024-12-05', 120), CONVERT(DATE, '2024-12-03', 120), 388.00, 1552.00, 23.28),
        (895, 14537, 2002055111, 10, CONVERT(DATE, '2024-12-06', 120), 4.00, CONVERT(DATE, '2024-12-06', 120), CONVERT(DATE, '2024-12-06', 120), 388.00, 1552.00, 23.28)
    ) AS source (id, personnel_no, eng_no, eng_phase, work_date, hours, time_entry_date, posting_date, charge_out_rate, std_price, adm_surcharge)
    ON target.[id] = source.[id]
    WHEN MATCHED THEN
        UPDATE SET target.[personnel_no] = source.[personnel_no], target.[eng_no] = source.[eng_no], target.[eng_phase] = source.[eng_phase], target.[work_date] = source.[work_date], target.[hours] = source.[hours], target.[time_entry_date] = source.[time_entry_date], target.[posting_date] = source.[posting_date], target.[charge_out_rate] = source.[charge_out_rate], target.[std_price] = source.[std_price], target.[adm_surcharge] = source.[adm_surcharge]
    WHEN NOT MATCHED THEN
        INSERT ([id], [personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge])
        VALUES (source.[id], source.[personnel_no], source.[eng_no], source.[eng_phase], source.[work_date], source.[hours], source.[time_entry_date], source.[posting_date], source.[charge_out_rate], source.[std_price], source.[adm_surcharge]);
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

-- MERGE statements for vacations table
PRINT 'Upserting data into vacations table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[vacations] AS target
    USING (
        VALUES
        (14531, CONVERT(DATE, '2025-03-10', 120), CONVERT(DATE, '2025-03-17', 120)),
        (14533, CONVERT(DATE, '2025-07-01', 120), CONVERT(DATE, '2025-07-15', 120)),
        (14528, CONVERT(DATE, '2025-08-03', 120), CONVERT(DATE, '2025-08-17', 120)),
        (14525, CONVERT(DATE, '2025-10-20', 120), CONVERT(DATE, '2025-10-27', 120)),
        (14537, CONVERT(DATE, '2025-12-22', 120), CONVERT(DATE, '2025-12-31', 120))
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

-- MERGE statements for charge_out_rates table
PRINT 'Upserting data into charge_out_rates table...';
BEGIN TRY
    BEGIN TRANSACTION;
    -- Batch 1/1
    MERGE [dbo].[charge_out_rates] AS target
    USING (
        VALUES
        (2001920365, 14523, 210.00),
        (2001920365, 14524, 196.00),
        (2001920365, 14525, 274.00),
        (2001920365, 14526, 388.00),
        (2001920365, 14528, 318.00),
        (2001920365, 14529, 388.00),
        (2001920365, 14534, 478.00),
        (2001920365, 14536, 148.00),
        (2002040046, 14525, 274.00),
        (2002040046, 14532, 196.00),
        (2002040046, 14533, 288.00),
        (2002040046, 14534, 478.00),
        (2002040046, 14535, 210.00),
        (2002040046, 14536, 148.00),
        (2002055111, 14525, 256.00),
        (2002055111, 14530, 196.00),
        (2002055111, 14531, 210.00),
        (2002055111, 14537, 388.00),
        (2002059395, 14534, 478.00),
        (2002059395, 14535, 210.00),
        (2002059395, 14536, 148.00),
        (2002059395, 14537, 388.00),
        (3000512342, 14523, 210.00),
        (3000512342, 14525, 256.00),
        (3000512342, 14527, 210.00),
        (3000512342, 14533, 288.00),
        (3000512342, 14534, 478.00)
    ) AS source (eng_no, personnel_no, standard_chargeout_rate)
    ON target.[eng_no] = source.[eng_no] AND target.[personnel_no] = source.[personnel_no]
    WHEN MATCHED THEN
        UPDATE SET target.[standard_chargeout_rate] = source.[standard_chargeout_rate]
    WHEN NOT MATCHED THEN
        INSERT ([eng_no], [personnel_no], [standard_chargeout_rate])
        VALUES (source.[eng_no], source.[personnel_no], source.[standard_chargeout_rate]);
    COMMIT TRANSACTION;
    PRINT 'Completed upsert for charge_out_rates';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    PRINT 'Error upserting data into charge_out_rates: ' + @ErrorMessage;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

-- Turn count of rows affected back on
SET NOCOUNT OFF;
GO

PRINT 'Data upsert operations completed successfully.';
GO
