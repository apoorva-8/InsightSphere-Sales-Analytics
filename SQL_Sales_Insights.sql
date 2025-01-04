/* Data Analysis */

/* CUSTOMER ANALYSIS */
/* QUES -1 Who are the top customers based on sales amount? */
USE sales;
SELECT * FROM customers;
SELECT * from transactions;

SELECT  sales_amount * 82  As rupees_currency
FROM transactions
WHERE currency = "USD";

UPDATE transactions
SET sales_amount = sales_amount * 82 ,
currency = 'INR'
WHERE currency = 'USD';

SELECT * FROM transactions;

SELECT transactions.customer_code , custmer_name , (sales_qty * sales_amount) as Total_Sales
from customers
JOIN transactions on
transactions.customer_code = customers.customer_code
ORDER BY total_Sales DESC ;

/* QUES - 2 What is the average purchase frequency of customers by customer type? */

SELECT count(custmer_name) as Frequency_of_customers ,customer_type FROM customers
group by customer_type;

/* QUES - 3 Which customer type contributes the most to sales revenue? */
SELECT  c.customer_type, sum(t.sales_qty * t.sales_amount) as Total_Sales
from customers c
JOIN transactions t 
on
t.customer_code = c.customer_code
GROUP BY c.customer_type
ORDER BY Total_Sales DESC;

/* QUES-4 How the number of active customers change over time*/
/*Define Active Customers:
A customer is active if they have made at least one transaction in a specific time period.
Identify the Time Period:
Group the data by year, month, or another relevant time period.
Count Unique Active Customers:
Use the COUNT(DISTINCT customer_code) function to count unique customers in each time period.*/

SELECT * FROM TRANSACTIONS;
SELECT 
YEAR(order_date) AS t_year,
MONTH(order_date) AS t_month,
count(distinct t.customer_code) AS active_customers

FROM transactions t
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY t_year , t_month;

/* MARKET ANALYSES */
/* QUES-5 Which market or zones generate the most revenue? */
SELECT * FROM MARKETS;
SELECT * FROM TRANSACTIONS;

SELECT 
sum(t.sales_qty * t.sales_amount) AS Revenue , 
m.markets_name,
m.zone
FROM
transactions t
JOIN 
markets m
ON m.markets_code = t.market_code
GROUP BY m.markets_name , m.zone
ORDER BY Revenue DESC ;

/* ANS -1. DELHI NCR - ZONE - 81433014546
2. MUMBAI CENTRAL - '47318547449' */

/* QUES-6 What are the seasonal trends in sales for different markets?*/
SELECT 
m.markets_name, 
CASE
WHEN month(t.order_date) in (12,1,2) THEN 'winters'
WHEN month(t.order_date) in (3,4,5) THEN 'Spring'
WHEN month(t.order_date) in (6,7,8) THEN 'Summer'
WHEN month(t.order_date) in (9,10,11) THEN 'Autum'
END AS seasons,
SUM(sales_qty*sales_amount) AS Sale_Revenue
FROM markets m
JOIN transactions t
on m.markets_code = t.market_code
GROUP BY 
m.markets_name,
CASE
WHEN month(t.order_date) in (12,1,2) THEN 'winters'
WHEN month(t.order_date) in (3,4,5) THEN 'Spring'
WHEN month(t.order_date) in (6,7,8) THEN 'Summer'
WHEN month(t.order_date) in (9,10,11) THEN 'Autum'
END 
ORDER BY m.markets_name , seasons;

/* QUES-7 Are there zones with consistently low performance that require attention?*/
SELECT * FROM markets;
SELECT 
sum(t.sales_qty * t.sales_amount) AS Revenue , 
m.markets_name,
m.zone
FROM
transactions t
JOIN 
markets m
ON m.markets_code = t.market_code
GROUP BY m.markets_name, m.zone
ORDER BY Revenue ASC;

