# KPMG Case - Team 7: Consulting Assignment Optimization Dashboard

<div align="center">

[![Python](https://img.shields.io/badge/Python-3.9%20or%20higher-blue?style=for-the-badge&logo=python)](https://www.python.org/)
[![PowerBI](https://img.shields.io/badge/Power%20BI-Data%20Visualization-yellow?style=for-the-badge&logo=powerbi)](https://powerbi.microsoft.com/)
[![T-SQL](https://img.shields.io/badge/SQL-Database%20Queries-orange?style=for-the-badge&logo=microsoftsqlserver)](https://www.microsoft.com/sql-server)
[![Excel](https://img.shields.io/badge/Excel-Data%20Analysis-green?style=for-the-badge&logo=microsoftexcel)](https://www.microsoft.com/excel)

</div>

## 🏆 Team 7

| Team Member | GitHub     | Background                                                                               |
| ----------- | ---------- | ---------------------------------------------------------------------------------------- |
| Minh        | @vibqetowi | Software Engineering, previous experience in software development and project management |
| Carter      | @carterj-c | Mechanical Engineering, previous experience in aerospace engineering                     |
| Casey       | @cassius   | Finance & accounting, previous experience in financial modeling and research             |
| Romero      | @geekpapi  | Economics & Computer Science, previous experience in data analysis                       |

## 🎯 Project Overview

Team 7 is pleased to present its submission for the KPMG case challenge, focusing on **consulting assignment optimization**. While our backgrounds are primarily in engineering, economics, project management, and finance rather than consulting, we've leveraged our technical expertise and project coordination experience to develop a solution that addresses resource allocation challenges common to professional services organizations. Our solution is a production-ready dashboard designed to implement earned value management (EVM) principles to optimize resource allocation across projects.

This dashboard is specifically engineered to address critical business needs prevalent in project-based organizations:

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
- Vacation tracking and integration to prevent resource allocation conflicts and ensure realistic capacity planning

## 💼 Business Objectives and Optimization Targets

Our solution focuses on key business metrics that drive profitability and efficiency in consulting organizations:

### Value Extraction Coefficient (VEC)

Consulting firms face a unique challenge: maximizing both budget utilization and maintaining target chargeout rates. Traditional project management metrics don't adequately capture this dual objective. Our Value Extraction Coefficient (VEC) provides executives with a clear measure of financial performance that addresses both dimensions:

$$
\text{VEC} = \left(\frac{\text{AC}}{\text{BAC}}\right) \times \sum_{i=1}^{n} w_i \times d_i \times ea_j \times eo_j
$$

Where:

- $w_i$ is the financial weight of transaction $i$ where $w_i = \left(\frac{\text{AC}_i}{\text{AC}}\right)$
- $d_i$ is the chargeout rate ratio for transaction $i$ where $`d_i = 1 - \frac{\text{Chargeout}_i}{\text{StandardChargeout}_{j}}`$ (≤ 1) * $`Chargeout_i`$ is the  chargout for transaction i and $StandardChargeout_j$ is the normal chargeout for consultant j on this engagment
- $ea_j$ is profit adjustment for external consultants (assumed 10% lower) where $ea_j = 0.9 \times \text{isExternal}_j$ ($isExternal$ being a boolean with values 1 or 0)
- $eo_j$ is the profit adjustment for first year consultants (20 lower according to case files) where $eo_j = 0.8 \times \text{isNew}_j$ ($isNew$ being a boolean with values 1 or 0)

This metric identifies engagements where value extraction is impacted by:

1. Discounted chargeout rates ($d_i ≤ 1$)
2. External consultant inefficiencies ($ea_j = 0.9$ for externals)
3. New consultant onboarding costs ($eo_j = 0.8$ for new hires)

Each factor represents the percentage of value retained after applying that particular discount or efficiency loss. By multiplying these factors, we calculate the compound effect of multiple efficiency reductions.

### Resource Optimization

Our solution addresses the core optimization challenge facing consulting organizations:

$$
\max_{A} \sum_{p \in P} w_p \times r_p \times (\alpha \times \text{SPI}_p + \beta \times \text{VEC}_p) - \sum_{c\in C, p \in P, w \in W}\text{pse} \times \text{is\_switch}_{c,p,w}
$$

Where $A$ represents the assignment matrix of consultants to projects (i.e., which consultants work on which projects and for how many hours). The optimization seeks to find the best possible allocation of consultant resources across all projects that maximizes the objective function.

Subject to critical business constraints:

- SPI > 0.85 for all projects (preventing schedule slippage)
- VEC > 0.85 for all projects (ensuring adequate value extraction)
- Consultant benching < 20% (maximizing billable utilization)
- $\forall c \in C, \sum_{p \in P} \text{Hours}_{c,p,w} \leq 40, \forall w \in \text{Weeks}$ (maintaining work-life balance)
- $\forall l \in L, \forall pr \in PR, \frac{\sum_{c \in C_{l,pr}} \text{Hours}_{c,p,w}}{\sum_{c \in C} \text{Hours}_{c,p,w}} = r_{l,pr,p}, \forall p \in P, \forall w \in \text{Weeks}$ (maintaining appropriate staffing ratios)
- $\sum_{p \in P} \text{Hours}_{c_{ext},p,w} > 0 \implies \sum_{p \in P} \text{Hours}_{c_{int},p,w} = 40, \forall c_{int} \in C_{int}, \forall c_{ext} \in C_{ext}, \forall w \in \text{Weeks}$ (prioritizing internal consultants before external consultants)

Where:

- $w_p$ represents the strategic value weight of project $p$ (higher values for strategically important clients or projects)
- $r_p$ is the delivery risk coefficient for project $p$, reflecting complexity and criticality
- $\alpha, \beta$ are weighting coefficients for balancing schedule performance and value extraction
- $\text{pse}$ is the project switching efficiency factor (≤ 1) that accounts for productivity loss when consultants switch projects
- $\text{is\_switch}_{c,p,w}$ is a binary variable indicating whether consultant $c$ is newly assigned to project $p$ in week $w$
- $L$ is the set of staff levels
- $PR$ is the set of practice areas
- $C_{l,pr}$ is the subset of consultants at level $l$ from practice area $pr$
- $C_{int}$ is the subset of internal consultants
- $C_{ext}$ is the subset of external consultants
- $r_{l,pr,p}$ is the target ratio of hours for level $l$ and practice $pr$ in project $p$

The staffing ratio constraint ensures that each project maintains the required mix of different staff levels and practice areas, which is critical for proper project delivery. This optimization balances:

1. Schedule performance (SPI) to ensure timely project delivery
2. Value extraction (VEC) to maximize financial performance
3. Strategic project importance through project-specific weights ($w_p$)
4. Delivery risk through the risk coefficient ($r_p$)
5. Efficiency considerations in consultant reassignments through the project switching efficiency factor

While maintaining appropriate staffing ratios by level and practice area for each project and prioritizing the utilization of internal resources before external consultants.

### Key Performance Indicators (KPIs)

Due to these business objectives, our solution focuses on four key performance indicators that enable managers to proactively monitor and manage resource allocation and engagement profitability:

1. **VEC (rolling)**: Value Extraction Coefficient measured on a rolling basis to identify trends in maintaining target rates without excessive discounting
2. **SPI (rolling)**: Schedule Performance Index tracked on a rolling basis to monitor project delivery efficiency
3. **Benching Rate (internal/external)**: Weekly rolling ratio of work basis/ assigned hours on staffing. Separated between internal and external

- Enhanced client satisfaction through consistently meeting deadlines
- Better work-life balance through realistic capacity planning

## 🏗️ Architecture

![solution_architecture](./Documentation/solution_architecture.png)

### Technology Stack

- **Data Analysis**: Python, chosen for quick prototyping abilities when uncertain about KPMG tech stack.
- **Data Storage**: SQL Server database, employing TSQL to ensure direct compatibility with KPMG's assumed internal database stack, specifically Azure SQL.
- **Visualization**: Power BI, selected for compatibility with KPMG tools.
- **Integration**:  For reference, a sample pipeline script (`/scripts/pipeline/pipeline.py`) demonstrates the process of extracting data from Salesforce, transforming it, and loading it into the SQL database. While this provides a starting framework, we strongly recommend working with your Salesforce integration specialists to adapt this to your specific environment and security requirements.

### Database Approach

A dedicated database setup is essential and has been implemented to address the following critical requirements:

1. **Advanced Analytics**: Power BI's native capabilities are insufficient for the advanced analytical methods required, such as interpolation and regression.
2. **Complex Optimization**: Consultant allocation optimization necessitates relational data structures to manage the complexity of assignments and project dependencies.
3. **Historical Tracking**: Persistent data storage is crucial for historical performance tracking and trend analysis over time.
4. **Scalability**: A well-architected database provides the necessary foundation for future scalability and expansion of the system.

#### Data Model

An interactive Entity Relationship Diagram (ERD) detailing the database structure is available [here](https://dbdiagram.io/d/67e2d56c75d75cc8446be7ea). A static version is also provided below for convenience:
![ERD](./Documentation/ERD.svg)

The defined ERD structure is implemented in our database and serves as the foundational data model for the Power BI reporting layer. Our data model includes explicit timeline tracking with start and end dates for both engagements and phases, enabling accurate project timeline analysis and performance tracking without relying on inferred dates.

#### Vacation Tracking Integration

Our solution incorporates a dedicated vacation tracking system, which addresses a significant pain point in resource management. Through our experience in project management and engineering environments, we've observed that capacity planning often fails when resource managers are unaware of planned time off until it's too late to adjust assignments properly.

Key aspects of our vacation tracking implementation:

- Dedicated `vacations` table in the database to store employee time-off periods
- Integration with capacity planning calculations to automatically adjust available hours
- Visual indicators in the dashboard highlighting vacation conflicts with planned assignments
- Proactive alerts for resource managers when upcoming vacations affect staffing plans

While the current implementation uses synthetic vacation data (as this information wasn't available in the original dataset), the system is designed to integrate with HR systems that track approved time off. This integration helps avoid the common scenario where projects are planned and staffed without accounting for known absences, leading to missed deadlines and last-minute resource scrambling - a challenge we've personally encountered in engineering and project-based work environments.

## 🛣️ Production Deployment and Dashboard Improvements Suggestions

For this proof-of-concept, several data elements were synthesized or derived to demonstrate the full capabilities of our solution. In a production environment, these would be replaced with actual data from KPMG's systems, significantly enhancing the accuracy and applicability of the dashboard.

### Synthetic Elements and Production Replacements

| Challenge Implementation                                                    | Production Replacement                         | Benefit                                                                     |
| --------------------------------------------------------------------------- | ---------------------------------------------- | --------------------------------------------------------------------------- |
| **Vacation Schedules**: Generated synthetic time-off periods          | Integration with HR/PTO systems                | Accurate capacity planning accounting for approved leave                    |
| **Internal/External Classification**: Derived from timesheet patterns | Direct data from HR systems                    | Precise resource categorization for costing and availability                |
| **Employment Basis**: Standardized 40-hour work week                  | Actual contracted hours per resource           | More accurate capacity calculations for part-time and flexible arrangements |
| **Project Timelines**: Inferred from billing data                     | Actual project start/end dates from Salesforce | Precise schedule performance measurement                                    |
| **Practice Areas**: Set to 'SAP'                                      | Actual department/practice assignments         | Better matching of consultants to appropriate projects                      |

## 📝 Implementation Notes

For production deployment within KPMG, we recommend the following implementation steps based on our experience with similar technical systems in engineering and project environments:

1. **Salesforce System Integration**: Establish robust integration with KPMG's existing Salesforce system using API connectors to ensure seamless data flow and system interoperability.
2. **Database Schema Deployment**: Implement the defined database schema within KPMG's Azure SQL or MS SQL Server environment to establish the necessary data infrastructure.
3. **Data Refresh Scheduling**: Establish a regular data refresh schedule, ideally daily, to ensure the dashboard and optimization algorithms operate with up-to-date information.
4. **User Access Control Implementation**: Implement user access controls that align with KPMG's organizational structure to ensure data security and appropriate system access levels.
5. **Automated Alert System**: Develop and deploy automated alerts that trigger when project Schedule Performance Index (SPI) falls below predefined thresholds, enabling proactive intervention and project management.

### Dashboard Enhancement Roadmap

Building on the proof-of-concept dashboard, we recommend the following enhancements for production deployment:

1. **Historical Performance Metrics**: Incorporating historical consultant performance data categorized by project type would enable more nuanced resource allocation based on proven expertise and past results.
2. **Skills Taxonomy**: Developing a structured skills database would allow precise matching of consultant capabilities to project requirements, optimizing staffing decisions beyond the current level-based approach.
3. **Client Priority Weighting**: Implementing a client significance factor would enable weighted optimization, ensuring strategic client relationships receive appropriate resourcing priority.
4. **Value Extraction Analytics**: Implement deeper analytics around the Value Extraction Coefficient (VEC), allowing practice leaders to identify patterns in which types of engagements, clients, or practice areas maintain the highest coefficient. This would provide actionable insights for improving overall firm profitability.
5. **Chargeout Discount Monitoring**: Add visualization components that track chargeout discounts by client, engagement type, and staff level. This would help identify where rate pressure is occurring and inform pricing strategies and resource allocation decisions.

By replacing synthetic data with actual operational data and implementing these enhancements, the system would evolve from a powerful proof-of-concept to an essential operational tool for KPMG's resource management.

## 📊 Report Components

### Critical Assumptions

1) CPI = 0.98

   - Justification: This Cost Performance Index (CPI) value is derived from our knowledge of Project Management practices (contingency of 10%) as well as assumed efficiency of the KPMG workforce.
   - Impact: A CPI of 0.98 is chosen to allow backwards estimations of project timelines, as stated however, it should be replaced by real project timelie data and VEC calculations in production.

### Supporting Assumptions

1. Phase duration derived from staff count

   - Impact: Phase duration is estimated by considering the required hours and the number of personnel assigned to the phase. This approach allows estimation of project end dates by accounting for resource allocation.

3) Phase staffing distribution remains consistent

   - Justification: Analysis of sample data reveals consistent ratios in staff levels across different engagement phases.
   - Impact: Consistent staffing distribution enables reliable weighted average chargeout calculations.
4) Project phases progress linearly

   - Impact: Linear phase progression simplifies Planned Value (PV) calculation.
5) Project starts on first logged work date.

   - Impact: Defining start date this ways allows estimation of timeline in absence of production data.
6) Client identity determined by client number

   - Justification: In database practice, it is resonable to trust keys when in doubt.
   - Impact: Standardizing client identity by number ensures consistent client handling.
7) Employees at the same level and practice are interchangeable without compromising efficiency ($pse = 1$).

   - Impact: Simplifies our calculations for cross project assignments, this will not reflect in production but is hard to estimate without more metrics.
8) Project starts on the date of the first logged working day of the phase

   - Impact: Establishing the mandate start date from the first billing addresses the absence of explicit start dates in the original dataset, providing a consistent basis for project timeline management.
9) All projects inthe dataset are equally important ($w_p$ is constant)

   - Justification: In the absence of specific prioritization criteria, all projects are assumed to be of equal importance for optimization purposes.
   - Impact: Easier calculation for this demo.
10) All projects in the dataser are equally risky ($r_p$ is constant)

    - Justification: No data
    - Impact: Easier calculation for this demo.
11) Due to discrepancies between staffing and timesheets, staffing data will be prioritized

    - Justification: Staffing data contains a client ID number that is absent in the 'TIME' dataset, which appears to be specific to Company Y.
    - Impact: To maintain data integrity and consistency, client ID numbers in the 'TIME' dataset for Client Y are assumed to be erroneous and will be replaced with the corresponding values from the staffing data.
