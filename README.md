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

Team 7 is pleased to present its submission for the KPMG case challenge, focusing on **consulting assignment optimization**. Our solution is a production-ready dashboard designed to implement earned value management (EVM) principles to optimize consultant allocation across projects. This approach is intended to maximize billable hours and enhance overall project performance through data-driven decision-making.

This dashboard is specifically engineered to address critical business needs prevalent in consulting firms:

- Optimizing consultant utilization
- Minimizing consultant bench time
- Maintaining project schedules effectively
- Maximizing profitability through efficient resource allocation

### Platform Showcase

![Dashboard Preview](./img/dashboard.png)

## 🌟 Key Features

- Earned Value Management (EVM) metrics calculation
- Consultant allocation optimization algorithm
- Project performance visualization for clear insights
- Resource utilization tracking for efficiency management
- Schedule and cost variance monitoring to maintain project control
- Predictive project completion forecasting for proactive planning

## 🏗️ Architecture

### Technology Stack

- **Data Analysis**: Python, chosen for its capabilities in regression, interpolation, and advanced analytics. For demonstration purposes, a Python backend is utilized, acknowledging potential variations in KPMG's production stack.
- **Data Storage**: SQL Server database, employing TSQL to ensure direct compatibility with KPMG's assumed internal database stack, specifically Azure SQL.
- **Visualization**: Power BI, selected for its robust interactive dashboard capabilities.
- **Integration**: Integration with existing systems, particularly Salesforce, will require consultation with KPMG's Salesforce integrator to ensure seamless connectivity.

### Database Approach

A dedicated database setup is essential and has been implemented to address the following critical requirements:

1. **Advanced Analytics**: Power BI's native capabilities are insufficient for the advanced analytical methods required, such as interpolation and regression.
2. **Complex Optimization**: Consultant allocation optimization necessitates relational data structures to manage the complexity of assignments and project dependencies.
3. **Historical Tracking**: Persistent data storage is crucial for historical performance tracking and trend analysis over time.
4. **Scalability**: A well-architected database provides the necessary foundation for future scalability and expansion of the system.

#### Data Model

An interactive Entity Relationship Diagram (ERD) detailing the database structure is available [here](https://dbdiagram.io/d/67e2d56c75d75cc8446be7ea). A static version is also provided below for convenience:
![ERD](./Documentation/ERD.svg)

The defined ERD structure is implemented in our database and serves as the foundational data model for the Power BI reporting layer.

#### Salesforce Integration and SQL Implementation

- KPMG's current infrastructure utilizes Salesforce as the primary CRM and project tracking system.
- The provided dataset, while obfuscated, is representative of data extracted from their Salesforce environment via a connector.
- Our solution is designed under the assumption that KPMG has access to Azure SQL or MS SQL Server licenses for their enterprise data warehouse solution.
- The database schema is intentionally designed to ensure compatibility with Salesforce's data structure, facilitating a streamlined and efficient integration process.

## 📊 Report Components

### Critical Assumptions

1) CPI = 0.98

   - Justification: This Cost Performance Index (CPI) target is derived from the standard project management practice of maintaining a 10% contingency in enterprise consulting, factoring in the expectation of high efficiency and budget adherence among KPMG associates. A CPI of 1.0 would represent maximum value extraction without any chargeout dilution.
   - Impact: A CPI of 0.98 is chosen to strike a balance between ensuring project profitability and maintaining realistic project planning.
   - Implementation Note:  In the context of professional services and knowledge-based work, objectively measuring project completion for Earned Value Management (EVM) is inherently challenging. Therefore, adopting a fixed CPI provides a pragmatic and consistently applicable performance benchmark, more suitable for professional services than attempting to impose metrics designed for manufacturing environments.
2) Project Timeline Inference

   - Justification: As explicit project start and end dates are not provided in the dataset, project timelines are inferred mathematically using available data points to enable schedule-related calculations.
   - Impact: Project timelines are inferred to enable schedule-related calculations.

### Supporting Assumptions

1) Hours required to complete a phase

   - Justification: The estimated hours needed to complete a project phase are derived from the Budget at Completion (BAC) and the weighted average charge-out rate, factoring in historical staffing distributions to ensure accuracy.
   - Impact: Deriving hours from BAC and charge-out rate ensures accuracy in estimated hours.
