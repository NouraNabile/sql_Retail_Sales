use first_project
DROP TABLE IF EXISTS Retail_Sales 
-- create data base and table
create table Retail_Sales
( transactions_id INT PRIMARY KEY, 
  sale_date DATE,
  sale_time	TIME,
  customer_id INT,
  gender VARCHAR(15),
  age INT,
  category VARCHAR(15),
  quantiy INT,
  price_per_unit FLOAT,
  cogs FLOAT,
  total_sale FLOAT

)
--insert data in table
BULK INSERT Retail_Sales
FROM 'D:\SQL_projects\p1\SQL-RetailSalesAnalysis_utf.csv'
WITH (
    FIELDTERMINATOR = ',',   -- حددي الفاصل الصح
    ROWTERMINATOR = '\n',    -- سطر جديد
    FIRSTROW = 2             -- تجاهل الـ Header
);
--Data Exploration & Cleaning
/*Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.
معلومة العمر عادي انه يكون فاضي فاي بزنس العمر عادي انه ميتكتبش*/
select * from Retail_Sales
select count(*) from Retail_Sales
select * from Retail_Sales
where transactions_id IS NULL OR
sale_date IS NULL OR
customer_id  IS NULL OR
 gender IS NULL OR
  category IS NULL OR
  quantiy IS NULL OR
  price_per_unit IS NULL OR
  cogs IS NULL OR
  total_sale IS NULL  ;

delete from Retail_Sales
where transactions_id IS NULL OR
sale_date IS NULL OR
customer_id  IS NULL OR
 gender IS NULL OR
  category IS NULL OR
  quantiy IS NULL OR
  price_per_unit IS NULL OR
  cogs IS NULL OR
  total_sale IS NULL  ;
  /*3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:*/
--1-Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from Retail_Sales r
where r.sale_date='2022-11-05'
--2-Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from Retail_Sales r
where r.category='Clothing' 
and r.quantiy >= 4 
and FORMAT(r.sale_date, 'yyyy-MM') = '2022-11';
--3-Write a SQL query to calculate the total sales (total_sale) for each category.:
select r.category, sum(r.total_sale)
from Retail_Sales r
group by r.category
--4-Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select r.category, avg(r.age) 
from Retail_Sales r
group by r.category
having r.category ='Beauty'
--5-Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from Retail_Sales
where total_sale > 1000
--6-Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select gender , sum(r.transactions_id) as [total transaction]
from Retail_Sales r
group by gender

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
--7**-Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year(r.sale_date) as year, month(r.sale_date)as month ,avg(total_sale) as total
from Retail_Sales r
group by MONTH(r.sale_date) ,YEAR(r.sale_date)
order by YEAR(r.sale_date), AVG(total_sale) desc

select YEAR(r.sale_date),MONTH(r.sale_date),avg(r.total_sale),
rank()over(partition by YEAR(r.sale_date)order by avg(r.total_sale)desc)
from Retail_Sales r
group by YEAR(r.sale_date),MONTH(r.sale_date)
--8-**Write a SQL query to find the top 5 customers based on the highest total sales **:
select top(5)r.customer_id ,sum(r.total_sale) as [total sales]
from Retail_Sales r
group by r.customer_id
order by sum(r.total_sale)  desc
--9-Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT count(DISTINCT customer_id) as count, category
FROM Retail_Sales r
group by category;
--10-Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
--the end 