12) Negative hours logged offset hours on other projects for the same client

    - Justification: Data analysis indicates a pattern where negative hour entries for a consultant are associated with work on other mandates for the same client. This is also standard project management practice to respect budgets
    - Impact: While this assumption is made based on observed data patterns, the validity and full implications remain uncertain and require further investigation.
13) Differential Time Reporting Behaviors Between Internal and External Consultants

    - Justification: Analysis of timesheet submission patterns revealed significant delays from some senior managers, with entries submitted up to 55+ days late. This pattern aligns with previous observations that internal consultants (who receive regular salaries regardless of timely reporting) may have fewer immediate incentives for prompt time entry compared to external consultants whose compensation depends directly on reported hours.
    - Impact: For the sake of a demo, statistical analysis was conducted and consultants who wait on average less than 3 days to report their work hours were tagged as external, managers and above were excluded.
14) External consultants reduce profitability by 10%

    - Justification: This discount rate is arbitrary and should be fixed with production data.
    - Impact: This adjustment ensures that the VEC calculation accurately reflects the lower profitability of engagements with higher proportions of external consultants, helping practice leaders make more informed decisions about staffing mix.
15) Chargeout rates are negotiated per engagement

- Justification: analysis on the current dataset reveals that chargeout rates per consultant are consistent across one assignment but not across all assignments. Considering the limited timeframe, it is unlikely this is because of a promotion.
- Impact: This allows us to track the negotiatied chargeout rate and run the VEC calculations.

