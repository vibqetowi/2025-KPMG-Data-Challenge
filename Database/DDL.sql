CREATE TABLE [employees] (
  [personnel_no] integer PRIMARY KEY,
  [employee_name] nvarchar(255),
  [staff_level] nvarchar(255),
  [is_external] bool,
  [employment_basis] decimal
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

CREATE TABLE [vacations] (
  [personnel_no] integer,
  [start_date] date,
  [end_date] date,
  PRIMARY KEY ([personnel_no], [start_date])
)
GO

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

CREATE INDEX [vacations_index_15] ON [vacations] ("end_date")
GO

CREATE INDEX [vacations_index_16] ON [vacations] ("personnel_no")
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Contracted weekly hours (e.g., 40.0, 37.5)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'employees',
@level2type = N'Column', @level2name = 'employment_basis';
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

ALTER TABLE [vacations] ADD FOREIGN KEY ([personnel_no]) REFERENCES [employees] ([personnel_no])
GO
