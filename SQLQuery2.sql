--create database --
 create database walmart;

 -- create table sales--

 CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column--
SELECT
	time,
	(CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_date
FROM sales;

alter table sales add  time_of_day varchar(20);

update sales
set time_of_day = (
case
      WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
		end
);


-- Add day_name column--

select date, datename(weekday,date)
from sales;

alter table sales add day_name varchar(10);

update sales
set day_name = datename(weekday,date);


-- Add month_name column --

select date, datename(month, date)
from sales;

alter table sales add month_name varchar(10);

update sales
set month_name = datename(month,date);

-- How many unique cities does the data have?--

select distinct(city)
from sales;

-- In which city is each branch?--

select distinct(city), branch
from sales;

-----------Product---------------

--How many unique product lines does the data have?--

select distinct(product_line)
from sales;

--What is the most common payment method?--

select distinct(payment)
from sales;

--What is the most selling product line?--

select sum(quantity) as qnt , product_line
from sales
group by product_line
order by qnt desc;

-- What is the total revenue by month--

select month_name, sum(total) as total_rev
from sales
group by month_name
order by total_rev;

-- What month had the largest COGS?--

select month_name, sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- What product line had the largest revenue?--

select top 3 product_line, sum(total) as revenue
from sales
group by product_line
order by revenue desc;

-- What is the city with the largest revenue?--

select city, sum(total) as revenue
from sales
group by city
order by revenue desc;

-- What product line had the largest VAT?--

select product_line, sum(tax_pct) as vat
from sales
group by product_line
order by vat desc;
select * from sales;

-- Fetch each product line and add a column to those product --
-- line showing "Good", "Bad". Good if its greater than average sales--

select product_line,
case 
when quantity > 5 then 'Good'
else 'Bad'
end as remark
from sales;

-- Which branch sold more products than average product sold?--

select branch, sum(quantity) as qunt
from sales
group by branch
having avg(quantity) < (select sum(quantity) from sales);

-- What is the most common product line by gender--


select gender, product_line, count(gender) as total
from sales
group by gender, product_line
order by total desc;

-----------------------------------------------------------------
----------------customers----------------------------------------

-- How many unique customer types does the data have?--

select distinct(customer_type)
from sales;

-- What is the most common customer type?--

select 
customer_type,
count(*) as count
from sales
group by customer_type
order by count;

-- What is the gender of most of the customers?--

select
	gender,
	count(*) as gender_cnt 
from sales
group by gender
order by gender_cnt desc;

-- Which time of the day do customers give most ratings?

select
	time_of_day,
	avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- Which day fo the week has the best avg ratings?

select
	day_name,
	avg(rating) as avg_rating
from sales
group by day_name 
order by avg_rating desc;

-------------------------------------------------------------
-------------------------------------------------------------
-----------------sales---------------------------------------
-- Number of sales made in each time of the day per weekday 
select
	time_of_day,
	count(*) as total_sales
from sales
where day_name = 'Saturday'
group by time_of_day 
order by total_sales desc;

-- Which city has the largest tax/VAT percent?

select
	city,
   round(avg(tax_pct),3) as avg_tax_pct
from sales
group by city 
order by avg_tax_pct desc ;

-- Which of the customer types brings the most revenue?--

select customer_type, sum(total) as revenue
from sales
group by customer_type
order by revenue desc;


-----------------------------------------------------------------
----------------------END----------------------------------------
-----------------------------------------------------------------