# Data Analyst Portfolio
### Excel · SQL · Power BI

A portfolio of end-to-end data analysis projects demonstrating 
skills in data cleaning, transformation, analysis and visualisation 
across industry-standard tools.

---

## Projects

| Project | Tools | Description | Link |
|---|---|---|---|
| Olist E-Commerce Analysis | Excel | Sales performance, delivery operations and payment analysis across 100k+ orders | [View](./excel/) |
| Olist E-Commerce Analysis | SQL Server | Extended analysis across all 9 tables — customer, seller, product and operational insights | [View](./sql/) |
| Olist E-Commerce Analysis | Power BI | Interactive 4-page report built on a star schema data model with DAX measures, geographic visualisation and cross-filtering | [View](./powerbi/) |

---

## About This Portfolio

All three projects use the same dataset — the Olist Brazilian 
E-Commerce dataset from Kaggle — intentionally. This demonstrates 
the ability to work with the same data end-to-end across different 
tools, which is similar how analysts work in real environments.

### Cross Tool Validation Finding
In the course of this project, the total revenue returned by the Excel and Power BI analysis returned different figures, $19.8M and $15.42M respectively. Investigation revealed the Excel working data merged order_items with payments, duplicating payment values for multi-item orders. The correct figure of $15.42M was independently confirmed by both SQL Server and Power BI. This finding is documented in Power BI's README as an example of why cross-validating results across tools is essential analytical practice.

---

## Tools & Skills

**Excel**
- Power Query for multi-table data merging and transformation
- Pivot Tables and calculated fields
- Dashboard design with KPI cards, combo charts and slicers
- SUMPRODUCT, COUNTIFS, AVERAGEIF formulas
- Composite KPI design — Delivery Performance Score

**SQL Server**
- Database design and relationship definition
- Foreign key constraints and referential integrity
- Data cleaning — orphan record handling, null management
- Complex multi-table JOINs
- CTEs for readable sequential logic
- Window functions — RANK() and LAG()
- Conditional aggregation with SUM(CASE WHEN...)
- DATEDIFF for date arithmetic

**Power BI**
- Star schema data modelling with defined relationships
- Power Query data transformation
- DAX measures — CALCULATE, DIVIDE, AVERAGEX, ALL(), RANKX, VAR/RETURN
- Filter context manipulation
- Dynamic percentage calculations
- Interactive slicers and cross-filtering
- Custom theme design
- Multi-page report design

---

## Dataset
All projects use the [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle — 100,000+ orders across 9 related tables covering the period 2016 to 2018.

---

## Author
Samuel Aladegbaiye