### Key Metrics Derivation

#### Budget at Completion (BAC)

- **Source**: Directly sourced from the `Budget.csv` dataset, specified for each project phase.
- **Purpose**: Represents the total authorized budget allocated for a given engagement phase, serving as the financial baseline.

#### Weighted Average Chargeout Rate

- **Formula**: $`\text{Weighted Chargeout Rate} = \sum_{i=1}^{n} \text{Chargeout}_{i} \times \frac{\text{Hours}_{i}}{\sum_{j=1}^{n} \text{Hours}_{j}}`$
- **Purpose**: Calculates a realistic average chargeout rate for a project phase by weighting individual chargeout rates by the proportion of hours worked by each employee, thereby accurately reflecting the staffing mix.
- **Note**: This rate is used to convert budget amounts into estimated hours and to calculate overall project duration.
- **Variables**:  $i$ represents each individual employee assigned to the project phase.

#### Hours Required to Complete Project

- **Formula**: $\text{Hours}_{\text{required}} = \frac{\text{BAC}}{\text{Weighted charge-out rate}}$
- **Purpose**: Determines the total estimated effort, in hours, required to fully deliver the project, based on the budget and the weighted average cost of resources.

#### Total Estimated Duration

- **Formula**: $`\text{Duration}_{\text{est}} = \frac{\text{Hours}_{\text{required}}}{\text{Number of employees assigned} \times \text{hours per workday}}`$
- **Note**: This calculation incorporates the number of employees assigned and standard workday hours to provide a realistic estimate of project timelines.
- **Purpose**: Establishes a baseline for measuring schedule performance and for project planning purposes.

