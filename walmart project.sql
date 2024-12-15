create database if not exists walmartsalesdata;
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select*from sales;


----  ------------------------------------------------------------------FEATURE ENGINEERING---------------------------------------------------------------



select time from sales;
select time,
	(case
		when time between '00:00:00' and '12:00:00' then 'Morning' 
	when time between '12:00:01' and '16:00:00' then 'Afternoon'
    else 'Evening'
   end ) as time_of_date
    from sales;

alter table sales add column time_of_day varchar(10);
update sales set time_of_day = (
	case
		when time between '00:00:00' and '12:00:00' then 'Morning' 
		when time between '12:00:01' and '16:00:00' then 'Afternoon'
		else 'Evening'
   end
	);
    select*from sales;

-- -------------Day Name------------

select date, dayname(date) from sales;

alter table sales add column day_name varchar(10);
select date, dayname(date) as day_name from sales;
select*from sales;
update sales set day_name = dayname(date);



-- -------------Month Name------------------
select date, monthname(date) from sales;
alter table sales add column month_name varchar(10);
update sales set month_name = monthname(date);







-- -----------------------QUESTIONS--------------------
-- 1. HOW MANY UNIQUE CITIES DOES THE DATA HAVE?
SELECT DISTINCT
    city
FROM
    sales;

-- 2. IN WHICH CITY IS EACH BRANCH?
SELECT DISTINCT
    city, branch
FROM
    sales;

-- 3. HOW MANY UNIQUE PRODUCT LINES DOES THE DATA HAVE?
SELECT DISTINCT
    product_line
FROM
    sales;

-- 4. HOW MANY UNIQUE PRODUCT LINES COUNT DOES THE DATA HAVE?
SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;

-- 5. WHAT IS THE MOST COMMON PAYMENT METHOD?
SELECT 
    payment, COUNT(payment) AS count_payment_method
FROM
    sales
GROUP BY payment
ORDER BY count_payment_method DESC;

-- 6. WHAT IS THE MOST SELLING PRODUCT LINE?
SELECT 
    product_line, COUNT(product_line) AS count_product_line
FROM
    sales
GROUP BY product_line
ORDER BY count_product_line DESC;

-- 7. WHAT IS THE TOTAL REVENUE BY MONTH?
SELECT 
    month_name AS month, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month_name
ORDER BY total_revenue desc;

-- 8. WHAT MONTH HAD THE LARGEST COGS?
SELECT 
    month_name AS month, SUM(cogs) AS count_cogs
FROM
    sales
GROUP BY month_name
ORDER BY count_cogs DESC;

-- 9. WHAT PRODUCT LINE HAD THE LARGEST REVENUE?
SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 10.WHAT IS THE CITY WITH THE LARGEST REVENUE?
SELECT 
    city, SUM(total) AS total_city_revenue
FROM
    sales
GROUP BY city
ORDER BY total_city_revenue DESC;
-- 11.WHAT PRODUCT LINE HAD THE AVERAGE PRODUCT TAX?
SELECT 
    product_line, avg(tax_pct) AS avg_tax
FROM
    sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- 12.WHICH BRANCH SOLD MORE PRODUCTS THAN AVERAGE PRODUCT SOLD?
SELECT 
    branch, SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);

-- 13.WHAT IS THE MOST COMMON PRODUCT LINE BY GENDER?
SELECT 
    gender, product_line, count(gender) AS total_cnt
FROM
    sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- 14.WHAT IS THE AVERAGE RATING OF EACH PRODUCT LINE?
SELECT 
    product_line, avg(rating) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;
