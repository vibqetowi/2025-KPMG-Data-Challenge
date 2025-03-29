# Predictive Resource Optimization Platform (PROP)
## KPMG Case Challenge Presentation Plan

### Slide 1: Title Slide
- Title: "Predictive Resource Optimization Platform (PROP)"
- Subtitle: "A Data-Driven Solution for Consulting Resource Allocation"
- Team 7
- KPMG Data Challenge 2025

### Slide 2: Team Introduction
- Brief team member introductions
- Diversity of backgrounds (Software Engineering, Mechanical Engineering, Finance, Economics)
- Our approach: Leveraging technical expertise to solve consulting challenges

### Slide 3: The Challenge & Mandate
- Key business needs addressed:
  * Optimizing consultant utilization
  * Minimizing bench time
  * Meeting engagement deadlines
  * Maximizing profitability
- Variables considered from case:
  * Timesheet data, staffing requirements, billing rates, project budgets
  * Chargeout rate variations across staff levels
  * Resource constraints and capacity planning

### Slide 4: Solution Overview
- Introduction to PROP (Predictive Resource Optimization Platform)
- Production-ready integration with KPMG technology stack
- ETL process from source systems to SQL database
- Predictive modeling with optimization algorithm
- Visualizations through Power BI dashboards

### Slide 5: Deliverables
- Technical report (PDF)
- Presentation slides
- Source code (Python for optimization and calculations)
- Power BI dashboards
- Database schema and setup scripts

### Slide 6: Key Performance Indicators
- Value Extraction Coefficient (VEC): Measuring financial realization efficiency
- Budget Burn: Tracking cost control against budget
- Schedule Performance Index (SPI): Monitoring delivery progress
- Benching Rate: Managing unutilized capacity
- Capacity Utilization Rate: Optimizing billable hours
- How these KPIs drive better business decisions

### Slide 7: Evolution from CPI to VEC
- Traditional EVM and CPI limitations for consulting
- The dual challenge: Budget utilization AND chargeout rate optimization
- Screenshot of VEC formula with explanation
- How VEC addresses consulting's unique challenges
- Key components: Rate efficiency, external consultant adjustment, new hire efficiency

### Slide 8: VEC Interpretation Table
- Table showing VEC vs. Burn matrix
- Explain decision scenarios:
  * Excellent: High efficiency, within budget
  * On Track: Standard efficiency, within budget
  * Warning: Value dilution even within budget
  * Ambiguous: Over budget but efficient (needs investigation)
  * Critical: Over budget with poor efficiency

### Slide 9: Optimization Algorithm
- Objective function: Maximizing SPI and VEC while minimizing switching costs
- Visualization of key constraints:
  * Schedule performance (SPI ≥ 0.85)
  * Value extraction (|VEC - Burn| ≤ 0.15)
  * Maintaining staffing ratios
  * Respecting capacity and work-life balance
  * Internal consultant prioritization

### Slide 10: Main Dashboard
- Screenshot of the main dashboard
- Highlight key features:
  * Resource utilization overview
  * Engagement health indicators
  * Weekly capacity planning
  * Financial performance tracking

### Slide 11: Partner Dashboard
- Screenshot of the executive/partner view
- Color-coded KPI indicators for quick assessment
- Focus on strategic insights and decision points
- Top-level metrics for management review

### Slide 12: Predictive Dashboard
- Screenshot of the next week planning view
- Optimization recommendations
- Resource allocation predictions
- Highlighting potential conflicts or issues

### Slide 13: Data Model
- ERD diagram visualization
- Key tables and relationships:
  * Employees, Engagements, Phases
  * Timesheets, Staffing
  * Vacations, Charge-out Rates
- Designed for scalability and performance

### Slide 14: Key Assumptions
- Critical CPI assumption (0.98) with explanation
- Supporting assumptions:
  * Phase duration calculations
  * Staffing distribution consistency
  * Linear project progression
  * External consultant profitability impact

### Slide 15: Solution Architecture
- Architecture diagram showing:
  * Data sources and ETL processes
  * Database layer
  * Calculation engine
  * Optimization module
  * Visualization layer
  * Integration points with existing systems

### Slide 16: Implementation Timeline
- Phased approach:
  * Phase 1: Database deployment and data integration
  * Phase 2: Dashboard implementation and testing
  * Phase 3: Optimization engine activation
  * Phase 4: User training and feedback incorporation
- Key milestones and dependencies

### Slide 17: Financial Considerations
- Implementation costs
- Expected ROI:
  * Improved utilization (quantified %)
  * Reduced bench time (quantified %)
  * Better project delivery (on-time completion %)
  * Enhanced profitability (projected increase)
- Payback period estimation

### Slide 18: Key Takeaways
- Value proposition summary
- Competitive advantages
- Next steps and recommendations
- Critical success factors

### Slide 19: Q&A
- Contact information
- Additional resources
- Thank you message
