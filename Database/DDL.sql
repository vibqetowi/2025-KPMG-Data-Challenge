USE master;
GO

-- Create database only if it doesn't exist
IF DB_ID('KPMG_Data_Challenge') IS NULL
BEGIN
    CREATE DATABASE KPMG_Data_Challenge;
END
GO

-- Switch to the database
USE KPMG_Data_Challenge;
GO

-- Drop existing tables in the correct order (to avoid foreign key constraint violations)
-- First drop tables with foreign key dependencies
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'charge_out_rates')
    DROP TABLE [charge_out_rates];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'vacations')
    DROP TABLE [vacations];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'timesheets')
    DROP TABLE [timesheets];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'staffing')
    DROP TABLE [staffing];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'phases')
    DROP TABLE [phases];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'engagements')
    DROP TABLE [engagements];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'employees')
    DROP TABLE [employees];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'clients')
    DROP TABLE [clients];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'practices')
    DROP TABLE [practices];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'dictionary')
    DROP TABLE [dictionary];
GO

-- Create practices table
CREATE TABLE [practices] (
  [practice_id] int PRIMARY KEY,
  [practice_name] nvarchar(255),
  [description] nvarchar(255)
);

CREATE INDEX [practices_index_0] ON [practices] ([practice_name]);
GO

-- Create employees table
CREATE TABLE [employees] (
  [personnel_no] int PRIMARY KEY,
  [employee_name] nvarchar(255),
  [staff_level] nvarchar(255),
  [is_external] bit,
  [employment_basis] decimal(5,2),
  [practice_id] int
);

CREATE INDEX [employees_index_0] ON [employees] ([staff_level]);
CREATE INDEX [employees_index_1] ON [employees] ([staff_level], [is_external]);
CREATE INDEX [employees_index_2] ON [employees] ([practice_id]);
GO

-- Create clients table
CREATE TABLE [clients] (
  [client_no] int PRIMARY KEY,
  [client_name] nvarchar(255)
);

CREATE INDEX [clients_index_0] ON [clients] ([client_name]);
GO

-- Create engagements table
CREATE TABLE [engagements] (
  [eng_no] bigint PRIMARY KEY,
  [eng_description] nvarchar(255),
  [client_no] int,
  [start_date] date,
  [end_date] date,
  [actual_end_date] date,
  [primary_practice_id] int
);

CREATE INDEX [engagements_index_0] ON [engagements] ([client_no]);
CREATE INDEX [engagements_index_1] ON [engagements] ([eng_description]);
CREATE INDEX [engagements_index_2] ON [engagements] ([start_date]);
CREATE INDEX [engagements_index_3] ON [engagements] ([end_date]);
CREATE INDEX [engagements_index_4] ON [engagements] ([primary_practice_id]);
GO

-- Create phases table
CREATE TABLE [phases] (
  [eng_no] bigint,
  [eng_phase] int,
  [phase_description] nvarchar(255),
  [budget] decimal(18,2),
  [start_date] date,
  [end_date] date,
  [actual_end_date] date,
  PRIMARY KEY ([eng_no], [eng_phase])
);

CREATE INDEX [phases_index_0] ON [phases] ([budget]);
CREATE INDEX [phases_index_1] ON [phases] ([start_date]);
CREATE INDEX [phases_index_2] ON [phases] ([end_date]);
GO

-- Create staffing table
CREATE TABLE [staffing] (
  [personnel_no] int,
  [eng_no] bigint,
  [eng_phase] int,
  [week_start_date] date,
  [planned_hours] decimal(8,2),
  PRIMARY KEY ([personnel_no], [eng_no], [eng_phase], [week_start_date])
);

CREATE INDEX [staffing_index_1] ON [staffing] ([eng_no], [eng_phase], [week_start_date]);
CREATE INDEX [staffing_index_2] ON [staffing] ([week_start_date]);
CREATE INDEX [staffing_index_3] ON [staffing] ([eng_no], [week_start_date]);
GO

-- Create timesheets table
CREATE TABLE [timesheets] (
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [personnel_no] int,
  [eng_no] bigint,
  [eng_phase] int,
  [work_date] date,
  [hours] decimal(8,2),
  [time_entry_date] date,
  [posting_date] date,
  [charge_out_rate] decimal(10,2),
  [std_price] decimal(10,2),
  [adm_surcharge] decimal(10,2)
);

CREATE INDEX [timesheets_index_0] ON [timesheets] ([work_date]);
CREATE INDEX [timesheets_index_1] ON [timesheets] ([personnel_no], [work_date]);
CREATE INDEX [timesheets_index_2] ON [timesheets] ([eng_no], [eng_phase], [work_date]);
CREATE INDEX [timesheets_index_3] ON [timesheets] ([posting_date]);
CREATE INDEX [timesheets_index_4] ON [timesheets] ([eng_no], [work_date]);
GO

