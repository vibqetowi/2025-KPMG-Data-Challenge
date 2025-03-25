[![EN](https://img.shields.io/badge/🇨🇦-English-red.svg)](README.md)

# KPMG Data Challenge - Team 7: Project Management Analysis

<div align="center">

[![Python](https://img.shields.io/badge/Python-3.9%20or%20higher-blue?style=for-the-badge&logo=python)](https://www.python.org/)
[![PowerBI](https://img.shields.io/badge/Power%20BI-Data%20Visualization-yellow?style=for-the-badge&logo=powerbi)](https://powerbi.microsoft.com/)
[![SQL](https://img.shields.io/badge/SQL-Database%20Queries-orange?style=for-the-badge&logo=microsoftsqlserver)](https://www.microsoft.com/sql-server)
[![Excel](https://img.shields.io/badge/Excel-Data%20Analysis-green?style=for-the-badge&logo=microsoftexcel)](https://www.microsoft.com/excel)

</div>

## 🏆 Team 7

| Team Member | Role |
|-------------|------|
| Member 1 | Data Analyst |
| Member 2 | Project Management Specialist |
| Member 3 | Financial Analyst |

## 🎯 Project Overview

Team 7's submission to the KPMG case challenge, analyzing project management data. Our solution provides insights into project performance metrics through earned value management (EVM) analysis, helping stakeholders understand project health and make data-driven decisions despite incomplete dataset challenges.

### Platform Showcase

![Dashboard Preview](./img/dashboard.png)

## 🌟 Key Features

- Earned Value Management (EVM) metrics calculation
- Project performance visualization
- Resource allocation analysis
- Schedule and cost variance tracking
- Predictive project completion forecasting

## 🏗️ Architecture

### Technology Stack

- **Data Analysis**: Python, Excel
- **Data Storage**: SQL 
- **Visualization**: Power BI
- **Reporting**: Excel, Power BI

## 📊 Report Components

### Key Assumptions

- The ratio of hours worked by staff tier on a mandate is fairly consistent across time
    - Impact: allows us to make projections and inferences for instance calculating a better average charge-out rate by using weights instead of simple average

- Hours required to complete a phase ≈ $\text{BAC} / \text{average charge-out rate}$ of assigned personnel.
  - Justification: Since $\text{BAC} = \sum_{i=1}^{n} \text{Hours}_i \times \text{Rate}_i$ (sum of each assignee's hours × their rate), this provides a reasonable estimate.
  - Impact: Enables estimation of project duration and end date when combined with start date.

- Project phases complete at a linear rate over time.
  - Impact: Allows calculation of planned value (PV) at any point in time.

- Employees at the same level are interchangeable.
  - Impact: Allows assignment flexibility based on project needs without efficiency loss.

- Project starts on the date of the first billing of the phase.
  - Impact: Establishes the mandate start date (not provided in original data).

- Phase duration ≈ estimated man-hours / number of people.
  - Impact: Enables estimation of actual durations.

- All projects have equal importance.
  - Justification: No indication otherwise.
  - Impact: Optimization focuses on full assignment rather than prioritization.

### Key Metrics Derivation

#### Budget at Completion (BAC)
- **Formula**: $\text{BAC} = \sum_{i=1}^{n} \text{Hours}_i \times \text{Rate}_i$
- **Purpose**: Total budgeted value of the project

#### Actual Cost (AC)
- **Formula**: $\text{AC} = \sum_{i=1}^{n} \text{StandardPrice}_i + \sum_{i=1}^{n} \text{AdminFees}_i$
- **Purpose**: Measures actual expenditure to date

#### Planned Value (PV)
- **Formula**: $\text{PV} = \text{BAC} \times \frac{\text{Days elapsed}}{\text{Total estimated duration in days}}$
- **Purpose**: Measures expected project value based on time elapsed
- **Assumption**: Linear progress over time

#### Estimated Project Completion (%)
- **Formula**: $\text{Completion%} = \frac{\sum_{i=1}^{n} \text{Hours billed}_i}{\text{Total estimated hours}}$

#### Earned Value (EV)
- **Formula**: $\text{EV} = \text{BAC} \times \text{Completion%}$
- **Purpose**: Measures actual value delivered based on work completed

#### Cost Performance Index (CPI)
- **Formula**: $\text{CPI} = \frac{\text{EV}}{\text{AC}}$
- **Purpose**: Efficiency measure of cost utilization ($>1$ is good)

#### Schedule Performance Index (SPI)
- **Formula**: $\text{SPI} = \frac{\text{EV}}{\text{PV}}$
- **Purpose**: Efficiency measure of schedule performance ($>1$ is good)

## 🚀 Getting Started

```bash
# Clone repository
git clone [repository-url]

# Install Python dependencies
pip install -r requirements.txt

# Open Power BI dashboard
open ./dashboards/project_performance.pbix
```

## Calculation Methodology

1. **Hours Required to Complete Project**:
   - Formula: $\text{Hours}_{\text{required}} = \frac{\text{BAC}}{\text{Avg. charge-out rate}}$

2. **Total Estimated Duration (days)**:
   - Formula: $\text{Duration}_{\text{est}} = \frac{\text{Hours}_{\text{required}}}{\text{Number of employees} \times 24}$

3. **Days Elapsed**:
   - Formula: $\text{Days}_{\text{elapsed}} = \text{Current date} - \text{Start date}$

4. **Percentage Schedule Elapsed**:
   - Formula: $\text{Schedule%} = \frac{\text{Days}_{\text{elapsed}}}{\text{Duration}_{\text{est}}}$

5. **Estimated % Completion (in hours)**:
   - Formula: $\text{Completion%} = \frac{\text{Hours billed}}{\text{Hours}_{\text{required}}}$

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

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

*Built for the KPMG Data Challenge 2025*

</div>