2) Phase duration derived from staff count

   - Justification: Phase duration is estimated by considering the required hours and the number of personnel assigned to the phase. This approach allows for more accurate estimation of project end dates by accounting for resource allocation.
   - Impact: Estimating phase duration based on staff count leads to more accurate project end date estimations.
3) Phase staffing distribution remains consistent

   - Justification: Analysis of 2024-2025 staffing data reveals consistent ratios in staff levels across different engagement phases, enabling reliable predictive capacity planning and resource forecasting.
   - Impact: Consistent staffing distribution enables reliable predictive capacity planning and resource forecasting.
4) Project phases progress linearly

   - Justification:  A linear progression of project phases is assumed over time. This assumption simplifies the calculation of Planned Value (PV) at any given point during the project lifecycle.
   - Impact: Linear phase progression simplifies Planned Value (PV) calculation.
5) Project starts on first billing date

   - Justification: The project start date is consistently defined as the date of the first billing for the project. This establishes a uniform reference point for all timeline calculations across projects.
   - Impact: Defining start date by first billing provides a uniform reference for timeline calculations.
6) Client identity determined by client number

   - Justification: Client identity is standardized and determined by the client number. This approach ensures that entities with the same client number are treated as the same client, even if variations exist in client names (e.g., Company X and Company Y with the same client number are considered a single client).
   - Impact: Standardizing client identity by number ensures consistent client handling.
7) The ratio of hours worked by staff tier on a mandate is fairly consistent over time

   - Impact: This consistency enables the application of weighted averages for calculations such as charge-out rates, improving the accuracy of financial metrics and projections.
8) Project phases complete at a linear rate over time

   - Impact: Assuming linear project phase completion allows for straightforward calculation of Planned Value (PV) at any point in time, facilitating schedule performance analysis.
9) Employees at the same level are interchangeable

   - Impact: Interchangeability of employees at the same level provides resource assignment flexibility, allowing for optimal allocation based on project needs without compromising efficiency.
10) Project starts on the date of the first logged working day of the phase

    - Impact: Establishing the mandate start date from the first billing addresses the absence of explicit start dates in the original dataset, providing a consistent basis for project timeline management.
11) All projects have equal importance

    - Justification: In the absence of specific prioritization criteria, all projects are assumed to be of equal importance for optimization purposes.
    - Impact: With no differentiated project priorities, the optimization process focuses on maximizing overall resource assignment and utilization across the project portfolio.
12) Due to discrepancies between staffing and timesheets, staffing data will be prioritized

    - Justification: Staffing data contains a client ID number that is absent in the 'TIME' dataset, which appears to be specific to Company Y.
    - Impact: To maintain data integrity and consistency, client ID numbers in the 'TIME' dataset for Client Y are assumed to be erroneous and will be replaced with the corresponding values from the staffing data.
13) Negative hours logged offset hours on other projects for the same client

    - Justification: Data analysis indicates a pattern where negative hour entries for a consultant are associated with work on other mandates for the same client.
    - Impact: While this assumption is made based on observed data patterns, the validity and full implications remain uncertain and require further investigation.
14) Client identity is determined by client number rather than name

    - Justification: In database design, client numbers serve as primary keys, providing a more reliable and consistent identifier than client names, which can be subject to variation.
    - Impact: Standardizing client identity based on client numbers allows for consistent client handling across the system. For example, Company X and Company Y with the same client number are treated as a single client entity.
15) Differential Time Reporting Behaviors Between Internal and External Consultants

    - Justification: Analysis of timesheet submission patterns revealed significant delays from some senior managers, with entries submitted up to 55+ days late. This pattern aligns with observations that internal consultants (who receive regular salaries regardless of timely reporting) may have fewer immediate incentives for prompt time entry compared to external consultants whose compensation depends directly on reported hours.
    - Impact: This behavioral difference creates potential data integrity issues for real-time project tracking and resource allocation. The database structure includes a designation field to accommodate this distinction for implementation purposes.

## Optimization Challenge

Given the constraints and assumptions outlined, the optimization problem we address is formally defined as:

$$
\max_{A} \sum_{p \in P} \text{SPI}_p \cdot w_p
$$

Subject to the following constraints:

- SPI > 0.8 for all projects (maintaining acceptable schedule performance)
- Consultant benching < 20% (ensuring efficient utilization of consultant time)
- $\forall c \in C, \sum_{p \in P} \text{Hours}_{c,p,w} \leq 40, \forall w \in \text{Weeks}$ (adhering to weekly consultant capacity limits)