-- Create dictionary table
CREATE TABLE [dictionary] (
  [key] nvarchar(255) PRIMARY KEY,
  [description] nvarchar(255)
);
GO

-- Create vacations table
CREATE TABLE [vacations] (
  [personnel_no] int,
  [start_date] date,
  [end_date] date,
  PRIMARY KEY ([personnel_no], [start_date])
);

CREATE INDEX [vacations_index_0] ON [vacations] ([end_date]);
CREATE INDEX [vacations_index_1] ON [vacations] ([personnel_no]);
GO

-- Create charge_out_rates table
CREATE TABLE [charge_out_rates] (
  [eng_no] bigint,
  [personnel_no] int,
  [standard_chargeout_rate] decimal(10,2),
  PRIMARY KEY ([eng_no], [personnel_no])
);
GO

-- Add or update column descriptions
IF EXISTS (SELECT 1 FROM fn_listextendedproperty('Column_Description', 'SCHEMA', 'dbo', 'TABLE', 'employees', 'COLUMN', 'employment_basis'))
    EXEC sp_updateextendedproperty
    @name = N'Column_Description',
    @value = 'Contracted weekly hours (e.g., 40.0, 37.5)',
    @level0type = N'Schema', @level0name = 'dbo',
    @level1type = N'Table',  @level1name = 'employees',
    @level2type = N'Column', @level2name = 'employment_basis';
ELSE
    EXEC sp_addextendedproperty
    @name = N'Column_Description',
    @value = 'Contracted weekly hours (e.g., 40.0, 37.5)',
    @level0type = N'Schema', @level0name = 'dbo',
    @level1type = N'Table',  @level1name = 'employees',
    @level2type = N'Column', @level2name = 'employment_basis';
GO

IF EXISTS (SELECT 1 FROM fn_listextendedproperty('Column_Description', 'SCHEMA', 'dbo', 'TABLE', 'staffing', 'COLUMN', 'week_start_date'))
    EXEC sp_updateextendedproperty
    @name = N'Column_Description',
    @value = 'First Monday of the week, e.g. 2025-01-06',
    @level0type = N'Schema', @level0name = 'dbo',
    @level1type = N'Table',  @level1name = 'staffing',
    @level2type = N'Column', @level2name = 'week_start_date';
ELSE
    EXEC sp_addextendedproperty
    @name = N'Column_Description',
    @value = 'First Monday of the week, e.g. 2025-01-06',
    @level0type = N'Schema', @level0name = 'dbo',
    @level1type = N'Table',  @level1name = 'staffing',
    @level2type = N'Column', @level2name = 'week_start_date';
GO

-- Add foreign key constraints
ALTER TABLE [employees] ADD CONSTRAINT [FK_employees_practices]
    FOREIGN KEY ([practice_id]) REFERENCES [practices] ([practice_id])
GO

ALTER TABLE [engagements] ADD CONSTRAINT [FK_engagements_practices]
    FOREIGN KEY ([primary_practice_id]) REFERENCES [practices] ([practice_id])
GO

ALTER TABLE [engagements] ADD CONSTRAINT [FK_engagements_clients] 
    FOREIGN KEY ([client_no]) REFERENCES [clients] ([client_no])
GO

ALTER TABLE [phases] ADD CONSTRAINT [FK_phases_engagements]
    FOREIGN KEY ([eng_no]) REFERENCES [engagements] ([eng_no])
GO

ALTER TABLE [staffing] ADD CONSTRAINT [FK_staffing_employees]
    FOREIGN KEY ([personnel_no]) REFERENCES [employees] ([personnel_no])
GO

ALTER TABLE [staffing] ADD CONSTRAINT [FK_staffing_phases]
    FOREIGN KEY ([eng_no], [eng_phase]) REFERENCES [phases] ([eng_no], [eng_phase])
GO

ALTER TABLE [timesheets] ADD CONSTRAINT [FK_timesheets_employees]
    FOREIGN KEY ([personnel_no]) REFERENCES [employees] ([personnel_no])
GO

ALTER TABLE [timesheets] ADD CONSTRAINT [FK_timesheets_phases]
    FOREIGN KEY ([eng_no], [eng_phase]) REFERENCES [phases] ([eng_no], [eng_phase])
GO

ALTER TABLE [vacations] ADD CONSTRAINT [FK_vacations_employees]
    FOREIGN KEY ([personnel_no]) REFERENCES [employees] ([personnel_no])
GO

ALTER TABLE [charge_out_rates] ADD CONSTRAINT [FK_charge_out_rates_engagements]
    FOREIGN KEY ([eng_no]) REFERENCES [engagements] ([eng_no])
GO

ALTER TABLE [charge_out_rates] ADD CONSTRAINT [FK_charge_out_rates_employees]
    FOREIGN KEY ([personnel_no]) REFERENCES [employees] ([personnel_no])
GO
