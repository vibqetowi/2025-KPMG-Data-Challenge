USE master;
GO

-- Check if the database exists
IF DB_ID('KPMG_Data_Challenge') IS NOT NULL
BEGIN
    -- Database exists, so drop it after setting to single user mode and rolling back immediate transactions
    ALTER DATABASE KPMG_Data_Challenge SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE KPMG_Data_Challenge;
END
GO

-- Create the new database
CREATE DATABASE KPMG_Data_Challenge;
GO

-- Switch to the newly created database
USE KPMG_Data_Challenge;
GO

-- Create tables
CREATE TABLE [employees] (
  [personnel_no] integer PRIMARY KEY,
  [employee_name] nvarchar(255),
  [staff_level] nvarchar(255),
  [is_external] bit
)
GO

CREATE TABLE [clients] (
  [client_no] integer PRIMARY KEY,
  [client_name] nvarchar(255)
)
GO

CREATE TABLE [engagements] (
  [eng_no] bigint PRIMARY KEY,
  [eng_description] nvarchar(255),
  [client_no] integer
)
GO

CREATE TABLE [phases] (
  [eng_no] bigint,
  [eng_phase] integer,
  [phase_description] nvarchar(255),
  [budget] decimal,
  PRIMARY KEY ([eng_no], [eng_phase])
)
GO

CREATE TABLE [staffing] (
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [personnel_no] integer,
  [eng_no] bigint,
  [eng_phase] integer,
  [week_start_date] date,
  [planned_hours] decimal
)
GO

CREATE TABLE [timesheets] (
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [personnel_no] integer,
  [eng_no] bigint,
  [eng_phase] integer,
  [work_date] date,
  [hours] decimal,
  [time_entry_date] date,
  [posting_date] date,
  [charge_out_rate] decimal,
  [std_price] decimal,
  [adm_surcharge] decimal
)
GO

CREATE TABLE [dictionary] (
  [key] nvarchar(255) PRIMARY KEY,
  [description] nvarchar(255)
)
GO

-- Create indexes
CREATE INDEX [employees_index_0] ON [employees] ("staff_level")
GO

CREATE INDEX [employees_index_1] ON [employees] ("staff_level", "is_external")
GO

CREATE INDEX [clients_index_2] ON [clients] ("client_name")
GO

CREATE INDEX [engagements_index_3] ON [engagements] ("client_no")
GO

CREATE INDEX [engagements_index_4] ON [engagements] ("eng_description")
GO

CREATE INDEX [phases_index_5] ON [phases] ("budget")
GO

CREATE INDEX [staffing_index_6] ON [staffing] ("personnel_no", "week_start_date")
GO

CREATE INDEX [staffing_index_7] ON [staffing] ("eng_no", "eng_phase", "week_start_date")
GO

CREATE INDEX [staffing_index_8] ON [staffing] ("week_start_date")
GO

CREATE INDEX [staffing_index_9] ON [staffing] ("eng_no", "week_start_date")
GO

CREATE INDEX [timesheets_index_10] ON [timesheets] ("work_date")
GO

CREATE INDEX [timesheets_index_11] ON [timesheets] ("personnel_no", "work_date")
GO

CREATE INDEX [timesheets_index_12] ON [timesheets] ("eng_no", "eng_phase", "work_date")
GO

CREATE INDEX [timesheets_index_13] ON [timesheets] ("posting_date")
GO

CREATE INDEX [timesheets_index_14] ON [timesheets] ("eng_no", "work_date")
GO

-- Add extended property
EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'First Monday of the week, e.g. 2025-01-06',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'staffing',
@level2type = N'Column', @level2name = 'week_start_date';
GO

-- Add foreign keys
ALTER TABLE [engagements] ADD FOREIGN KEY ([client_no]) REFERENCES [clients] ([client_no])
GO

ALTER TABLE [phases] ADD FOREIGN KEY ([eng_no]) REFERENCES [engagements] ([eng_no])
GO

ALTER TABLE [staffing] ADD FOREIGN KEY ([personnel_no]) REFERENCES [employees] ([personnel_no])
GO

ALTER TABLE [staffing] ADD FOREIGN KEY ([eng_no], [eng_phase]) REFERENCES [phases] ([eng_no], [eng_phase])
GO

ALTER TABLE [timesheets] ADD FOREIGN KEY ([personnel_no]) REFERENCES [employees] ([personnel_no])
GO

ALTER TABLE [timesheets] ADD FOREIGN KEY ([eng_no], [eng_phase]) REFERENCES [phases] ([eng_no], [eng_phase])
GO