#### Days Elapsed

- **Formula**: $\text{Days}_{\text{elapsed}} = \text{Current date} - \text{Start date}$
- **Purpose**: Measures the actual progression of the project timeline from the start date to the current date.

#### Percentage Schedule Elapsed

- **Formula**: $\text{Schedule\%} = \frac{\text{Days elapsed}}{\text{Duration}_{\text{est}}}$
- **Purpose**: Standardizes the measurement of schedule progress, allowing for comparison across projects regardless of their duration.

#### Actual Cost (AC)

- **Formula**: $`\text{AC} = \sum_{i=1}^{n} \text{StandardPrice}_i + \sum_{i=1}^{n} \text{AdminFees}_i`$
- **Purpose**: Calculates the total actual expenditure incurred to date, derived from timesheet entries including standard prices and administrative fees.
- **Note**: Calculated on a weekly basis to align with staffing allocation and performance review cycles.

#### Planned Value (PV)

- **Formula**: $\text{PV} = \text{BAC} \times \frac{\text{Days elapsed}}{\text{Total estimated duration in days}}$
- **Purpose**: Measures the expected value of work that should have been completed by a specific point in time, based on the project budget and schedule.

#### Earned Value (EV)

- **Formula**: $\text{EV} = \text{AC} \times \text{CPI}$
- **Purpose**: Represents the actual value of work completed, adjusted by the Cost Performance Index (CPI) to reflect efficiency and cost-effectiveness.
- **Note**: With a fixed CPI assumption of 0.98, Earned Value is effectively Actual Cost discounted by 2%, reflecting an expected level of efficiency. In production environments, this would be further refined using the VEC to account for actual financial performance.

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