/* ANS - YES Bengaluru South, Patna North, Surat North has low Revenue 

/*Product Performance*/
/* QUES-8 Which product type generates the highest and lowest revenue? */
SELECT * FROM products;
SELECT * FROM TRANSACTIONS;

SELECT t.product_code , (t.sales_qty* t.sales_amount) AS Revenue
FROM transactions t
JOIN products p
ON p.product_code = t.product_code
ORDER BY REVENUE DESC  LIMIT 1;

SELECT t.product_code , (t.sales_qty* t.sales_amount) AS Revenue
FROM transactions t
JOIN products p
ON p.product_code = t.product_code
ORDER BY REVENUE LIMIT 1;

/* ANS - Highest Revenue -  Prod090 - Revenue - '8832002193'
/* ANS - Lowest Revenue - Prod001 - Revenue -  -3 */

/*QUES-9 Are there products with high sales volume but low revenue */
SELECT * FROM TRANSACTIONS;

SELECT t.product_code , t.sales_qty , (t.sales_qty* t.sales_amount) AS Revenue
FROM transactions t
WHERE (t.sales_qty - (t.sales_qty* t.sales_amount) ) > 20 ;

/* ANS - YES , Prod090 -> sales - 1267 and revenue is 0 , Prod260 -> sales - 474 and revenue 0*/

/*QUES-10 Are there products with low sales volume but high revenue*/
SELECT t.product_code , t.sales_qty , (t.sales_qty* t.sales_amount) AS Revenue
FROM transactions t
WHERE t.sales_qty < (t.sales_qty* t.sales_amount) ;

/* Yes this is a very obvious case */

 /* QUES-11 What is the sales trend for each product type over time? */

SELECT * FROM TRANSACTIONS;
SELECT * FROM PRODUCTS;
SELECT p.product_type, sum(t.sales_qty* t.sales_amount) AS Revenue ,
Year(order_date) AS t_year , Month(order_date) as t_month
FROM transactions t
JOIN products p
ON t.product_code = p.product_code
GROUP BY  p.product_type, Year(order_date) , Month(order_date);

/* Sales Trends Over Time */
/*QUES-12 What is the overall sales trend by month and year?
/*Number of sales (sales quantity): Helps identify how
 the demand for products is changing over time.*/
 
 SELECT * FROM transactions;
 SELECT SUM(sales_qty ), year(order_date) , month(order_date)
 FROM transactions
 GROUP BY year(order_date) , month(order_date);
 
 /* QUES-13 What is the overall revenue trend by month and year?
 Revenue (sales amount): Shows
 how total income from sales is evolving, factoring in both quantity and pricing.*/
 
SELECT SUM(sales_qty * sales_amount), year(order_date) , month(order_date)
 FROM transactions
 GROUP BY year(order_date) , month(order_date);
 
 /* QUES-14 Which months and years are the peak sales periods?*/
 
 SELECT * FROM TRANSACTIONS;
 SELECT sum(Sales_qty * sales_amount) AS TOTAL_SALES, year(order_date), month(order_date)
 FROM transactions
 GROUP BY year(order_date), month(order_date)
 ORDER BY TOTAL_SALES DESC LIMIT 1;
 
 /* ANS - 2018 JANUARY - '16503757156' SALES - 16 BILLION 503 MILLION 757 THOUSAND 156 */
 
 /* CURRENCY AND TRANSACTIONS INSIGHTS */
 /* QUES - 15 What is the proportion of sales in different currencies? */
 SELECT * FROM transactions where currency = 'USD';
 /* ANS - 36:2 INR and USD */
 SELECT 
    currency,
    SUM(sales_amount) AS total_sales,
    ROUND((SUM(sales_amount) / (SELECT SUM(sales_amount) FROM transactions)) * 100, 2) AS sales_proportion_percentage
FROM 
    transactions
GROUP BY 
    currency
ORDER BY 
    total_sales DESC;
    
/* QUES-16 Are there patterns in transaction frequency by order date or time?*/