Where $w_p$ represents the relative importance or priority of project $p$.

- Consultant Availability Extrapolation:  A consultant's availability for the upcoming week is projected based on their staffing availability trends over the preceding three weeks, allowing for dynamic resource allocation.

### Key Metrics Derivation

#### Budget at Completion (BAC)

- **Source**: Directly sourced from the `Budget.csv` dataset, specified for each project phase.
- **Purpose**: Represents the total authorized budget allocated for a given engagement phase, serving as the financial baseline.

#### Weighted Average Chargeout Rate

- **Formula**: $\text{Weighted Chargeout Rate} = \sum_{i=1}^{n} \text{Chargeout}_{i} \times \frac{\text{Hours}_{i}}{\sum_{j=1}^{n} \text{Hours}_{j}}$
- **Purpose**: Calculates a realistic average chargeout rate for a project phase by weighting individual chargeout rates by the proportion of hours worked by each employee, thereby accurately reflecting the staffing mix.
- **Note**: This rate is used to convert budget amounts into estimated hours and to calculate overall project duration.
- **Variables**:  $i$ represents each individual employee assigned to the project phase.

#### Hours Required to Complete Project

- **Formula**: $\text{Hours}_{\text{required}} = \frac{\text{BAC}}{\text{Weighted charge-out rate}}$
- **Purpose**: Determines the total estimated effort, in hours, required to fully deliver the project, based on the budget and the weighted average cost of resources.

#### Total Estimated Duration

- **Formula**: $\text{Duration}_{\text{est}} = \frac{\text{Hours}_{\text{required}}}{\text{Number of employees assigned} \times \text{hours per workday}}$
- **Note**: This calculation incorporates the number of employees assigned and standard workday hours to provide a realistic estimate of project timelines.
- **Purpose**: Establishes a baseline for measuring schedule performance and for project planning purposes.

#### Days Elapsed

- **Formula**: $\text{Days}_{\text{elapsed}} = \text{Current date} - \text{Start date}$
- **Purpose**: Measures the actual progression of the project timeline from the start date to the current date.

#### Percentage Schedule Elapsed

- **Formula**: $\text{Schedule%} = \frac{\text{Days}_{\text{elapsed}}}{\text{Duration}_{\text{est}}}$
- **Purpose**: Standardizes the measurement of schedule progress, allowing for comparison across projects regardless of their duration.


#### Actual Cost (AC)

- **Formula**: $\text{AC} = \sum_{i=1}^{n} \text{StandardPrice}_i + \sum_{i=1}^{n} \text{AdminFees}_i$
- **Purpose**: Calculates the total actual expenditure incurred to date, derived from timesheet entries including standard prices and administrative fees.
- **Note**: Calculated on a weekly basis to align with staffing allocation and performance review cycles.

#### Planned Value (PV)

- **Formula**: $\text{PV} = \text{BAC} \times \frac{\text{Weeks elapsed}}{\text{Total estimated duration in weeks}}$
- **Purpose**: Measures the expected value of work that should have been completed by a specific point in time, based on the project budget and schedule.


#### Earned Value (EV)

- **Formula**: $\text{EV} = \text{AC} \times \text{CPI}$
- **Purpose**: Represents the actual value of work completed, adjusted by the Cost Performance Index (CPI) to reflect efficiency and cost-effectiveness.
- **Note**: With a fixed CPI assumption of 0.98, Earned Value is effectively Actual Cost discounted by 2%, reflecting an expected level of efficiency.


#### Cost Performance Index (CPI)

- **Value**: Fixed at 0.98 by assumption.

#### Schedule Performance Index (SPI)

- **Formula**: $\text{SPI} = \frac{\text{EV}}{\text{PV}}$
- **Purpose**:  Quantifies schedule efficiency by comparing Earned Value to Planned Value. An SPI greater than 1 indicates the project is ahead of schedule, while values less than 1 suggest delays.
- **Application**: Used as a key metric for weekly resource reallocation decisions, enabling proactive schedule management.

#### Weekly Utilization Rate (Capacity Based)