## 📈 Performance Metrics

For a sample project with code ending 365, phase 000010, the following performance metrics are observed:

- Budget at completion (BAC): \$2.3M
- SPI: \[Value calculated]
- Estimated completion date: \[Date calculated]

 *Built for the KPMG Data Challenge 2025*

## Appendix 1: AI Usage

For the development of this project, ChatGPT (free version) and GitHub Copilot were utilized as valuable tools for research assistance, content generation, and code development support. These tools helped our team bridge knowledge gaps between our engineering/technical backgrounds and the consulting domain-specific requirements of this challenge.

## Appendix 2: Predicting Optimal Allocation of Employee Resources

The optimization formula presented in the Business Objectives section represents a complex resource allocation problem that requires an algorithmic approach to solve efficiently. Here, we outline our implementation strategy for this optimization:

### Implementation Strategy

1. **Data Preparation Phase**

   - Calculate current project statuses (SPI, VEC) from the database
   - Retrieve consultant availability data, including planned vacations
   - Calculate staffing ratios for each phase and for the open projects in the practice (essential because ratios may be missing or significantly differ from department averages)
   - Calculate strategic value weights $(w_p)$ for each project based on client priority, project size, and delivery risk
   - Determine delivery risk coefficient $(r_p)$ for each project to account for complexity and criticality
