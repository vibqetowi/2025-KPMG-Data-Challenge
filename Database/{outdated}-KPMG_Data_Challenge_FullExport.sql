USE [master]
GO
/****** Object:  Database [KPMG_Data_Challenge]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE DATABASE [KPMG_Data_Challenge]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'KPMG_Data_Challenge', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\KPMG_Data_Challenge.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'KPMG_Data_Challenge_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\KPMG_Data_Challenge_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [KPMG_Data_Challenge] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [KPMG_Data_Challenge].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [KPMG_Data_Challenge] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET ARITHABORT OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET  ENABLE_BROKER 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET  MULTI_USER 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [KPMG_Data_Challenge] SET DB_CHAINING OFF 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [KPMG_Data_Challenge] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [KPMG_Data_Challenge] SET QUERY_STORE = ON
GO
ALTER DATABASE [KPMG_Data_Challenge] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [KPMG_Data_Challenge]
GO
/****** Object:  User [carter]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE USER [carter] FOR LOGIN [carter] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [carter]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [carter]
GO
/****** Object:  Table [dbo].[clients]    Script Date: 2025-03-26 11:29:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clients](
	[client_no] [int] NOT NULL,
	[client_name] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[client_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dictionary]    Script Date: 2025-03-26 11:29:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dictionary](
	[key] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employees]    Script Date: 2025-03-26 11:29:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employees](
	[personnel_no] [int] NOT NULL,
	[employee_name] [nvarchar](255) NULL,
	[staff_level] [nvarchar](255) NULL,
	[is_external] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[personnel_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[engagements]    Script Date: 2025-03-26 11:29:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[engagements](
	[eng_no] [bigint] NOT NULL,
	[eng_description] [nvarchar](255) NULL,
	[client_no] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[eng_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phases]    Script Date: 2025-03-26 11:29:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phases](
	[eng_no] [bigint] NOT NULL,
	[eng_phase] [int] NOT NULL,
	[phase_description] [nvarchar](255) NULL,
	[budget] [decimal](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[eng_no] ASC,
	[eng_phase] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[staffing]    Script Date: 2025-03-26 11:29:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[staffing](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[personnel_no] [int] NULL,
	[eng_no] [bigint] NULL,
	[eng_phase] [int] NULL,
	[week_start_date] [date] NULL,
	[planned_hours] [decimal](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[timesheets]    Script Date: 2025-03-26 11:29:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[timesheets](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[personnel_no] [int] NULL,
	[eng_no] [bigint] NULL,
	[eng_phase] [int] NULL,
	[work_date] [date] NULL,
	[hours] [decimal](18, 0) NULL,
	[time_entry_date] [date] NULL,
	[posting_date] [date] NULL,
	[charge_out_rate] [decimal](18, 0) NULL,
	[std_price] [decimal](18, 0) NULL,
	[adm_surcharge] [decimal](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[clients] ([client_no], [client_name]) VALUES (1000017023, N'Company X')
INSERT [dbo].[clients] ([client_no], [client_name]) VALUES (1000017024, N'Company Y')
GO
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'AC', N'Actual Cost - The realized cost incurred for the work performed')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Adm. Surcharge', N'Administrative fees')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'BAC', N'Budget At Completion - The total authorized budget for the project')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Charge+AC0-Out Rate', N'Hourly wage of the employee which is charged to the client')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Client Name', N'Client name')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Client No.', N'Client key')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'CPI', N'Cost Performance Index - Measure of cost efficiency (EV/AC)')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'CV', N'Cost Variance - Indicates whether the project is under or over budget (EV-AC)')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'EAC', N'Estimate At Completion - The expected total cost of the project when completed')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Employee Name', N'Employenomn')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Eng. Description', N'Mandate description')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Eng. No.', N'Mandate key')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Eng. Phase', N'Mandate phase')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'ETC', N'Estimate To Complete - The expected cost to finish all remaining project work')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'EV', N'Earned Value - The measure of work performed expressed in terms of the budget authorized for that work')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Hours', N'Number of hours entered in the timesheet')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Personnel No.', N'Employee key')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Phase Description', N'Mandate phase description')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Posting Date', N'Day when the employee sent the details of their timesheet')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'PV', N'Planned Value - The authorized budget assigned to scheduled work')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'SPI', N'Schedule Performance Index - Measure of schedule efficiency (EV/PV)')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Staff Level', N'Employee title')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Std. Price', N'Hourly wage +ACo- Number of hours worked')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'SV', N'Schedule Variance - Indicates whether the project is ahead or behind schedule (EV-PV)')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'TCPI', N'To Complete Performance Index - The cost performance that must be achieved to complete remaining work within budget')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Time Entry Date', N'Day when the employee entered the details of their timesheet')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'VAC', N'Variance At Completion - Projection of the amount of budget deficit or surplus (BAC-EAC)')
INSERT [dbo].[dictionary] ([key], [description]) VALUES (N'Work Date', N'Work day')
GO
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14523, N'Alice Dupont', N'SPECIALIST/SENIOR CONSULT', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14524, N'Bastien Lefèvre', N'SPECIALIST/SENIOR CONSULT', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14525, N'Camille Moreau', N'MANAGER', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14526, N'Damien Girard', N'SENIOR MANAGER', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14527, N'Élodie Roux', N'SPECIALIST/SENIOR CONSULT', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14528, N'Fabien Martin', N'SENIOR MANAGER', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14529, N'Gaëlle Petit', N'SENIOR MANAGER', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14530, N'Hugo Lemoine', N'SPECIALIST/SENIOR CONSULT', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14531, N'Inès Bernard', N'SPECIALIST/SENIOR CONSULT', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14532, N'Julien Thomas', N'SPECIALIST/SENIOR CONSULT', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14533, N'Léa Fournier', N'MANAGER', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14534, N'Mathieu Dubois', N'SENIOR MANAGER', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14535, N'Nina Simon', N'SPECIALIST/SENIOR CONSULT', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14536, N'Olivier Robert', N'STAFF ACCOUNTANT/CONSULTA', 0)
INSERT [dbo].[employees] ([personnel_no], [employee_name], [staff_level], [is_external]) VALUES (14537, N'Sophie Garnier', N'SENIOR MANAGER', 0)
GO
INSERT [dbo].[engagements] ([eng_no], [eng_description], [client_no]) VALUES (2001920365, N'Neptune', 1000017023)
INSERT [dbo].[engagements] ([eng_no], [eng_description], [client_no]) VALUES (2002040046, N'Terra', 1000017023)
INSERT [dbo].[engagements] ([eng_no], [eng_description], [client_no]) VALUES (2002055111, N'Nexus', 1000017024)
INSERT [dbo].[engagements] ([eng_no], [eng_description], [client_no]) VALUES (2002059395, N'Ventus', 1000017023)
INSERT [dbo].[engagements] ([eng_no], [eng_description], [client_no]) VALUES (3000512342, N'Flora', 1000017023)
GO
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (2001920365, 10, N'Mars', CAST(2300000 AS Decimal(18, 0)))
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (2001920365, 20, N'Solaris', CAST(1150000 AS Decimal(18, 0)))
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (2001920365, 30, N'Aquilon', CAST(1250000 AS Decimal(18, 0)))
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (2001920365, 40, N'Horizon', CAST(1350000 AS Decimal(18, 0)))
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (2002040046, 10, N'Livraison', CAST(950000 AS Decimal(18, 0)))
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (2002055111, 10, N'Admin', CAST(2500000 AS Decimal(18, 0)))
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (2002059395, 10, N'Otientation', CAST(170000 AS Decimal(18, 0)))
INSERT [dbo].[phases] ([eng_no], [eng_phase], [phase_description], [budget]) VALUES (3000512342, 10, N'Gestion', CAST(3000000 AS Decimal(18, 0)))
GO
SET IDENTITY_INSERT [dbo].[staffing] ON 

INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (1, 14523, 2001920365, 10, CAST(N'2024-12-02' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (2, 14523, 2001920365, 10, CAST(N'2024-12-09' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (3, 14523, 2001920365, 10, CAST(N'2024-12-16' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (4, 14523, 2001920365, 10, CAST(N'2024-12-23' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (5, 14523, 2001920365, 10, CAST(N'2024-12-30' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (6, 14524, 2001920365, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (7, 14524, 2001920365, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (8, 14524, 2001920365, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (9, 14524, 2001920365, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (10, 14524, 2001920365, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (11, 14525, 2001920365, 10, CAST(N'2024-12-09' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (12, 14525, 2001920365, 10, CAST(N'2024-12-16' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (13, 14525, 2001920365, 10, CAST(N'2024-12-23' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (14, 14525, 2001920365, 10, CAST(N'2024-12-30' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (15, 14526, 2001920365, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (16, 14526, 2001920365, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (17, 14526, 2001920365, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (18, 14526, 2001920365, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (19, 14526, 2001920365, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (20, 14528, 2001920365, 20, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (21, 14528, 2001920365, 20, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (22, 14528, 2001920365, 20, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (23, 14528, 2001920365, 20, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (24, 14528, 2001920365, 20, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (25, 14529, 2001920365, 30, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (26, 14529, 2001920365, 30, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (27, 14529, 2001920365, 30, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (28, 14529, 2001920365, 30, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (29, 14529, 2001920365, 30, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (30, 14534, 2001920365, 40, CAST(N'2024-12-02' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (31, 14534, 2001920365, 40, CAST(N'2024-12-09' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (32, 14534, 2001920365, 40, CAST(N'2024-12-16' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (33, 14534, 2001920365, 40, CAST(N'2024-12-23' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (34, 14534, 2001920365, 40, CAST(N'2024-12-30' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (35, 14525, 2001920365, 40, CAST(N'2024-12-09' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (36, 14525, 2001920365, 40, CAST(N'2024-12-16' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (37, 14525, 2001920365, 40, CAST(N'2024-12-23' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (38, 14525, 2001920365, 40, CAST(N'2024-12-30' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (39, 14536, 2001920365, 40, CAST(N'2024-12-02' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (40, 14536, 2001920365, 40, CAST(N'2024-12-09' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (41, 14536, 2001920365, 40, CAST(N'2024-12-16' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (42, 14536, 2001920365, 40, CAST(N'2024-12-23' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (43, 14536, 2001920365, 40, CAST(N'2024-12-30' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (44, 14525, 2002040046, 10, CAST(N'2024-12-09' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (45, 14525, 2002040046, 10, CAST(N'2024-12-16' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (46, 14525, 2002040046, 10, CAST(N'2024-12-23' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (47, 14525, 2002040046, 10, CAST(N'2024-12-30' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (48, 14532, 2002040046, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (49, 14532, 2002040046, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (50, 14532, 2002040046, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (51, 14532, 2002040046, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (52, 14532, 2002040046, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (53, 14533, 2002040046, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (54, 14533, 2002040046, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (55, 14533, 2002040046, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (56, 14533, 2002040046, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (57, 14533, 2002040046, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (58, 14534, 2002040046, 10, CAST(N'2024-12-02' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (59, 14534, 2002040046, 10, CAST(N'2024-12-09' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (60, 14534, 2002040046, 10, CAST(N'2024-12-16' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (61, 14534, 2002040046, 10, CAST(N'2024-12-23' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (62, 14534, 2002040046, 10, CAST(N'2024-12-30' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (63, 14523, 3000512342, 10, CAST(N'2024-12-02' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (64, 14523, 3000512342, 10, CAST(N'2024-12-09' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (65, 14523, 3000512342, 10, CAST(N'2024-12-16' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (66, 14523, 3000512342, 10, CAST(N'2024-12-23' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (67, 14523, 3000512342, 10, CAST(N'2024-12-30' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (68, 14525, 3000512342, 10, CAST(N'2024-12-09' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (69, 14525, 3000512342, 10, CAST(N'2024-12-16' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (70, 14525, 3000512342, 10, CAST(N'2024-12-23' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (71, 14525, 3000512342, 10, CAST(N'2024-12-30' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (72, 14527, 3000512342, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (73, 14527, 3000512342, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (74, 14527, 3000512342, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (75, 14527, 3000512342, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (76, 14527, 3000512342, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (77, 14534, 2002059395, 10, CAST(N'2024-12-02' AS Date), CAST(12 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (78, 14534, 2002059395, 10, CAST(N'2024-12-09' AS Date), CAST(12 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (79, 14534, 2002059395, 10, CAST(N'2024-12-16' AS Date), CAST(12 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (80, 14534, 2002059395, 10, CAST(N'2024-12-23' AS Date), CAST(12 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (81, 14534, 2002059395, 10, CAST(N'2024-12-30' AS Date), CAST(12 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (82, 14535, 2002059395, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (83, 14535, 2002059395, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (84, 14535, 2002059395, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (85, 14535, 2002059395, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (86, 14535, 2002059395, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (87, 14536, 2002059395, 10, CAST(N'2024-12-02' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (88, 14536, 2002059395, 10, CAST(N'2024-12-09' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (89, 14536, 2002059395, 10, CAST(N'2024-12-16' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (90, 14536, 2002059395, 10, CAST(N'2024-12-23' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (91, 14536, 2002059395, 10, CAST(N'2024-12-30' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (92, 14537, 2002059395, 10, CAST(N'2024-12-02' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (93, 14537, 2002059395, 10, CAST(N'2024-12-09' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (94, 14537, 2002059395, 10, CAST(N'2024-12-16' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (95, 14537, 2002059395, 10, CAST(N'2024-12-23' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (96, 14537, 2002059395, 10, CAST(N'2024-12-30' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (97, 14530, 2002055111, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (98, 14530, 2002055111, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (99, 14530, 2002055111, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (100, 14530, 2002055111, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (101, 14530, 2002055111, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (102, 14531, 2002055111, 10, CAST(N'2024-12-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (103, 14531, 2002055111, 10, CAST(N'2024-12-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (104, 14531, 2002055111, 10, CAST(N'2024-12-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (105, 14531, 2002055111, 10, CAST(N'2024-12-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (106, 14531, 2002055111, 10, CAST(N'2024-12-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (107, 14537, 2002055111, 10, CAST(N'2024-12-02' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (108, 14537, 2002055111, 10, CAST(N'2024-12-09' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (109, 14537, 2002055111, 10, CAST(N'2024-12-16' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (110, 14537, 2002055111, 10, CAST(N'2024-12-23' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (111, 14537, 2002055111, 10, CAST(N'2024-12-30' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (112, 14523, 2001920365, 10, CAST(N'2025-01-06' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (113, 14523, 2001920365, 10, CAST(N'2025-01-13' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (114, 14523, 2001920365, 10, CAST(N'2025-01-20' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (115, 14523, 2001920365, 10, CAST(N'2025-01-27' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (116, 14523, 2001920365, 10, CAST(N'2025-02-03' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (117, 14523, 2001920365, 10, CAST(N'2025-02-10' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (118, 14523, 2001920365, 10, CAST(N'2025-02-17' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (119, 14523, 2001920365, 10, CAST(N'2025-02-24' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (120, 14523, 2001920365, 10, CAST(N'2025-03-03' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (121, 14523, 2001920365, 10, CAST(N'2025-03-10' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (122, 14523, 2001920365, 10, CAST(N'2025-03-17' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (123, 14523, 2001920365, 10, CAST(N'2025-03-24' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (124, 14523, 2001920365, 10, CAST(N'2025-03-31' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (125, 14523, 2001920365, 10, CAST(N'2025-04-07' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (126, 14523, 2001920365, 10, CAST(N'2025-04-14' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (127, 14523, 2001920365, 10, CAST(N'2025-04-21' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (128, 14523, 2001920365, 10, CAST(N'2025-04-28' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (129, 14523, 2001920365, 10, CAST(N'2025-05-05' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (130, 14523, 2001920365, 10, CAST(N'2025-05-12' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (131, 14523, 2001920365, 10, CAST(N'2025-05-19' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (132, 14523, 2001920365, 10, CAST(N'2025-05-26' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (133, 14523, 2001920365, 10, CAST(N'2025-06-02' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (134, 14523, 2001920365, 10, CAST(N'2025-06-09' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (135, 14523, 2001920365, 10, CAST(N'2025-06-16' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (136, 14523, 2001920365, 10, CAST(N'2025-06-23' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (137, 14523, 2001920365, 10, CAST(N'2025-06-30' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (138, 14523, 2001920365, 10, CAST(N'2025-07-07' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (139, 14523, 2001920365, 10, CAST(N'2025-07-14' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (140, 14523, 2001920365, 10, CAST(N'2025-07-21' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (141, 14523, 2001920365, 10, CAST(N'2025-07-28' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (142, 14523, 2001920365, 10, CAST(N'2025-08-04' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (143, 14523, 2001920365, 10, CAST(N'2025-08-11' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (144, 14523, 2001920365, 10, CAST(N'2025-08-18' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (145, 14523, 2001920365, 10, CAST(N'2025-08-25' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (146, 14523, 2001920365, 10, CAST(N'2025-09-01' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (147, 14523, 2001920365, 10, CAST(N'2025-09-08' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (148, 14523, 2001920365, 10, CAST(N'2025-09-15' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (149, 14523, 2001920365, 10, CAST(N'2025-09-22' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (150, 14523, 2001920365, 10, CAST(N'2025-09-29' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (151, 14523, 2001920365, 10, CAST(N'2025-10-06' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (152, 14523, 2001920365, 10, CAST(N'2025-10-13' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (153, 14523, 2001920365, 10, CAST(N'2025-10-20' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (154, 14523, 2001920365, 10, CAST(N'2025-10-27' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (155, 14523, 2001920365, 10, CAST(N'2025-11-03' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (156, 14523, 2001920365, 10, CAST(N'2025-11-10' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (157, 14523, 2001920365, 10, CAST(N'2025-11-17' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (158, 14523, 2001920365, 10, CAST(N'2025-11-24' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (159, 14523, 2001920365, 10, CAST(N'2025-12-01' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (160, 14523, 2001920365, 10, CAST(N'2025-12-08' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (161, 14523, 2001920365, 10, CAST(N'2025-12-15' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (162, 14523, 2001920365, 10, CAST(N'2025-12-22' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (163, 14523, 2001920365, 10, CAST(N'2025-12-29' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (164, 14524, 2001920365, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (165, 14524, 2001920365, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (166, 14524, 2001920365, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (167, 14524, 2001920365, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (168, 14524, 2001920365, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (169, 14524, 2001920365, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (170, 14524, 2001920365, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (171, 14524, 2001920365, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (172, 14524, 2001920365, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (173, 14524, 2001920365, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (174, 14524, 2001920365, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (175, 14524, 2001920365, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (176, 14524, 2001920365, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (177, 14524, 2001920365, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (178, 14524, 2001920365, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (179, 14524, 2001920365, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (180, 14524, 2001920365, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (181, 14524, 2001920365, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (182, 14524, 2001920365, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (183, 14524, 2001920365, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (184, 14524, 2001920365, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (185, 14524, 2001920365, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (186, 14524, 2001920365, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (187, 14524, 2001920365, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (188, 14524, 2001920365, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (189, 14524, 2001920365, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (190, 14524, 2001920365, 10, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (191, 14524, 2001920365, 10, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (192, 14524, 2001920365, 10, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (193, 14524, 2001920365, 10, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (194, 14524, 2001920365, 10, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (195, 14524, 2001920365, 10, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (196, 14524, 2001920365, 10, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (197, 14524, 2001920365, 10, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (198, 14524, 2001920365, 10, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (199, 14524, 2001920365, 10, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (200, 14524, 2001920365, 10, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (201, 14524, 2001920365, 10, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (202, 14524, 2001920365, 10, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (203, 14524, 2001920365, 10, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (204, 14524, 2001920365, 10, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (205, 14524, 2001920365, 10, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (206, 14524, 2001920365, 10, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (207, 14524, 2001920365, 10, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (208, 14524, 2001920365, 10, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (209, 14524, 2001920365, 10, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (210, 14524, 2001920365, 10, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (211, 14524, 2001920365, 10, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (212, 14524, 2001920365, 10, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (213, 14524, 2001920365, 10, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (214, 14524, 2001920365, 10, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (215, 14524, 2001920365, 10, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (216, 14525, 2001920365, 10, CAST(N'2025-01-06' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (217, 14525, 2001920365, 10, CAST(N'2025-01-13' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (218, 14525, 2001920365, 10, CAST(N'2025-01-20' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (219, 14525, 2001920365, 10, CAST(N'2025-01-27' AS Date), CAST(16 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (220, 14525, 2001920365, 10, CAST(N'2025-02-03' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (221, 14525, 2001920365, 10, CAST(N'2025-02-10' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (222, 14525, 2001920365, 10, CAST(N'2025-02-17' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (223, 14525, 2001920365, 10, CAST(N'2025-02-24' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (224, 14525, 2001920365, 10, CAST(N'2025-03-03' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (225, 14525, 2001920365, 10, CAST(N'2025-03-10' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (226, 14525, 2001920365, 10, CAST(N'2025-03-17' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (227, 14525, 2001920365, 10, CAST(N'2025-03-24' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (228, 14525, 2001920365, 10, CAST(N'2025-03-31' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (229, 14525, 2001920365, 10, CAST(N'2025-04-07' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (230, 14525, 2001920365, 10, CAST(N'2025-04-14' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (231, 14525, 2001920365, 10, CAST(N'2025-04-21' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (232, 14525, 2001920365, 10, CAST(N'2025-04-28' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (233, 14525, 2001920365, 10, CAST(N'2025-05-05' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (234, 14525, 2001920365, 10, CAST(N'2025-05-12' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (235, 14525, 2001920365, 10, CAST(N'2025-05-19' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (236, 14525, 2001920365, 10, CAST(N'2025-05-26' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (237, 14525, 2001920365, 10, CAST(N'2025-06-02' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (238, 14525, 2001920365, 10, CAST(N'2025-06-09' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (239, 14525, 2001920365, 10, CAST(N'2025-06-16' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (240, 14525, 2001920365, 10, CAST(N'2025-06-23' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (241, 14525, 2001920365, 10, CAST(N'2025-06-30' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (242, 14525, 2001920365, 10, CAST(N'2025-07-07' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (243, 14525, 2001920365, 10, CAST(N'2025-07-14' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (244, 14525, 2001920365, 10, CAST(N'2025-07-21' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (245, 14525, 2001920365, 10, CAST(N'2025-07-28' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (246, 14525, 2001920365, 10, CAST(N'2025-08-04' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (247, 14525, 2001920365, 10, CAST(N'2025-08-11' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (248, 14525, 2001920365, 10, CAST(N'2025-08-18' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (249, 14525, 2001920365, 10, CAST(N'2025-08-25' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (250, 14525, 2001920365, 10, CAST(N'2025-09-01' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (251, 14525, 2001920365, 10, CAST(N'2025-09-08' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (252, 14525, 2001920365, 10, CAST(N'2025-09-15' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (253, 14525, 2001920365, 10, CAST(N'2025-09-22' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (254, 14525, 2001920365, 10, CAST(N'2025-09-29' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (255, 14525, 2001920365, 10, CAST(N'2025-10-06' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (256, 14525, 2001920365, 10, CAST(N'2025-10-13' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (257, 14525, 2001920365, 10, CAST(N'2025-10-20' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (258, 14525, 2001920365, 10, CAST(N'2025-10-27' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (259, 14525, 2001920365, 10, CAST(N'2025-11-03' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (260, 14525, 2001920365, 10, CAST(N'2025-11-10' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (261, 14525, 2001920365, 10, CAST(N'2025-11-17' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (262, 14525, 2001920365, 10, CAST(N'2025-11-24' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (263, 14525, 2001920365, 10, CAST(N'2025-12-01' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (264, 14525, 2001920365, 10, CAST(N'2025-12-08' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (265, 14525, 2001920365, 10, CAST(N'2025-12-15' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (266, 14525, 2001920365, 10, CAST(N'2025-12-22' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (267, 14525, 2001920365, 10, CAST(N'2025-12-29' AS Date), CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (268, 14526, 2001920365, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (269, 14526, 2001920365, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (270, 14526, 2001920365, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (271, 14526, 2001920365, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (272, 14526, 2001920365, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (273, 14526, 2001920365, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (274, 14526, 2001920365, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (275, 14526, 2001920365, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (276, 14526, 2001920365, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (277, 14526, 2001920365, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (278, 14526, 2001920365, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (279, 14526, 2001920365, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (280, 14526, 2001920365, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (281, 14526, 2001920365, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (282, 14526, 2001920365, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (283, 14526, 2001920365, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (284, 14526, 2001920365, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (285, 14526, 2001920365, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (286, 14526, 2001920365, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (287, 14526, 2001920365, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (288, 14526, 2001920365, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (289, 14526, 2001920365, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (290, 14526, 2001920365, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (291, 14526, 2001920365, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (292, 14526, 2001920365, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (293, 14526, 2001920365, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (294, 14526, 2001920365, 10, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (295, 14526, 2001920365, 10, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (296, 14526, 2001920365, 10, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (297, 14526, 2001920365, 10, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (298, 14526, 2001920365, 10, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (299, 14526, 2001920365, 10, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (300, 14526, 2001920365, 10, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (301, 14526, 2001920365, 10, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (302, 14526, 2001920365, 10, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (303, 14526, 2001920365, 10, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (304, 14526, 2001920365, 10, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (305, 14526, 2001920365, 10, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (306, 14526, 2001920365, 10, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (307, 14526, 2001920365, 10, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (308, 14526, 2001920365, 10, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (309, 14526, 2001920365, 10, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (310, 14526, 2001920365, 10, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (311, 14526, 2001920365, 10, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (312, 14526, 2001920365, 10, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (313, 14526, 2001920365, 10, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (314, 14526, 2001920365, 10, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (315, 14526, 2001920365, 10, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (316, 14526, 2001920365, 10, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (317, 14526, 2001920365, 10, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (318, 14526, 2001920365, 10, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (319, 14526, 2001920365, 10, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (320, 14528, 2001920365, 20, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (321, 14528, 2001920365, 20, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (322, 14528, 2001920365, 20, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (323, 14528, 2001920365, 20, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (324, 14528, 2001920365, 20, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (325, 14528, 2001920365, 20, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (326, 14528, 2001920365, 20, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (327, 14528, 2001920365, 20, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (328, 14528, 2001920365, 20, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (329, 14528, 2001920365, 20, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (330, 14528, 2001920365, 20, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (331, 14528, 2001920365, 20, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (332, 14528, 2001920365, 20, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (333, 14528, 2001920365, 20, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (334, 14528, 2001920365, 20, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (335, 14528, 2001920365, 20, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (336, 14528, 2001920365, 20, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (337, 14528, 2001920365, 20, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (338, 14528, 2001920365, 20, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (339, 14528, 2001920365, 20, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (340, 14528, 2001920365, 20, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (341, 14528, 2001920365, 20, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (342, 14528, 2001920365, 20, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (343, 14528, 2001920365, 20, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (344, 14528, 2001920365, 20, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (345, 14528, 2001920365, 20, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (346, 14528, 2001920365, 20, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (347, 14528, 2001920365, 20, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (348, 14528, 2001920365, 20, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (349, 14528, 2001920365, 20, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (350, 14528, 2001920365, 20, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (351, 14528, 2001920365, 20, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (352, 14528, 2001920365, 20, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (353, 14528, 2001920365, 20, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (354, 14528, 2001920365, 20, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (355, 14528, 2001920365, 20, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (356, 14528, 2001920365, 20, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (357, 14528, 2001920365, 20, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (358, 14528, 2001920365, 20, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (359, 14528, 2001920365, 20, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (360, 14528, 2001920365, 20, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (361, 14528, 2001920365, 20, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (362, 14528, 2001920365, 20, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (363, 14528, 2001920365, 20, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (364, 14528, 2001920365, 20, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (365, 14528, 2001920365, 20, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (366, 14528, 2001920365, 20, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (367, 14528, 2001920365, 20, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (368, 14528, 2001920365, 20, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (369, 14528, 2001920365, 20, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (370, 14528, 2001920365, 20, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (371, 14528, 2001920365, 20, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (372, 14529, 2001920365, 30, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (373, 14529, 2001920365, 30, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (374, 14529, 2001920365, 30, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (375, 14529, 2001920365, 30, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (376, 14529, 2001920365, 30, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (377, 14529, 2001920365, 30, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (378, 14529, 2001920365, 30, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (379, 14529, 2001920365, 30, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (380, 14529, 2001920365, 30, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (381, 14529, 2001920365, 30, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (382, 14529, 2001920365, 30, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (383, 14529, 2001920365, 30, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (384, 14529, 2001920365, 30, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (385, 14529, 2001920365, 30, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (386, 14529, 2001920365, 30, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (387, 14529, 2001920365, 30, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (388, 14529, 2001920365, 30, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (389, 14529, 2001920365, 30, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (390, 14529, 2001920365, 30, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (391, 14529, 2001920365, 30, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (392, 14529, 2001920365, 30, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (393, 14529, 2001920365, 30, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (394, 14529, 2001920365, 30, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (395, 14529, 2001920365, 30, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (396, 14529, 2001920365, 30, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (397, 14529, 2001920365, 30, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (398, 14529, 2001920365, 30, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (399, 14529, 2001920365, 30, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (400, 14529, 2001920365, 30, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (401, 14529, 2001920365, 30, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (402, 14529, 2001920365, 30, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (403, 14529, 2001920365, 30, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (404, 14529, 2001920365, 30, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (405, 14529, 2001920365, 30, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (406, 14529, 2001920365, 30, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (407, 14529, 2001920365, 30, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (408, 14529, 2001920365, 30, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (409, 14529, 2001920365, 30, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (410, 14529, 2001920365, 30, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (411, 14529, 2001920365, 30, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (412, 14529, 2001920365, 30, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (413, 14529, 2001920365, 30, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (414, 14529, 2001920365, 30, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (415, 14529, 2001920365, 30, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (416, 14529, 2001920365, 30, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (417, 14529, 2001920365, 30, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (418, 14529, 2001920365, 30, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (419, 14529, 2001920365, 30, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (420, 14529, 2001920365, 30, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (421, 14529, 2001920365, 30, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (422, 14529, 2001920365, 30, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (423, 14529, 2001920365, 30, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (424, 14534, 2001920365, 40, CAST(N'2025-01-06' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (425, 14534, 2001920365, 40, CAST(N'2025-01-13' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (426, 14534, 2001920365, 40, CAST(N'2025-01-20' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (427, 14534, 2001920365, 40, CAST(N'2025-01-27' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (428, 14534, 2001920365, 40, CAST(N'2025-02-03' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (429, 14534, 2001920365, 40, CAST(N'2025-02-10' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (430, 14534, 2001920365, 40, CAST(N'2025-02-17' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (431, 14534, 2001920365, 40, CAST(N'2025-02-24' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (432, 14534, 2001920365, 40, CAST(N'2025-03-03' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (433, 14534, 2001920365, 40, CAST(N'2025-03-10' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (434, 14534, 2001920365, 40, CAST(N'2025-03-17' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (435, 14534, 2001920365, 40, CAST(N'2025-03-24' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (436, 14534, 2001920365, 40, CAST(N'2025-03-31' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (437, 14534, 2001920365, 40, CAST(N'2025-04-07' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (438, 14534, 2001920365, 40, CAST(N'2025-04-14' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (439, 14534, 2001920365, 40, CAST(N'2025-04-21' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (440, 14534, 2001920365, 40, CAST(N'2025-04-28' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (441, 14534, 2001920365, 40, CAST(N'2025-05-05' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (442, 14534, 2001920365, 40, CAST(N'2025-05-12' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (443, 14534, 2001920365, 40, CAST(N'2025-05-19' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (444, 14534, 2001920365, 40, CAST(N'2025-05-26' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (445, 14534, 2001920365, 40, CAST(N'2025-06-02' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (446, 14534, 2001920365, 40, CAST(N'2025-06-09' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (447, 14534, 2001920365, 40, CAST(N'2025-06-16' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (448, 14534, 2001920365, 40, CAST(N'2025-06-23' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (449, 14534, 2001920365, 40, CAST(N'2025-06-30' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (450, 14534, 2001920365, 40, CAST(N'2025-07-07' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (451, 14534, 2001920365, 40, CAST(N'2025-07-14' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (452, 14534, 2001920365, 40, CAST(N'2025-07-21' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (453, 14534, 2001920365, 40, CAST(N'2025-07-28' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (454, 14534, 2001920365, 40, CAST(N'2025-08-04' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (455, 14534, 2001920365, 40, CAST(N'2025-08-11' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (456, 14534, 2001920365, 40, CAST(N'2025-08-18' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (457, 14534, 2001920365, 40, CAST(N'2025-08-25' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (458, 14534, 2001920365, 40, CAST(N'2025-09-01' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (459, 14534, 2001920365, 40, CAST(N'2025-09-08' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (460, 14534, 2001920365, 40, CAST(N'2025-09-15' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (461, 14534, 2001920365, 40, CAST(N'2025-09-22' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (462, 14534, 2001920365, 40, CAST(N'2025-09-29' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (463, 14534, 2001920365, 40, CAST(N'2025-10-06' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (464, 14534, 2001920365, 40, CAST(N'2025-10-13' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (465, 14534, 2001920365, 40, CAST(N'2025-10-20' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (466, 14534, 2001920365, 40, CAST(N'2025-10-27' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (467, 14534, 2001920365, 40, CAST(N'2025-11-03' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (468, 14534, 2001920365, 40, CAST(N'2025-11-10' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (469, 14534, 2001920365, 40, CAST(N'2025-11-17' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (470, 14534, 2001920365, 40, CAST(N'2025-11-24' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (471, 14534, 2001920365, 40, CAST(N'2025-12-01' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (472, 14534, 2001920365, 40, CAST(N'2025-12-08' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (473, 14534, 2001920365, 40, CAST(N'2025-12-15' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (474, 14534, 2001920365, 40, CAST(N'2025-12-22' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (475, 14534, 2001920365, 40, CAST(N'2025-12-29' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (476, 14535, 2002040046, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (477, 14535, 2002040046, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (478, 14535, 2002040046, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (479, 14535, 2002040046, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (480, 14535, 2002040046, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (481, 14535, 2002040046, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (482, 14535, 2002040046, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (483, 14535, 2002040046, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (484, 14535, 2002040046, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (485, 14535, 2002040046, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (486, 14535, 2002040046, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (487, 14535, 2002040046, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (488, 14535, 2002040046, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (489, 14535, 2002040046, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (490, 14535, 2002040046, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (491, 14535, 2002040046, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (492, 14535, 2002040046, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (493, 14535, 2002040046, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (494, 14535, 2002040046, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (495, 14535, 2002040046, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (496, 14535, 2002040046, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (497, 14535, 2002040046, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (498, 14535, 2002040046, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (499, 14535, 2002040046, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (500, 14535, 2002040046, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (501, 14535, 2002040046, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (502, 14532, 2002040046, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (503, 14532, 2002040046, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (504, 14532, 2002040046, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (505, 14532, 2002040046, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (506, 14532, 2002040046, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (507, 14532, 2002040046, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (508, 14532, 2002040046, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (509, 14532, 2002040046, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (510, 14532, 2002040046, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (511, 14532, 2002040046, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (512, 14532, 2002040046, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (513, 14532, 2002040046, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (514, 14532, 2002040046, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (515, 14532, 2002040046, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (516, 14532, 2002040046, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (517, 14532, 2002040046, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (518, 14532, 2002040046, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (519, 14532, 2002040046, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (520, 14532, 2002040046, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (521, 14532, 2002040046, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (522, 14532, 2002040046, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (523, 14532, 2002040046, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (524, 14532, 2002040046, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (525, 14532, 2002040046, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (526, 14532, 2002040046, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (527, 14532, 2002040046, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (528, 14536, 2002040046, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (529, 14536, 2002040046, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (530, 14536, 2002040046, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (531, 14536, 2002040046, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (532, 14536, 2002040046, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (533, 14536, 2002040046, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (534, 14536, 2002040046, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (535, 14536, 2002040046, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (536, 14536, 2002040046, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (537, 14536, 2002040046, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (538, 14536, 2002040046, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (539, 14536, 2002040046, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (540, 14536, 2002040046, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (541, 14536, 2002040046, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (542, 14536, 2002040046, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (543, 14536, 2002040046, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (544, 14536, 2002040046, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (545, 14536, 2002040046, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (546, 14536, 2002040046, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (547, 14536, 2002040046, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (548, 14536, 2002040046, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (549, 14536, 2002040046, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (550, 14536, 2002040046, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (551, 14536, 2002040046, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (552, 14536, 2002040046, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (553, 14536, 2002040046, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (554, 14523, 3000512342, 10, CAST(N'2025-01-06' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (555, 14523, 3000512342, 10, CAST(N'2025-01-13' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (556, 14523, 3000512342, 10, CAST(N'2025-01-20' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (557, 14523, 3000512342, 10, CAST(N'2025-01-27' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (558, 14523, 3000512342, 10, CAST(N'2025-02-03' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (559, 14523, 3000512342, 10, CAST(N'2025-02-10' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (560, 14523, 3000512342, 10, CAST(N'2025-02-17' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (561, 14523, 3000512342, 10, CAST(N'2025-02-24' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (562, 14523, 3000512342, 10, CAST(N'2025-03-03' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (563, 14523, 3000512342, 10, CAST(N'2025-03-10' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (564, 14523, 3000512342, 10, CAST(N'2025-03-17' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (565, 14523, 3000512342, 10, CAST(N'2025-03-24' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (566, 14523, 3000512342, 10, CAST(N'2025-03-31' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (567, 14523, 3000512342, 10, CAST(N'2025-04-07' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (568, 14523, 3000512342, 10, CAST(N'2025-04-14' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (569, 14523, 3000512342, 10, CAST(N'2025-04-21' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (570, 14523, 3000512342, 10, CAST(N'2025-04-28' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (571, 14523, 3000512342, 10, CAST(N'2025-05-05' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (572, 14523, 3000512342, 10, CAST(N'2025-05-12' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (573, 14523, 3000512342, 10, CAST(N'2025-05-19' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (574, 14523, 3000512342, 10, CAST(N'2025-05-26' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (575, 14523, 3000512342, 10, CAST(N'2025-06-02' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (576, 14523, 3000512342, 10, CAST(N'2025-06-09' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (577, 14523, 3000512342, 10, CAST(N'2025-06-16' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (578, 14523, 3000512342, 10, CAST(N'2025-06-23' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (579, 14523, 3000512342, 10, CAST(N'2025-06-30' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (580, 14523, 3000512342, 10, CAST(N'2025-07-07' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (581, 14523, 3000512342, 10, CAST(N'2025-07-14' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (582, 14523, 3000512342, 10, CAST(N'2025-07-21' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (583, 14523, 3000512342, 10, CAST(N'2025-07-28' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (584, 14523, 3000512342, 10, CAST(N'2025-08-04' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (585, 14523, 3000512342, 10, CAST(N'2025-08-11' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (586, 14523, 3000512342, 10, CAST(N'2025-08-18' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (587, 14523, 3000512342, 10, CAST(N'2025-08-25' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (588, 14523, 3000512342, 10, CAST(N'2025-09-01' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (589, 14523, 3000512342, 10, CAST(N'2025-09-08' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (590, 14523, 3000512342, 10, CAST(N'2025-09-15' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (591, 14523, 3000512342, 10, CAST(N'2025-09-22' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (592, 14523, 3000512342, 10, CAST(N'2025-09-29' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (593, 14523, 3000512342, 10, CAST(N'2025-10-06' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (594, 14523, 3000512342, 10, CAST(N'2025-10-13' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (595, 14523, 3000512342, 10, CAST(N'2025-10-20' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (596, 14523, 3000512342, 10, CAST(N'2025-10-27' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (597, 14523, 3000512342, 10, CAST(N'2025-11-03' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (598, 14523, 3000512342, 10, CAST(N'2025-11-10' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (599, 14523, 3000512342, 10, CAST(N'2025-11-17' AS Date), CAST(36 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (600, 14523, 3000512342, 10, CAST(N'2025-11-24' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (601, 14523, 3000512342, 10, CAST(N'2025-12-01' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (602, 14523, 3000512342, 10, CAST(N'2025-12-08' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (603, 14523, 3000512342, 10, CAST(N'2025-12-15' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (604, 14523, 3000512342, 10, CAST(N'2025-12-22' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (605, 14523, 3000512342, 10, CAST(N'2025-12-29' AS Date), CAST(36 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (606, 14534, 3000512342, 10, CAST(N'2025-01-06' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (607, 14534, 3000512342, 10, CAST(N'2025-01-13' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (608, 14534, 3000512342, 10, CAST(N'2025-01-20' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (609, 14534, 3000512342, 10, CAST(N'2025-01-27' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (610, 14534, 3000512342, 10, CAST(N'2025-02-03' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (611, 14534, 3000512342, 10, CAST(N'2025-02-10' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (612, 14534, 3000512342, 10, CAST(N'2025-02-17' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (613, 14534, 3000512342, 10, CAST(N'2025-02-24' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (614, 14534, 3000512342, 10, CAST(N'2025-03-03' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (615, 14534, 3000512342, 10, CAST(N'2025-03-10' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (616, 14534, 3000512342, 10, CAST(N'2025-03-17' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (617, 14534, 3000512342, 10, CAST(N'2025-03-24' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (618, 14534, 3000512342, 10, CAST(N'2025-03-31' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (619, 14534, 3000512342, 10, CAST(N'2025-04-07' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (620, 14534, 3000512342, 10, CAST(N'2025-04-14' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (621, 14534, 3000512342, 10, CAST(N'2025-04-21' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (622, 14534, 3000512342, 10, CAST(N'2025-04-28' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (623, 14534, 3000512342, 10, CAST(N'2025-05-05' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (624, 14534, 3000512342, 10, CAST(N'2025-05-12' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (625, 14534, 3000512342, 10, CAST(N'2025-05-19' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (626, 14534, 3000512342, 10, CAST(N'2025-05-26' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (627, 14534, 3000512342, 10, CAST(N'2025-06-02' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (628, 14534, 3000512342, 10, CAST(N'2025-06-09' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (629, 14534, 3000512342, 10, CAST(N'2025-06-16' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (630, 14534, 3000512342, 10, CAST(N'2025-06-23' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (631, 14534, 3000512342, 10, CAST(N'2025-06-30' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (632, 14534, 3000512342, 10, CAST(N'2025-07-07' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (633, 14534, 3000512342, 10, CAST(N'2025-07-14' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (634, 14534, 3000512342, 10, CAST(N'2025-07-21' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (635, 14534, 3000512342, 10, CAST(N'2025-07-28' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (636, 14534, 3000512342, 10, CAST(N'2025-08-04' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (637, 14534, 3000512342, 10, CAST(N'2025-08-11' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (638, 14534, 3000512342, 10, CAST(N'2025-08-18' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (639, 14534, 3000512342, 10, CAST(N'2025-08-25' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (640, 14534, 3000512342, 10, CAST(N'2025-09-01' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (641, 14534, 3000512342, 10, CAST(N'2025-09-08' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (642, 14534, 3000512342, 10, CAST(N'2025-09-15' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (643, 14534, 3000512342, 10, CAST(N'2025-09-22' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (644, 14534, 3000512342, 10, CAST(N'2025-09-29' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (645, 14534, 3000512342, 10, CAST(N'2025-10-06' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (646, 14534, 3000512342, 10, CAST(N'2025-10-13' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (647, 14534, 3000512342, 10, CAST(N'2025-10-20' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (648, 14534, 3000512342, 10, CAST(N'2025-10-27' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (649, 14534, 3000512342, 10, CAST(N'2025-11-03' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (650, 14534, 3000512342, 10, CAST(N'2025-11-10' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (651, 14534, 3000512342, 10, CAST(N'2025-11-17' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (652, 14534, 3000512342, 10, CAST(N'2025-11-24' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (653, 14534, 3000512342, 10, CAST(N'2025-12-01' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (654, 14534, 3000512342, 10, CAST(N'2025-12-08' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (655, 14534, 3000512342, 10, CAST(N'2025-12-15' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (656, 14534, 3000512342, 10, CAST(N'2025-12-22' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (657, 14534, 3000512342, 10, CAST(N'2025-12-29' AS Date), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (658, 14525, 3000512342, 10, CAST(N'2025-01-06' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (659, 14525, 3000512342, 10, CAST(N'2025-01-13' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (660, 14525, 3000512342, 10, CAST(N'2025-01-20' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (661, 14525, 3000512342, 10, CAST(N'2025-01-27' AS Date), CAST(24 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (662, 14525, 3000512342, 10, CAST(N'2025-02-03' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (663, 14525, 3000512342, 10, CAST(N'2025-02-10' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (664, 14525, 3000512342, 10, CAST(N'2025-02-17' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (665, 14525, 3000512342, 10, CAST(N'2025-02-24' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (666, 14525, 3000512342, 10, CAST(N'2025-03-03' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (667, 14525, 3000512342, 10, CAST(N'2025-03-10' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (668, 14525, 3000512342, 10, CAST(N'2025-03-17' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (669, 14525, 3000512342, 10, CAST(N'2025-03-24' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (670, 14525, 3000512342, 10, CAST(N'2025-03-31' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (671, 14525, 3000512342, 10, CAST(N'2025-04-07' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (672, 14525, 3000512342, 10, CAST(N'2025-04-14' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (673, 14525, 3000512342, 10, CAST(N'2025-04-21' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (674, 14525, 3000512342, 10, CAST(N'2025-04-28' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (675, 14525, 3000512342, 10, CAST(N'2025-05-05' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (676, 14525, 3000512342, 10, CAST(N'2025-05-12' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (677, 14525, 3000512342, 10, CAST(N'2025-05-19' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (678, 14525, 3000512342, 10, CAST(N'2025-05-26' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (679, 14525, 3000512342, 10, CAST(N'2025-06-02' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (680, 14525, 3000512342, 10, CAST(N'2025-06-09' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (681, 14525, 3000512342, 10, CAST(N'2025-06-16' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (682, 14525, 3000512342, 10, CAST(N'2025-06-23' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (683, 14525, 3000512342, 10, CAST(N'2025-06-30' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (684, 14525, 3000512342, 10, CAST(N'2025-07-07' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (685, 14525, 3000512342, 10, CAST(N'2025-07-14' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (686, 14525, 3000512342, 10, CAST(N'2025-07-21' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (687, 14525, 3000512342, 10, CAST(N'2025-07-28' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (688, 14525, 3000512342, 10, CAST(N'2025-08-04' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (689, 14525, 3000512342, 10, CAST(N'2025-08-11' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (690, 14525, 3000512342, 10, CAST(N'2025-08-18' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (691, 14525, 3000512342, 10, CAST(N'2025-08-25' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (692, 14525, 3000512342, 10, CAST(N'2025-09-01' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (693, 14525, 3000512342, 10, CAST(N'2025-09-08' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (694, 14525, 3000512342, 10, CAST(N'2025-09-15' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (695, 14525, 3000512342, 10, CAST(N'2025-09-22' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (696, 14525, 3000512342, 10, CAST(N'2025-09-29' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (697, 14525, 3000512342, 10, CAST(N'2025-10-06' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (698, 14525, 3000512342, 10, CAST(N'2025-10-13' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (699, 14525, 3000512342, 10, CAST(N'2025-10-20' AS Date), CAST(30 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (700, 14525, 3000512342, 10, CAST(N'2025-10-27' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (701, 14525, 3000512342, 10, CAST(N'2025-11-03' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (702, 14525, 3000512342, 10, CAST(N'2025-11-10' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (703, 14525, 3000512342, 10, CAST(N'2025-11-17' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (704, 14525, 3000512342, 10, CAST(N'2025-11-24' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (705, 14525, 3000512342, 10, CAST(N'2025-12-01' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (706, 14525, 3000512342, 10, CAST(N'2025-12-08' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (707, 14525, 3000512342, 10, CAST(N'2025-12-15' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (708, 14525, 3000512342, 10, CAST(N'2025-12-22' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (709, 14525, 3000512342, 10, CAST(N'2025-12-29' AS Date), CAST(30 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (710, 14527, 3000512342, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (711, 14527, 3000512342, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (712, 14527, 3000512342, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (713, 14527, 3000512342, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (714, 14527, 3000512342, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (715, 14527, 3000512342, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (716, 14527, 3000512342, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (717, 14527, 3000512342, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (718, 14527, 3000512342, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (719, 14527, 3000512342, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (720, 14527, 3000512342, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (721, 14527, 3000512342, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (722, 14527, 3000512342, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (723, 14527, 3000512342, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (724, 14527, 3000512342, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (725, 14527, 3000512342, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (726, 14527, 3000512342, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (727, 14527, 3000512342, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (728, 14527, 3000512342, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (729, 14527, 3000512342, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (730, 14527, 3000512342, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (731, 14527, 3000512342, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (732, 14527, 3000512342, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (733, 14527, 3000512342, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (734, 14527, 3000512342, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (735, 14527, 3000512342, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (736, 14527, 3000512342, 10, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (737, 14527, 3000512342, 10, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (738, 14527, 3000512342, 10, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (739, 14527, 3000512342, 10, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (740, 14527, 3000512342, 10, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (741, 14527, 3000512342, 10, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (742, 14527, 3000512342, 10, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (743, 14527, 3000512342, 10, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (744, 14527, 3000512342, 10, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (745, 14527, 3000512342, 10, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (746, 14527, 3000512342, 10, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (747, 14527, 3000512342, 10, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (748, 14527, 3000512342, 10, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (749, 14527, 3000512342, 10, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (750, 14527, 3000512342, 10, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (751, 14527, 3000512342, 10, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (752, 14527, 3000512342, 10, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (753, 14527, 3000512342, 10, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (754, 14527, 3000512342, 10, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (755, 14527, 3000512342, 10, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (756, 14527, 3000512342, 10, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (757, 14527, 3000512342, 10, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (758, 14527, 3000512342, 10, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (759, 14527, 3000512342, 10, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (760, 14527, 3000512342, 10, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (761, 14527, 3000512342, 10, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (762, 14530, 2002055111, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (763, 14530, 2002055111, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (764, 14530, 2002055111, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (765, 14530, 2002055111, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (766, 14530, 2002055111, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (767, 14530, 2002055111, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (768, 14530, 2002055111, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (769, 14530, 2002055111, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (770, 14530, 2002055111, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (771, 14530, 2002055111, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (772, 14530, 2002055111, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (773, 14530, 2002055111, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (774, 14530, 2002055111, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (775, 14530, 2002055111, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (776, 14530, 2002055111, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (777, 14530, 2002055111, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (778, 14530, 2002055111, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (779, 14530, 2002055111, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (780, 14530, 2002055111, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (781, 14530, 2002055111, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (782, 14530, 2002055111, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (783, 14530, 2002055111, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (784, 14530, 2002055111, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (785, 14530, 2002055111, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (786, 14530, 2002055111, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (787, 14530, 2002055111, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (788, 14530, 2002055111, 10, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (789, 14530, 2002055111, 10, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (790, 14530, 2002055111, 10, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (791, 14530, 2002055111, 10, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (792, 14530, 2002055111, 10, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (793, 14530, 2002055111, 10, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (794, 14530, 2002055111, 10, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (795, 14530, 2002055111, 10, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (796, 14530, 2002055111, 10, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (797, 14530, 2002055111, 10, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (798, 14530, 2002055111, 10, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (799, 14530, 2002055111, 10, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (800, 14530, 2002055111, 10, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (801, 14530, 2002055111, 10, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (802, 14530, 2002055111, 10, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (803, 14530, 2002055111, 10, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (804, 14530, 2002055111, 10, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (805, 14530, 2002055111, 10, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (806, 14530, 2002055111, 10, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (807, 14530, 2002055111, 10, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (808, 14530, 2002055111, 10, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (809, 14530, 2002055111, 10, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (810, 14530, 2002055111, 10, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (811, 14530, 2002055111, 10, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (812, 14530, 2002055111, 10, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (813, 14530, 2002055111, 10, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (814, 14531, 2002055111, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (815, 14531, 2002055111, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (816, 14531, 2002055111, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (817, 14531, 2002055111, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (818, 14531, 2002055111, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (819, 14531, 2002055111, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (820, 14531, 2002055111, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (821, 14531, 2002055111, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (822, 14531, 2002055111, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (823, 14531, 2002055111, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (824, 14531, 2002055111, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (825, 14531, 2002055111, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (826, 14531, 2002055111, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (827, 14531, 2002055111, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (828, 14531, 2002055111, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (829, 14531, 2002055111, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (830, 14531, 2002055111, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (831, 14531, 2002055111, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (832, 14531, 2002055111, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (833, 14531, 2002055111, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (834, 14531, 2002055111, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (835, 14531, 2002055111, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (836, 14531, 2002055111, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (837, 14531, 2002055111, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (838, 14531, 2002055111, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (839, 14531, 2002055111, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (840, 14531, 2002055111, 10, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (841, 14531, 2002055111, 10, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (842, 14531, 2002055111, 10, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (843, 14531, 2002055111, 10, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (844, 14531, 2002055111, 10, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (845, 14531, 2002055111, 10, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (846, 14531, 2002055111, 10, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (847, 14531, 2002055111, 10, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (848, 14531, 2002055111, 10, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (849, 14531, 2002055111, 10, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (850, 14531, 2002055111, 10, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (851, 14531, 2002055111, 10, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (852, 14531, 2002055111, 10, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (853, 14531, 2002055111, 10, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (854, 14531, 2002055111, 10, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (855, 14531, 2002055111, 10, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (856, 14531, 2002055111, 10, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (857, 14531, 2002055111, 10, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (858, 14531, 2002055111, 10, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (859, 14531, 2002055111, 10, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (860, 14531, 2002055111, 10, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (861, 14531, 2002055111, 10, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (862, 14531, 2002055111, 10, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (863, 14531, 2002055111, 10, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (864, 14531, 2002055111, 10, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (865, 14531, 2002055111, 10, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (866, 14537, 2002055111, 10, CAST(N'2025-01-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (867, 14537, 2002055111, 10, CAST(N'2025-01-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (868, 14537, 2002055111, 10, CAST(N'2025-01-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (869, 14537, 2002055111, 10, CAST(N'2025-01-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (870, 14537, 2002055111, 10, CAST(N'2025-02-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (871, 14537, 2002055111, 10, CAST(N'2025-02-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (872, 14537, 2002055111, 10, CAST(N'2025-02-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (873, 14537, 2002055111, 10, CAST(N'2025-02-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (874, 14537, 2002055111, 10, CAST(N'2025-03-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (875, 14537, 2002055111, 10, CAST(N'2025-03-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (876, 14537, 2002055111, 10, CAST(N'2025-03-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (877, 14537, 2002055111, 10, CAST(N'2025-03-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (878, 14537, 2002055111, 10, CAST(N'2025-03-31' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (879, 14537, 2002055111, 10, CAST(N'2025-04-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (880, 14537, 2002055111, 10, CAST(N'2025-04-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (881, 14537, 2002055111, 10, CAST(N'2025-04-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (882, 14537, 2002055111, 10, CAST(N'2025-04-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (883, 14537, 2002055111, 10, CAST(N'2025-05-05' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (884, 14537, 2002055111, 10, CAST(N'2025-05-12' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (885, 14537, 2002055111, 10, CAST(N'2025-05-19' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (886, 14537, 2002055111, 10, CAST(N'2025-05-26' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (887, 14537, 2002055111, 10, CAST(N'2025-06-02' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (888, 14537, 2002055111, 10, CAST(N'2025-06-09' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (889, 14537, 2002055111, 10, CAST(N'2025-06-16' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (890, 14537, 2002055111, 10, CAST(N'2025-06-23' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (891, 14537, 2002055111, 10, CAST(N'2025-06-30' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (892, 14537, 2002055111, 10, CAST(N'2025-07-07' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (893, 14537, 2002055111, 10, CAST(N'2025-07-14' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (894, 14537, 2002055111, 10, CAST(N'2025-07-21' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (895, 14537, 2002055111, 10, CAST(N'2025-07-28' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (896, 14537, 2002055111, 10, CAST(N'2025-08-04' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (897, 14537, 2002055111, 10, CAST(N'2025-08-11' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (898, 14537, 2002055111, 10, CAST(N'2025-08-18' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (899, 14537, 2002055111, 10, CAST(N'2025-08-25' AS Date), CAST(40 AS Decimal(18, 0)))
GO
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (900, 14537, 2002055111, 10, CAST(N'2025-09-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (901, 14537, 2002055111, 10, CAST(N'2025-09-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (902, 14537, 2002055111, 10, CAST(N'2025-09-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (903, 14537, 2002055111, 10, CAST(N'2025-09-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (904, 14537, 2002055111, 10, CAST(N'2025-09-29' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (905, 14537, 2002055111, 10, CAST(N'2025-10-06' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (906, 14537, 2002055111, 10, CAST(N'2025-10-13' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (907, 14537, 2002055111, 10, CAST(N'2025-10-20' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (908, 14537, 2002055111, 10, CAST(N'2025-10-27' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (909, 14537, 2002055111, 10, CAST(N'2025-11-03' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (910, 14537, 2002055111, 10, CAST(N'2025-11-10' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (911, 14537, 2002055111, 10, CAST(N'2025-11-17' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (912, 14537, 2002055111, 10, CAST(N'2025-11-24' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (913, 14537, 2002055111, 10, CAST(N'2025-12-01' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (914, 14537, 2002055111, 10, CAST(N'2025-12-08' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (915, 14537, 2002055111, 10, CAST(N'2025-12-15' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (916, 14537, 2002055111, 10, CAST(N'2025-12-22' AS Date), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[staffing] ([id], [personnel_no], [eng_no], [eng_phase], [week_start_date], [planned_hours]) VALUES (917, 14537, 2002055111, 10, CAST(N'2025-12-29' AS Date), CAST(40 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[staffing] OFF
GO
SET IDENTITY_INSERT [dbo].[timesheets] ON 

INSERT [dbo].[timesheets] ([id], [personnel_no], [eng_no], [eng_phase], [work_date], [hours], [time_entry_date], [posting_date], [charge_out_rate], [std_price], [adm_surcharge]) VALUES (1, 14537, 2002055111, 10, CAST(N'2024-12-06' AS Date), CAST(4 AS Decimal(18, 0)), CAST(N'2024-12-06' AS Date), CAST(N'2024-12-06' AS Date), CAST(388 AS Decimal(18, 0)), CAST(1552 AS Decimal(18, 0)), CAST(23 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[timesheets] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [clients_index_2]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [clients_index_2] ON [dbo].[clients]
(
	[client_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [employees_index_0]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [employees_index_0] ON [dbo].[employees]
(
	[staff_level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [employees_index_1]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [employees_index_1] ON [dbo].[employees]
(
	[staff_level] ASC,
	[is_external] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [engagements_index_3]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [engagements_index_3] ON [dbo].[engagements]
(
	[client_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [engagements_index_4]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [engagements_index_4] ON [dbo].[engagements]
(
	[eng_description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [phases_index_5]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [phases_index_5] ON [dbo].[phases]
(
	[budget] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [staffing_index_6]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [staffing_index_6] ON [dbo].[staffing]
(
	[personnel_no] ASC,
	[week_start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [staffing_index_7]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [staffing_index_7] ON [dbo].[staffing]
(
	[eng_no] ASC,
	[eng_phase] ASC,
	[week_start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [staffing_index_8]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [staffing_index_8] ON [dbo].[staffing]
(
	[week_start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [staffing_index_9]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [staffing_index_9] ON [dbo].[staffing]
(
	[eng_no] ASC,
	[week_start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [timesheets_index_10]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [timesheets_index_10] ON [dbo].[timesheets]
(
	[work_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [timesheets_index_11]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [timesheets_index_11] ON [dbo].[timesheets]
(
	[personnel_no] ASC,
	[work_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [timesheets_index_12]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [timesheets_index_12] ON [dbo].[timesheets]
(
	[eng_no] ASC,
	[eng_phase] ASC,
	[work_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [timesheets_index_13]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [timesheets_index_13] ON [dbo].[timesheets]
(
	[posting_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [timesheets_index_14]    Script Date: 2025-03-26 11:29:41 AM ******/