- **Formula**: $\text{Capacity Utilization} = \frac{\text{Actual billable hours}}{\text{Available capacity hours}} \times 100\%$
- **Description**: Assumes a standard weekly capacity of 40 hours for each employee. Capacity Utilization measures the percentage of this 40-hour capacity that is utilized for billable work, focusing on overall resource usage against potential capacity.
- **Target**: Set at >80% for optimal resource efficiency, ensuring consultants are effectively engaged in billable activities.
- **Purpose**: To monitor and optimize the deployment of consultants' available working hours towards billable projects, maximizing capacity utilization.

#### Assignment Realization Rate (Billed vs. Assigned)

- **Formula**: $\text{Assignment Realization Rate} = \frac{\text{Actual billable hours}}{\text{Assigned project hours}} \times 100\%$
- **Description**: This metric compares actual billable hours logged against the hours initially assigned to a consultant for specific projects. It reflects the effectiveness with which consultants convert assigned project workload into billable time.
- **Purpose**: To track the efficiency of converting assigned project hours into actual billable hours. A lower rate may indicate inefficiencies, over-assignment, or time spent on non-billable tasks within assigned projects, while a higher rate suggests efficient execution of assigned tasks. This metric is distinct from overall capacity utilization and focuses on project-specific workload realization.

## Dashboard Improvement Opportunities

The current dashboard is presented as a proof-of-concept, developed based on the constraints of the available data. To enhance its functionality and practical applicability, the following key improvements are recommended:

1. **Integration of Actual Project Timelines**: The most significant limitation is the absence of actual project start and end dates. Currently, timelines are inferred based on CPI assumptions. Integrating real-world timeline data would significantly enhance the model's accuracy and shift the optimization from theoretical to practical application.
2. **Historical Performance Data Incorporation**: Including historical consultant performance data, categorized by project type and complexity, would enable more nuanced and effective resource allocation based on individual expertise and past performance.
3. **Skills Taxonomy Implementation**: The development and integration of a structured skills database would allow for precise matching of consultant skills to project requirements, optimizing project staffing and improving project outcomes.
4. **Client Priorities Integration**: Incorporating client significance and strategic priorities into the optimization model would allow for weighted optimization, ensuring that strategic client relationships and high-priority projects are given appropriate resource allocation.
5. **Real-time System Integration**: Establishing real-time data integration with KPMG's timesheet and project management systems would enable dynamic resource reallocation in response to real-time project status changes and resource availability, making the system more responsive and adaptive.

It is important to note that without accurate timeline data, the current solution serves primarily as a demonstration of the proposed methodology rather than a fully operational system. However, the underlying principles and methodological approach remain robust and applicable for future development.

## 🚀 Getting Started

```bash
# Clone repository
git clone [repository-url]

# Install Python dependencies
pip install -r requirements.txt

# Connect to SQL database using appropriate methods

# Open Power BI dashboard
open ./dashboards/project_performance.pbix
```

## Implementation Notes

For production deployment within KPMG, the following implementation steps are essential:

1. **Salesforce System Integration**: Establish robust integration with KPMG's existing Salesforce system using API connectors to ensure seamless data flow and system interoperability.
2. **Database Schema Deployment**: Implement the defined database schema within KPMG's Azure SQL or MS SQL Server environment to establish the necessary data infrastructure.
3. **Data Refresh Scheduling**: Establish a regular data refresh schedule, ideally daily, to ensure the dashboard and optimization algorithms operate with up-to-date information.
4. **User Access Control Implementation**: Implement user access controls that align with KPMG's organizational structure to ensure data security and appropriate system access levels.
5. **Automated Alert System**: Develop and deploy automated alerts that trigger when project Schedule Performance Index (SPI) falls below predefined thresholds, enabling proactive intervention and project management.

## 📈 Performance Metrics

For a sample project with code ending 365, phase 000010, the following performance metrics are observed:

- Budget at completion (BAC): \$2.3M
- SPI: \[Value calculated]
- Estimated completion date: \[Date calculated]

## 🛣️ Future Developments

### Roadmap Overview

- Implement more sophisticated resource allocation algorithms to enhance optimization accuracy and efficiency.
- Enhance data collection methodologies to ensure more accurate and granular project progress tracking and data inputs.
- Develop automated reporting capabilities to streamline performance monitoring and stakeholder communication.
- Integrate real-time project monitoring features to enable dynamic adjustments and proactive project management.

 *Built for the KPMG Data Challenge 2025*

## Appendix 1: AI Usage

For the development of this project, ChatGPT (free version) and GitHub Copilot were utilized as valuable tools for research assistance, content generation, and code development support.

## Appendix 2: Questions to Organisers
