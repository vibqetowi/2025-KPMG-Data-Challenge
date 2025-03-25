CREATE TABLE [employees] (
  [personnel_no] integer PRIMARY KEY,
  [employee_name] nvarchar(255),
  [staff_level] nvarchar(255),
  [is_external] bool
)
GO

CREATE TABLE [clients] (
  [client_no] integer PRIMARY KEY,
  [client_name] nvarchar(255)
)
GO

CREATE TABLE [engagements] (
  [eng_no] integer PRIMARY KEY,
  [eng_description] nvarchar(255),
  [client_no] integer
)
GO

CREATE TABLE [phases] (
  [eng_no] integer,
  [eng_phase] integer,
  [phase_description] nvarchar(255),
  [budget] decimal,
  PRIMARY KEY ([eng_no], [eng_phase])
)
GO

CREATE TABLE [staffing] (
  [id] integer PRIMARY KEY,
  [personnel_no] integer,
  [eng_no] integer,
  [eng_phase] integer,
  [week_start_date] date,
  [planned_hours] decimal
)
GO

CREATE TABLE [timesheets] (
  [id] integer PRIMARY KEY,
  [personnel_no] integer,
  [eng_no] integer,
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

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'First Monday of the week, e.g. 2025-01-06',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'staffing',
@level2type = N'Column', @level2name = 'week_start_date';
GO

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