CREATE NONCLUSTERED INDEX [timesheets_index_14] ON [dbo].[timesheets]
(
	[eng_no] ASC,
	[work_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[engagements]  WITH CHECK ADD FOREIGN KEY([client_no])
REFERENCES [dbo].[clients] ([client_no])
GO
ALTER TABLE [dbo].[phases]  WITH CHECK ADD FOREIGN KEY([eng_no])
REFERENCES [dbo].[engagements] ([eng_no])
GO
ALTER TABLE [dbo].[staffing]  WITH CHECK ADD FOREIGN KEY([eng_no], [eng_phase])
REFERENCES [dbo].[phases] ([eng_no], [eng_phase])
GO
ALTER TABLE [dbo].[staffing]  WITH CHECK ADD FOREIGN KEY([personnel_no])
REFERENCES [dbo].[employees] ([personnel_no])
GO
ALTER TABLE [dbo].[timesheets]  WITH CHECK ADD FOREIGN KEY([personnel_no])
REFERENCES [dbo].[employees] ([personnel_no])
GO
ALTER TABLE [dbo].[timesheets]  WITH CHECK ADD FOREIGN KEY([eng_no], [eng_phase])
REFERENCES [dbo].[phases] ([eng_no], [eng_phase])
GO
EXEC sys.sp_addextendedproperty @name=N'Column_Description', @value=N'First Monday of the week, e.g. 2025-01-06' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'staffing', @level2type=N'COLUMN',@level2name=N'week_start_date'
GO
USE [master]
GO
ALTER DATABASE [KPMG_Data_Challenge] SET  READ_WRITE 
GO
