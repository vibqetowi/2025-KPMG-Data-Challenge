# KPMG Case - Team 7: Consulting Assignment Optimization Dashboard

<div align="center">

[![Python](https://img.shields.io/badge/Python-3.9%20or%20higher-blue?style=for-the-badge&logo=python)](https://www.python.org/)
[![PowerBI](https://img.shields.io/badge/Power%20BI-Data%20Visualization-yellow?style=for-the-badge&logo=powerbi)](https://powerbi.microsoft.com/)
[![SQL](https://img.shields.io/badge/SQL-Database%20Queries-orange?style=for-the-badge&logo=microsoftsqlserver)](https://www.microsoft.com/sql-server)
[![Excel](https://img.shields.io/badge/Excel-Data%20Analysis-green?style=for-the-badge&logo=microsoftexcel)](https://www.microsoft.com/excel)

</div>

## 🏆 Team 7

| Team Member | github                        |
| ----------- | ----------------------------- |
| Member 1    | @vibqetowi                    |
| Member 2    | Project Management Specialist |
| Member 3    | Financial Analyst             |

## 🎯 Project Overview

Team 7's submission to the KPMG case challenge, focusing on **consulting assignment optimization**. Our solution provides a production-ready dashboard that leverages earned value management (EVM) principles to optimize consultant allocation across projects, maximize billable hours, and improve project performance through data-driven decision making.

This dashboard addresses critical business needs for consulting firms:

- Optimizing consultant utilization
- Reducing bench time
- Ensuring projects remain on schedule
- Maximizing profitability through efficient resource allocation

### Platform Showcase

![Dashboard Preview](./img/dashboard.png)

## 🌟 Key Features

- Earned Value Management (EVM) metrics calculation
- Consultant allocation optimization algorithm
- Project performance visualization
- Resource utilization tracking
- Schedule and cost variance monitoring
- Predictive project completion forecasting

## 🏗️ Architecture

### Technology Stack

- **Data Analysis**: Python (for regression, interpolation, and advanced analytics) we'll do a python backedn for demo cuz we cdont know the prod stack sadly
- **Data Storage**: SQL Server database, uses TSQL which is directly compatible with assumed internal KPMG database stack (Azure SQL)
- **Visualization**: Power BI (for interactive dashboards)
- **Integration**: please ask your salesforce integrator

### Database Approach

We've implemented a dedicated database setup because:

1. Power BI lacks advanced inference capabilities (interpolation, regression, etc.)
2. Complex consultant allocation optimization requires relational data structures
3. Historical performance tracking necessitates persistent storage
4. Future scalability depends on proper data architecture

#### Data Model

Interactive version of our ERD (Entity Relationship Diagram) [here](https://dbdiagram.io/d/67e2d56c75d75cc8446be7ea)
Static version here:
![ERD](./Documentation/ERD.svg)

this will be reflected in our db and the basis of the pbi report

#### Salesforce Integration and SQL Implementation

- KPMG currently uses Salesforce as their primary CRM and project tracking system
- The dataset provided is a representation of the output of their Salesforce connector though obfuscated
- Our solution assumes KPMG has access to Azure SQL or MS SQL Server licenses for the data warehouse
- Our database schema is designed to be compatible with Salesforce data structure for seamless integration

## 📊 Report Components

### Critical Assumptions

- **CPI = 0.98 as Target Scenario**

  - Derivation: Based on standard project management contingency of 10% at enterprise consulting firms, with KPMG associates assumed to be highly efficient and rarely exceeding budgets
  - Impact: Near-optimal balance between profitability and realistic planning
- **Project Timeline Inference**

  - Derivation: Missing critical project start/end dates require mathematical inference from available data
  - Calculation: $\text{Timeline}_{\text{est}} = \frac{\text{BAC} \times 0.98}{\text{Average Daily Billable Value}}$

### Supporting Assumptions

- **Hours required to complete a phase**

  - Formula: $\text{Hours}_{\text{required}} \approx \frac{\text{BAC}}{\text{weighted charge-out rate}}$ where weight is based on historical staffing distribution
- **Phase duration derived from staff count**

  - Formula: $\text{Duration}_{\text{days}} = \frac{\text{Hours}_{\text{required}}}{\text{Number of people assigned to phase}} \times \frac{1}{\text{hours per day}}$
  - Impact: Enables more accurate estimation of project end dates by accounting for team size
- **Phase staffing distribution remains consistent**

  - Evidence: Analysis of 2024-2025 staffing data shows consistent ratios of staff levels per engagement phase
  - Enables predictive capacity planning and accurate resource forecasting
- **Project phases progress linearly**

  - Enables calculation of planned value (PV) at any point: $\text{PV} = \text{BAC} \times \frac{\text{Days elapsed}}{\text{Total estimated duration}}$
- **Project starts on first billing date**

  - Establishes consistent start date reference point for all timeline calculations
- **Client identity determined by client number**

  - Standardizes client identification where Company X and Y with same client numbers are treated as same entity
- **The ratio of hours worked by staff tier on a mandate is fairly consistent across time**
  - Impact: Allows us to make projections and inferences for instance calculating a better average charge-out rate by using weights instead of simple average

- **Hours required to complete a phase ≈ $\text{BAC} / \text{average charge-out rate}$ of assigned personnel**
  - Justification: Since $\text{BAC} = \sum_{i=1}^{n} \text{Hours}_i \times \text{Rate}_i$ (sum of each assignee's hours × their rate), this provides a reasonable estimate.
  - Impact: Enables estimation of project duration and end date when combined with start date.

- **Project phases complete at a linear rate over time**
  - Impact: Allows calculation of planned value (PV) at any point in time.

- **Employees at the same level are interchangeable**
  - Impact: Allows assignment flexibility based on project needs without efficiency loss.

- **Project starts on the date of the first billing of the phase**
  - Impact: Establishes the mandate start date (not provided in original data).

- **Phase duration ≈ estimated man-hours / number of people**
  - Impact: Enables estimation of actual durations.

- **All projects have equal importance**
  - Justification: No indication otherwise.
  - Impact: Optimization focuses on full assignment rather than prioritization.

- **Due to dicrepancy between staffing and time sheets we will default to staffing**
  - Justification: Staffing contains a client ID number that is not present in 'TIME', which seems to be company Y's identifier.
  - Impact: We will assume that the client ID numbers in 'TIME' for cleint Y are erroneous and replace them with the value from staffing.

- **Negative hours logged offset hours on other projects for the same client**
  - Justification: By looking at the data, we see that anytime there is a consultant billing negative hours, that consultant worked on other mandates for the same client.
  - Impact: We cannot verify the validity of this assumption or the possible implications.

- **Client identity is determined by client number rather than name**
  - Justification: One person has done a database course and trusts the importance of primary keys.
  - Impact: We can standardize client names (e.g., Company X and Y with the same client number are treated as the same client).

- **Hours are entered in a timely manner**
  - Justification: Timely time-sheet filing is key to successful project management.
  - Impact: 

### Database Schema Requirements

Our optimization algorithm requires a relational database that matches our ERD structure:

1. **employees**: Personnel information with personnel_no as primary key

   - Maps to consultants with their staff level
2. **clients**: Client data with client_no as primary key

   - Stores client information for all engagements
3. **engagements**: Project metadata with eng_no as primary key

   - Captures high-level project information
4. **phases**: Project phases with composite key (eng_no, eng_phase)

   - Contains budget and description for each project phase
5. **staffing**: Weekly allocation plans with unique constraints

   - Captures planned hours for each employee-phase combination per week
   - Core of the weekly capacity planning system
6. **timesheets**: Actual time entries with billing details

   - Contains actual hours, rates, and financial data
   - Source for actual cost and earned value calculations

This schema directly corresponds to our data warehouse implementation and allows for the complex queries needed for EVM calculations and resource optimization.

## Optimization Challenge

Given the constraints and assumptions, our optimization problem is formulated as:

$$
\max_{A} \sum_{p \in P} \text{SPI}_p \cdot w_p
$$

Subject to:

- SPI > 0.8 for all projects (schedule performance)
- Consultant benching < 20% (utilization efficiency)
- $\forall c \in C, \sum_{p \in P} \text{Hours}_{c,p,d} \leq 8, \forall d \in \text{Days}$ (daily capacity)

Where $w_p$ represents the relative importance of project $p$.

- We extrapolate a person's next week availability based on their prior three week's of staffing availability.

### Key Metrics Derivation

#### Budget at Completion (BAC)

- **Source**: Provided directly in Budget.csv for each phase
- **Purpose**: Represents the total authorized budget for the engagement phase

#### Weighted Average Chargeout Rate

- **Formula**: $\text{Weighted Chargeout Rate} = \sum_{i=1}^{n} \text{Chargeout}_{i} \times \frac{\text{Hours}_{i}}{\sum_{j=1}^{n} \text{Hours}_{j}}$
- **Purpose**: Provides realistic average rate accounting for staffing mix on phase
- **Note**: Used for converting budget to hours and calculating project duration
- **Variables**: $i$ represents each employee assigned to the phase

#### Hours Required to Complete Project

- **Formula**: $\text{Hours}_{\text{required}} = \frac{\text{BAC}}{\text{Weighted charge-out rate}}$
- **Purpose**: Establishes total effort required to deliver project

#### Total Estimated Duration

- **Formula**: $\text{Duration}_{\text{est}} = \frac{\text{Hours}_{\text{required}}}{\text{Number of employees assigned} \times \text{hours per workday}}$
- **Note**: Accounts for team size to provide realistic timeline estimates
- **Purpose**: Provides baseline for schedule performance measurement

#### Days Elapsed

- **Formula**: $\text{Days}_{\text{elapsed}} = \text{Current date} - \text{Start date}$
- **Purpose**: Measures actual timeline progress

#### Percentage Schedule Elapsed

- **Formula**: $\text{Schedule%} = \frac{\text{Days}_{\text{elapsed}}}{\text{Duration}_{\text{est}}}$
- **Purpose**: Standardizes schedule progress for comparison

#### Estimated % Completion

- **Formula**: $\text{Completion%} = \frac{\text{Hours billed}}{\text{Hours}_{\text{required}}}$
- **Purpose**: Measures actual work completed as proportion of total

#### Actual Cost (AC)

- **Formula**: $\text{AC} = \sum_{i=1}^{n} \text{StandardPrice}_i + \sum_{i=1}^{n} \text{AdminFees}_i$
- **Purpose**: Measures actual expenditure to date from timesheet entries
- **Note**: Calculated weekly to align with staffing allocation periods

#### Planned Value (PV)

- **Formula**: $\text{PV} = \text{BAC} \times \frac{\text{Weeks elapsed}}{\text{Total estimated duration in weeks}}$
- **Purpose**: Measures expected project value based on time elapsed
- **Assumption**: Linear progress over time with weekly measurement intervals

#### Earned Value (EV)

- **Formula**: $\text{EV} = \text{AC} \times \text{CPI}$
- **Purpose**: Measures actual value delivered based on work completed
- **Note**: With our fixed CPI assumption of 0.98, this represents a 2% efficiency target

#### Cost Performance Index (CPI)

- **Value**: Fixed at 0.98 based on industry benchmarks
- **Justification**: Derived from standard 10% contingency with KPMG efficiency factor
- **Purpose**: Converts actual costs to earned value

#### Schedule Performance Index (SPI)

- **Formula**: $\text{SPI} = \frac{\text{EV}}{\text{PV}}$
- **Purpose**: Measures schedule efficiency (values >1 indicate ahead of schedule)
- **Application**: Used for resource reallocation decisions on a weekly basis

#### Weekly Utilization Rate

- **Formula**: $\text{Utilization} = \frac{\text{Actual billable hours}}{\text{Available hours}} \times 100\%$
- **Target**: >80% for optimal resource efficiency
- **Purpose**: Key factor in consultant assignment optimization

## Dashboard Improvement Opportunities

The current dashboard represents a proof-of-concept based on available data. Critical improvements would include:

1. **Actual Project Timelines**: The most significant limitation is the lack of actual project start/end dates, requiring us to use inferred timelines based on CPI assumptions. With real timeline data, the optimization would move from theoretical to practical.
2. **Historical Performance Data**: Adding historical consultant performance by project type would enable more nuanced allocation based on expertise.
3. **Skills Taxonomy**: A structured skills database would allow matching consultants to projects based on required expertise.
4. **Client Priorities**: Incorporating client significance/priority would allow weighted optimization that respects strategic client relationships.
5. **Real-time Integration**: Connecting with timesheet and project management systems would enable dynamic reallocation as conditions change.

Without accurate timeline data, the current solution represents a case presentation demonstration rather than a fully operational system, though the methodology remains valid.

## 🚀 Getting Started

```bash
# Clone repository
git clone [repository-url]

# Install Python dependencies
pip install -r requirements.txt

# Connect to SQL databasee using appropriate methods

# Open Power BI dashboard
open ./dashboards/project_performance.pbix
```

## Implementation Notes

For production deployment, this solution would require:

1. Integration with KPMG's existing Salesforce system via API connectors
2. Implementation of the database schema in Azure SQL or MS SQL Server
3. Regular data refresh scheduling (recommended: daily)
4. User access controls aligned with organizational structure
5. Automated alerts when projects fall below SPI thresholds

## 📈 Performance Metrics

For a project with code ending 365, phase 000010:

- Budget at completion (BAC): $2.3M
- CPI: [Value calculated]
- SPI: [Value calculated]
- Estimated completion date: [Date calculated]

## 🛣️ Future Developments

### Roadmap Overview

- Implement more sophisticated resource allocation algorithms
- Enhance data collection methodology for more accurate progress tracking
- Develop automated reporting capabilities
- Integrate real-time project monitoring features

 *Built for the KPMG Data Challenge 2025*

## Appendix 1: AI Usage

Used ChatGPT free and github copilot for research help, writing help and code help

## Appendix 2: Questions to organisers