SELECT count(order_date) , year(order_date) , month(order_date)
FROM transactions
GROUP BY year(order_date),month(order_date)
ORDER BY year(order_date),month(order_date) DESC;
 /* ANS 2017 -18 Around 4000 and 5000 decreased in 2020 around 3000 */
 
 SELECT 
    YEAR(order_date) AS year, 
    MONTH(order_date) AS month, 
    COUNT(*) AS transaction_count
FROM 
    transactions
GROUP BY 
    YEAR(order_date), MONTH(order_date)
ORDER BY 
    YEAR(order_date), MONTH(order_date);
    
/* Relationship Between Metrics
 QUES - 17 How does customer type influence market preference or product purchase?
 */
 SELECT * FROM customers;
 SELECT * FROM markets;
 SELECT * FROM products;
 SELECT * FROM transactions;
 
 SELECT 
      sum(t.sales_qty* t.sales_amount) as Revenue,  
      c.customer_type
FROM 
	transactions t
JOIN 
    customers  c
ON
   t.customer_code = c.customer_code
GROUP BY 
		c.customer_type ;
        
/* QUES - 18 Is there a relationship between zones and specific product popularity? */

SELECT 
    m.zone, 
    p.product_type,
    SUM(t.sales_qty) AS total_quantity_sold,
    SUM(t.sales_amount) AS total_sales_revenue
FROM 
    transactions t
JOIN 
    markets m ON t.market_code = m.markets_code
JOIN 
    products p ON t.product_code = p.product_code
GROUP BY 
    m.zone, p.product_type
ORDER BY 
    m.zone, total_quantity_sold DESC;

/* Advanced Insights
 QUES  - 19 What are the retention rates of customers? */
 
 SELECT 
    customer_code,
    DATE_FORMAT(order_date, '%Y-%m') AS period
FROM 
    transactions
GROUP BY 
    customer_code, DATE_FORMAT(order_date, '%Y-%m');
    
/* Finding customers who made purchases in both 
the current and the previous period. Use a self-join for this purpose */

SELECT 
    t1.period AS current_period,
    t2.period AS previous_period,
    COUNT(DISTINCT t1.customer_code) AS retained_customers
FROM 
    (SELECT customer_code, DATE_FORMAT(order_date, '%Y-%m') AS period
     FROM transactions) t1
JOIN 
    (SELECT customer_code, DATE_FORMAT(order_date, '%Y-%m') AS period
     FROM transactions) t2
ON 
    t1.customer_code = t2.customer_code
    AND DATE_ADD(t2.period, INTERVAL 1 MONTH) = t1.period
GROUP BY 
    t1.period, t2.period;

/* Find the total number of customers in the previous period and use it to calculate the retention rate */
WITH customers_by_period AS (
    SELECT 
        customer_code,
        DATE_FORMAT(order_date, '%Y-%m') AS period
    FROM 
        transactions
    GROUP BY 
        customer_code, DATE_FORMAT(order_date, '%Y-%m')
),
retained_customers AS (
    SELECT 
        t1.period AS current_period,
        COUNT(DISTINCT t1.customer_code) AS retained_customers
    FROM 
        customers_by_period t1
    JOIN 
        customers_by_period t2
    ON 
        t1.customer_code = t2.customer_code
        AND DATE_ADD(t2.period, INTERVAL 1 MONTH) = t1.period
    GROUP BY 
        t1.period
),
total_customers AS (
    SELECT 
        period,
        COUNT(DISTINCT customer_code) AS total_customers
    FROM 
        customers_by_period
    GROUP BY 
        period
)
SELECT 
    r.current_period,
    r.retained_customers,
    t.total_customers AS previous_total_customers,
    (r.retained_customers * 100.0 / t.total_customers) AS retention_rate
FROM 
    retained_customers r
JOIN 
    total_customers t
ON 
    r.current_period = DATE_ADD(t.period, INTERVAL 1 MONTH)
ORDER BY 
    r.current_period;


 
 /* ---------------------------------------------END OF THE INSIGHTS --------------------------------------------------------------------*/

