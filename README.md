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

- A charge-out rate indicates percentage completion, though quality variations exist between employees.
  - Justification: Different employees may produce varying quality output, so a dollar billed doesn't always represent the same project advancement.
  - Impact: Affects how we measure actual project progress.

- Hours required to complete a phase ≈ BAC / average charge-out rate of assigned personnel.
  - Justification: Since BAC equals the sum of each assignee's hours × their rate, this provides a reasonable estimate.
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

- Going forward, we assume the CPI is 1, we optimize for an SPI of 1
  Based on this assumption, the goal of this dashboard is to allocate employee resources to obtain an SPI of 1.

- Any negative hours logged to a given mandate is used to offset hours recorded on another project billed to the same client, as they had the goal of respecting certain billing caps or requirements. By looking at the data, we see that anytime there is a consultant billing negative hours, that consultant worked on other mandates for the same client. We cannot verify the validity of this assumption or the possible implications.


  - In the case that the client name of the same client number changes, we assume that the client is the same, despite the change in name. One person has done a database course and trusts the importance of primary keys. For instance, Company X and Y have the same client number, so we assume both these entities to be the same client. Impact: we can change all the client names to Company X.

  - People are not late to enter their hours, the entered date and posting date will remain the same. Timely time-sheet filing is key to successful project management. This avoids the need to interpolate hours logged. 

### Key Metrics Derivation

#### Actual Cost (AC)
- **Formula**: Sum of standard price + sum of admin fees
- **Purpose**: Measures actual expenditure to date

#### Planned Value (PV)
- **Formula**: BAC × (Days elapsed / Total estimated duration in days)
- **Purpose**: Measures expected project value based on time elapsed
- **Assumption**: Linear progress over time

#### Earned Value (EV)
- **Formula**: BAC × Estimated % completion (in hours)
- **Purpose**: Measures actual value delivered based on work completed

#### Cost Performance Index (CPI)
- **Formula**: EV / AC
- **Purpose**: Efficiency measure of cost utilization (>1 is good)

#### Schedule Performance Index (SPI)
- **Formula**: EV / PV
- **Purpose**: Efficiency measure of schedule performance (>1 is good)

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
   - Formula: BAC / Average charge-out rate

2. **Total Estimated Duration (days)**:
   - Formula: Hours required / number of employees / 24

3. **Days Elapsed**:
   - Formula: Current date - Start date

4. **Percentage Schedule Elapsed**:
   - Formula: Days elapsed / Total estimated duration

5. **Estimated % Completion (in hours)**:
   - Formula: Hours billed / Total estimated average FTE hours to bill

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
