-- 1) What is total revenue 
SELECT 
    SUM(CASE WHEN currency = 'INR' THEN sales_amount ELSE sales_amount * 75 END) AS total_revenue_inr
FROM 
    transactions;
    
-- 2) Total Orders 
select sum(sales_qty) as Total_orders from transactions; 

-- 3) Total Revenue By Market 
SELECT
    m.markets_name,
    SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
             WHEN t.currency = 'USD' THEN t.sales_amount * 75
             ELSE 0
        END) AS total_revenue_inr
FROM
    transactions t
JOIN
    markets m ON t.market_code = m.markets_code
GROUP BY
    m.markets_name;
    
-- 4) Find Total Orders by markets 
select m.markets_name , sum(t.sales_qty) from transactions t
join
markets m on t.market_code = m.markets_code
group by 
    m.markets_name;
    
-- 5) Find top 5 customer by total revenue
SELECT
    c.custmer_name,
    SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
             WHEN t.currency = 'USD' THEN t.sales_amount * 75
             ELSE 0
        END) AS total_revenue_inr
FROM
    transactions t
JOIN
    customers c ON t.customer_code = c.customer_code
GROUP BY
    c.custmer_name 
order by total_revenue_inr desc
limit 5;

-- 6) Find top 5 customers by orders 
select c.custmer_name , sum(t.sales_qty) as total_orders from transactions t
join
customers c on t.customer_code = c.customer_code
group by 
    c.custmer_name
    order by total_orders desc
    limit 5;
    
-- 7) Total profit margin 
select sum(profit_margin) from transactions;


-- 8) Find Revenue contribution percentage 

SELECT
    m.markets_name,
    SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
             WHEN t.currency = 'USD' THEN t.sales_amount * 75
             ELSE 0
        END) AS total_revenue_inr,
    round((SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
              WHEN t.currency = 'USD' THEN t.sales_amount * 75
              ELSE 0
         END) / (SELECT SUM(sales_amount) FROM transactions) * 100),1) AS revenue_contribution_percentage
FROM
    transactions t
JOIN
    markets m ON t.market_code = m.markets_code
GROUP BY
    m.markets_name order by revenue_contribution_percentage desc;

-- 9) Find profit margin contribution percentage by markets 

SELECT
    m.markets_name,
    SUM(t.profit_margin) AS total_profit_margin,
    ROUND((SUM(t.profit_margin) / (SELECT SUM(profit_margin) FROM transactions) * 100), 1) AS profit_margin_contribution_percentage
FROM
    transactions t
JOIN
    markets m ON t.market_code = m.markets_code
GROUP BY
    m.markets_name
order by profit_margin_contribution_percentage desc;

-- 10) Find profit margin percentage by market

select 
  m.markets_name, 
  SUM(t.profit_margin) AS total_profit_margin,
  SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
             WHEN t.currency = 'USD' THEN t.sales_amount * 75
             ELSE 0
        END) AS total_revenue_inr,
round(sum(t.profit_margin) / SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
             WHEN t.currency = 'USD' THEN t.sales_amount * 75
             ELSE 0
        END)*100,1) as profit_margin_percentage
from transactions t
join markets m 
on t.market_code = m.markets_code
group by markets_name
order by profit_margin_percentage desc;

-- 11) Find total revenue, revenue contribution percentage, total profit margin, profit margin percentage by customer

select 
c.custmer_name,
SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
             WHEN t.currency = 'USD' THEN t.sales_amount * 75
             ELSE 0 END) AS total_revenue_inr,
 round((SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
              WHEN t.currency = 'USD' THEN t.sales_amount * 75
              ELSE 0
         END) / (SELECT SUM(sales_amount) FROM transactions) * 100),1) AS revenue_contribution_percentage,
 round(sum(t.profit_margin) / SUM(CASE WHEN t.currency = 'INR' THEN t.sales_amount
             WHEN t.currency = 'USD' THEN t.sales_amount * 75
             ELSE 0 END)*100,1) as profit_margin_percentage,
    ROUND((SUM(t.profit_margin) / (SELECT SUM(profit_margin) FROM transactions) * 100), 1) AS profit_margin_contribution_percentage
from transactions t 
join customers c 
on t.customer_code = c.customer_code 
group by custmer_name;

-- 12) current year total revenue (2020)

select 
sum(transactions.sales_amount) 
from transactions 
join date 
on transactions.order_date=date.date 
where date.year= 2020 and transactions.currency= 'INR' or transactions.currency= 'USD'; 





  

       

