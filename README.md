# Walmart-Retail-Analysis-SQL-Python-PowerBI

_An end-to-end data analysis solution uncovering revenue trends, customer behavior, and product performance using Python, SQL, and Power BI._

## Table of Contents

- [Overview](#overview)
- [Business Problem](#business-problem)
- [Dataset](#dataset)
- [Tools and Technologies](#tools-and-technologies)
- [Methods Used](#methods-used)
- [Power BI Dashboard](#power-bi-dashboard)
- [Requirements](#requirements)
- [How to run this project](#how-to-run-this-project)
- [Project Structure](#project-structure)
- [Results and Insights](#results-and-insights)
- [Future Enhancements](#future-enhancements)
- [Author and Contact](#author-and-contact)

## Overview
This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. We utilize Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. 

## Business Problem
Walmart wants to optimize store performance, better understand customer behavior, and identify top-performing categories and branches. The business is looking for:
- Revenue trends across time and locations
- Customer purchasing behavior
- Top-selling and underperforming product categories
- Preferred payment methods
- Branch and product profitability insights

## Dataset
- **Source:** Use the Walmart sales datasets from Kaggle.
- **Location:** Save the data in the ```data/``` folder for easy reference and access
- **Content:** Branch, City, Date, Customer Type, Gender, Product Line, Unit Price, Quantity, Tax, Total, Payment, Rating

## Tools and Technologies
- **Programming:** Python (Pandas, NumPy)
- **Database:** MySQL
- **Visualization:** Power BI
- **Other:** SQLAlchemy, MySQL-Connector-Python

## Methods Used
### 1. Download Walmart Sales Data
- **Data Source:** Use the Walmart sales datasets from Kaggle.
- **Storage:** Save the data in the ```data/``` folder for easy reference and access.
  
### 2. Install Required Libraries and Load Data
- **Libraries:** Install necessary Python libraries using:
```
pip install pandas numpy sqlalchemy mysql-connector-python
```
- **Loading Data:** Read the data into a Pandas DataFrame for initial analysis and transformations.

### 3. Explore the Data
- **Goal:** Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
- **Analysis:** Use functions like ```.info()```, ```.describe()```, and ```.head()``` to get a quick overview of the data structure and statistics.

### 4. Data Cleaning
- **Remove Duplicates:** Identify and remove duplicate entries to avoid skewed results.
- **Handle Missing Values:** Drop rows or columns with missing values if they are insignificant; fill values where essential.
- **Fix Data Types:** Ensure all columns have consistent data types (e.g., dates as ```datetime```, prices as ```float```).
- **Currency Formatting:** Use ```.replace()``` to handle and format currency values for analysis.
- **Validation:** Check for any remaining inconsistencies and verify the cleaned data.

### 5. Feature Engineering
- **Create New Columns:** Calculate the ```Total Amount``` for each transaction by multiplying ```unit_price``` by ```quantity``` and adding this as a new column.
- **Enhance Dataset:** Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 6. Load Data into MySQL 
- **Set Up Connections:** Connect to MySQL using ```sqlalchemy``` and load the cleaned data into each database.
- **Table Creation:** Set up tables in MySQL using Python SQLAlchemy to automate table creation and data insertion.
- **Verification:** Run initial SQL queries to confirm that the data has been loaded accurately.

### 7. SQL Analysis: Complex Queries and Business Problem Solving
- **Business Problem-Solving:** Write and execute complex SQL queries to answer critical business questions, such as:
#### 1. Calculate the total profit for each category.
```sql
SELECT 
     Category,
     SUM(unit_price * quantity * profit_margin) as Profit
FROM walmart
GROUP BY Category
ORDER BY Profit DESC;
```
**2. Calculate the total quantity of items sold per payment method.**
```sql
SELECT
     payment_method,
     SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;
```
**3. Determine the average, minimum, and maximum rating of categories for each city.**
```sql
SELECT
	  Category,
      City,
      AVG(rating) as Avg_rating,
      MIN(rating) as Min_rating,
      MAX(rating) as Max_rating
FROM walmart
GROUP BY city, category;
```
**4. Determine the most common payment method for each branch**
```sql
WITH CTE
AS
(SELECT 
      Branch,
      payment_method,
      count(*) as total_trans,
      RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS _Rank
FROM walmart
GROUP BY Branch, payment_method
)
SELECT * FROM CTE
WHERE _Rank = 1;
```
**5. Categorize sales into Morning, Afternoon, and Evening shifts**
```sql
SELECT 
      Branch,
      CASE
          WHEN HOUR(TIME(time))<12 THEN 'Morning'
          WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
          ELSE 'Evening'
	  END AS Shift,
      COUNT(*) AS num_invoices
FROM walmart
GROUP BY Branch, Shift
ORDER BY Branch, num_invoices DESC;
```
- **Documentation:** Keep clear notes of each query's objective, approach, and results.

### 8. Project Publishing and Documentation
- **Documentation:** Maintain well-structured documentation of the entire process in a Jupyter Notebook.
- **Project Publishing:** Publish the completed project on GitHub, including:
  - The ```README.md``` file (this document).
  - Jupyter Notebooks (if applicable).
  - SQL query scripts.
  - Data files (if possible) or steps to access them.


## Power BI Dashboard

The Power BI dashboard consists of:
- **What is the revenue distribution across different product categories?**
- **Which time slot (Morning, Afternoon, Evening) sees the highest product quantity sold?**
- **Which branches are top performers in terms of total revenue?**
- **How has revenue trended over the years from 2019 to 2023?**
  
  <img width="1327" height="746" alt="Screenshot 2025-07-31 231201" src="https://github.com/user-attachments/assets/f534a394-ff76-413c-852b-aaa2a362218d" />


## Requirements
- **Python:** 3.8+
- **SQL Databases:** MySQL
- **Python Libraries:**
  - ```pandas, numpy, sqlalchemy, mysql-connector-python```


## How to Run This Project?
### 1. Clone the repository
```bash
git clone <repo-url>
cd walmart-retail-analysis
```
### 2. Install required libraries
```bash
pip install -r requirements.txt
```
### 3. Run data preparation
```bash
python main.py
```
### 4. Open SQL scripts for business analysis (in sql_queries/ folder)

### 5. Launch Power BI and import the dataset for dashboard creation


## Project Structure
```
Walmart-Retail-Analysis/
├── data/                          #Contains raw and cleaned datasets.
│   ├── raw_data.csv
│   └── cleaned_data.csv
├── notebooks/                     #Jupyter notebooks for data cleaning and analysis.
│   └── Walmart_Analysis.ipynb
├── sql_queries/                   #SQL scripts used for EDA.
│   └── eda_queries.sql
├── dashboards/                    #Power BI dashboard file.
│   └── walmart_dashboard.pbix
├── README.md
└── requirements.txt               #List of required Python libraries.        
```

## Results and Insights
This section will include your analysis findings:
- **Sales Insights:** Key categories, branches with highest sales, and preferred payment methods.
- **Profitability:** Insights into the most profitable product categories and locations.
- **Customer Behavior:** Trends in ratings, payment preferences, and peak shopping hours.

## Future Enhancements
- Incorporate monthly or quarterly trend comparison
- Use predictive models (e.g., time series forecasting)
- Integrate live data feeds from transactional systems
- Expand to multi-country datasets for global analysis

## Author and Contact  
**Deeksha Soni**  
  Data Analyst   
📧 Email: deeksha.soni13@gmail.com  
🔗 LinkedIn: https://www.linkedin.com/in/itsdeekshasoni