2. **Optimization Algorithm Selection**

   - We implemented a Mixed Integer Linear Programming (MILP) approach using the PuLP library in Python
   - The optimization runs weekly to reallocate resources based on updated project performance metrics
   - The assignment matrix A represents hours allocated per consultant, per project, per week
3. **Constraint Implementation**

   - Project schedule constraints: SPI > 0.85 is enforced by calculating minimum required consultant hours
   - Project value constraints: VEC > 0.85 to ensure adequate value extraction across all projects
   - Staffing ratio constraints: Required percentages of each level and practice are maintained
   - Consultant capacity constraints: No consultant is assigned more than 40 hours weekly
   - Vacation awareness: Consultant assignments respect approved time off
   - Internal priority: Internal consultants must be maximally utilized before external consultants are assigned
   - Project switching efficiency: A factor (pse ≤ 1) is applied to account for efficiency loss when consultants switch projects (currently set to 1 per our assumptions)
4. **Enhanced Objective Function**

   ```python
   # Pseudocode for the enhanced objective function
   model += pulp.lpSum([
       project_weights[p] * r_p * (
           alpha * calculate_projected_SPI(p, assignments) +
           beta * calculate_projected_VEC(p, assignments)
       ) - sum(pse_factor * is_project_switch[c, p, w] for c in consultants)
       for p in projects
   ])

   # Internal consultant priority constraint
   for w in weeks:
       for c_ext in external_consultants:
           for p in projects:
               # External consultants can only be assigned if all eligible internal consultants 
               # are already at maximum capacity (or on vacation)
               model += assignments[(c_ext, p, w)] <= M * (
                   sum(is_at_capacity[c_int, w] for c_int in eligible_internal_consultants[p])
                   == len(eligible_internal_consultants[p])
               )
   ```
5. **Post-Optimization Processing**

   - Results are written back to the staffing_prediction table
   - Dashboard visualizations update to reflect the optimized allocations
   - Resource managers receive notifications of significant reassignments
6. **Practical Considerations**

   - The weights α and β are configurable parameters (default: α=0.6, β=0.4)
   - For very large consultant pools, a two-phase approach may be used where:

     - Phase 1: Pre-filter eligible consultants for each project based on skills and availability
     - Phase 2: Run optimization on the reduced candidate pool
   - Weekly re-optimization includes "stability constraints" to minimize excessive consultant reassignments
   - Skills matching (not fully implemented in the current version) would add additional constraints to ensure consultants have the required capabilities for assigned projects
   - The project switching efficiency factor (pse) could be calibrated in production based on historical performance data to reflect the actual productivity impact of reassignments

This approach provides a balance between optimizing for both schedule performance and value extraction while maintaining practical constraints essential for consulting operations, prioritizing internal resources, and considering the efficiency impacts of project reassignments.
