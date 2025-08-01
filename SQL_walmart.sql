
CREATE DATABASE walmart_db;
SELECT * FROM walmart;

-- Exploratory Data Analysis(EDA)
SELECT COUNT(*) FROM walmart;

SELECT 
	payment_method,
    COUNT(*)
FROM walmart
GROUP BY payment_method;

SELECT COUNT(DISTINCT Branch)
FROM walmart;

SELECT MAX(quantity) FROM walmart;
SELECT MIN(quantity) FROM walmart;



-- Business Problems
SELECT * FROM walmart;

-- Q1 Find different payment methods and number of transactions, number of qty sold.
SELECT
	  payment_method,
      COUNT(*) AS no_of_payments,
      SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;
      
 -- -------------------------------------------------------------------------------------------------------
 
 -- Q2 Identify the highest rated category in each branch, displaying the branch, category avg rating 
SELECT * 
FROM ( 
      SELECT 
           Branch,
           category,
           AVG(rating) as Avg_rating,
           RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) AS _rank
     FROM walmart
     GROUP BY Branch, category
) AS ranked_categories
WHERE _rank = 1;     
      
-- ----------------------------------------------------------------------------------------------------------

-- Q3 Identify the busiest day for each branch based on the number of transactions.

SELECT Branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS _rank
    FROM walmart
    GROUP BY Branch, day_name
) AS ranked
WHERE _rank = 1;

-- ----------------------------------------------------------------------------------------------------------

-- Q4: Calculate the total quantity of items sold per payment method. List the payment_method and total_quantity.
SELECT
      payment_method,
      SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;

-- ------------------------------------------------------------------------------------------------------------------

-- Q5: Determine the average, minimum, and maximum rating of categories for each city

SELECT
	  Category,
      City,
      AVG(rating) as Avg_rating,
      MIN(rating) as Min_rating,
      MAX(rating) as Max_rating
FROM walmart
GROUP BY city, category;

-- ------------------------------------------------------------------------------------------------------------------

-- Q6: Calculate the total profit for each category

SELECT 
	  Category,
      SUM(unit_price * quantity * profit_margin) as Profit
FROM walmart
GROUP BY Category
ORDER BY Profit DESC;

-- ------------------------------------------------------------------------------------------------------------------

-- Q7: Determine the most common payment method for each branch. Display Branch and preferred_payment_method.
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

-- ------------------------------------------------------------------------------------------------------------------

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts. Find out each of the shift and number of invoices.
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

-- -------------------------------------------------------------------------------------------------------------------

-- Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
WITH revenue_2022 AS(
	SELECT 
         Branch,
         SUM(total) AS revenue
	FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
    GROUP BY Branch
),
revenue_2023 AS (
     SELECT 
          Branch,
          SUM(total) AS revenue
	 FROM walmart
     WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
     GROUP BY Branch
)    
SELECT 
      r2022.Branch,
      r2022.revenue AS last_year_revenue,
      r2023.revenue AS current_year_revenue,
      ROUND(((r2022.revenue - r2023.revenue)/r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;












