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

- **Data Analysis**: Python (for regression, interpolation, and advanced analytics)
- **Data Storage**: SQL database (enabling complex queries and data relationships)
- **Visualization**: Power BI (for interactive dashboards)
- **Integration**: API connections to existing systems

### Database Approach

We've implemented a dedicated database setup because:

1. Power BI lacks advanced inference capabilities (interpolation, regression, etc.)
2. Complex consultant allocation optimization requires relational data structures
3. Historical performance tracking necessitates persistent storage
4. Future scalability depends on proper data architecture

## 📊 Report Components

### Critical Assumptions

- **CPI = 1 as Target Scenario**

  - Justification: A CPI of 1 represents the ideal scenario for KPMG, where actual costs align perfectly with earned value
  - Impact: Maximizes KPMG profitability (no dilution of charge-out rates) while delivering client value
  - Mathematical implication: Using $\text{CPI} = \frac{\text{EV}}{\text{AC}} = 1$ allows us to back-calculate project timelines
- **Project Timeline Inference**

  - Justification: Missing critical project start/end dates in the dataset required mathematical inference
  - Impact: Using CPI = 1 as anchor, we can derive reasonable timeline estimates via back-calculation
  - Mathematical approach: $\text{Timeline}_{\text{est}} = \frac{\text{BAC}}{\text{Average Daily Billable Value}}$

### Supporting Assumptions

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

Our optimization algorithm requires a relational database that models:

1. Consultants ($C$) with attributes: ID, level, hourly rate, skills, availability
2. Projects ($P$) with attributes: ID, client, BAC, start date, end date, phases
3. Assignments ($A$) where $A \subseteq C \times P \times \text{DateRange}$
4. Billing records ($B$) with attributes: consultant, project, hours, date, rate

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

## Implementation Notes

For production deployment, this solution would require:

1. Integration with KPMG's existing employee database
2. Connection to project management systems
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