                   -- Pizza Restaurant Sales Data Exploration in SQL.

/*Objective:
The primary objective of this project is to leverage Microsoft SQL to extract valuable insights from the Pizza Sales dataset. 
Throughout this project, we will showcase various SQL techniques such as temporary tables,common table expressions (CTEs),
and subqueries. Additionally, we will explore the use of mathematical functions, and aggregation 
to derive meaningful metrics from the dataset.*/



--- Extracting the data
select * from Pizza_Sales



--- What's our average order value?
select AVG(total_price) as average_order_value
from Pizza_Sales



--- How many unique pizzas we have?
select DISTINCT pizza_name as unique_pizzas
from Pizza_Sales



--- How many unique pizzas (pizza_id) are sold?
select count(DISTINCT pizza_id) as unique_pizzas_sold
from Pizza_Sales



--- Sales Variation by Pizza Size
select pizza_size, SUM(total_price) as size_sales
from Pizza_Sales
group by pizza_size



--- Most pizza quantities sold
select pizza_name, count(quantity) as pizza_sold from Pizza_Sales
group by pizza_name
order by pizza_sold desc



--- Most sales by pizza
select pizza_name,SUM(total_price) as total_sales from Pizza_Sales
group by pizza_name
order by total_sales desc



--- What is the average price and total sales of a pizza per category?
select pizza_category, AVG(unit_price) as avg_price_category, SUM(total_price) as total_sales
from Pizza_Sales
group by pizza_category


-----------------------------------------------------------------------------------------------------------


--- What are the best and worst-selling pizzas?

 -- Best selling pizzas based on quantity
select top 1 pizza_name, sum(quantity) as total_pizzas_sold
from Pizza_Sales
group by pizza_name
order by total_pizzas_sold desc

 -- Worst selling pizzas based on quantity
select top 1 pizza_name, sum(quantity) as total_pizzas_sold
from Pizza_Sales
group by pizza_name
order by total_pizzas_sold


-----------------------------------------------------------------------------------------------------------


--- What days and times do we tend to be busiest?
select 
    datepart(WEEKDAY, order_date) AS day_of_week,
    datename(WEEKDAY,order_date) as day_name,
    datepart(HOUR,order_time) as hour_of_day,
    count(*) as order_count
from Pizza_Sales
group by 
    datename(WEEKDAY,order_date),  
    datepart(HOUR,order_time), 
    datepart(WEEKDAY, order_date)
order by 
    order_count desc


-----------------------------------------------------------------------------------------------------------


--- How many pizzas are we making during peak periods?

 -- Lets find peak hours first
select 
    DATEPART(HOUR, order_time) as hour_of_the_day, 
	count(*) as orders_count
from Pizza_Sales
group by DATEPART(HOUR, order_time)
order by orders_count desc

 -- Peak periods are considered between 12 PM and 10 PM. 
select 
    count(*) AS pizzas_made_during_peak
from Pizza_Sales
where 
    cast(order_time as time) between '12:00' and '20:00'
	

-----------------------------------------------------------------------------------------------------------


--- Are there peak times for placing orders during the day?
select 
    DATEPART(HOUR, order_time) as hour_of_the_day, 
	count(*) as orders_count
from Pizza_Sales
group by DATEPART(HOUR, order_time)
order by orders_count desc



--- What is the total sales revenue over a period?
select DATEPART(MONTH,order_date) as month_of_year, SUM(total_price) as sales_by_month
from Pizza_Sales
group by DATEPART(MONTH,order_date)
order by sales_by_month desc



--- Most popular ingredients used.
select pizza_ingredients, COUNT(*) AS ingredient_count
from Pizza_Sales
group by pizza_ingredients
order by ingredient_count desc


-----------------------------------------------------------------------------------------------------------


--- Subqueries
 -- Identifying orders where the total price is higher than the average total price across all orders.
select order_id, total_price 
from 
    Pizza_Sales 
where 
    total_price > (select AVG(total_price) from Pizza_Sales)


-----------------------------------------------------------------------------------------------------------


--- Temp table
 -- Creating a temporary table that stores the total sales for each pizza category.

create table #Temp_Total_Sales
(
pizza_category nvarchar(255),
category_sales decimal(10, 2)
)

insert into #Temp_Total_Sales
  select 
      pizza_category,SUM(total_price) as category_sales
  from 
      Pizza_Sales
  group by 
      pizza_category
 
 select * from #Temp_Total_Sales


 -----------------------------------------------------------------------------------------------------------


--- CTE's
 -- CTE's is not stored anywhere
 -- Find the average quantity of pizzas ordered per transaction, using a CTE.

WITH Avg_Quantity_CTE as 
(select order_id, AVG(quantity * 1.0) AS avg_quantity 
from Pizza_Sales 
group by order_id )

select * from Avg_Quantity_CTE


-----------------------------------------------------------------------------------------------------------

/*Summary

From the above analysis we found out the following insights:

* We have 32 unique varities of pizzas.
* "The Classic Deluxe Pizza" is the most sold pizza.
* "The Brie Carre Pizza" is the least sold pizza.
* "The Thai Chicken Pizza" has made the most sales.
* The peak hours are from '12:00' and '20:00'.
* In the month of july we have made the most sales.*/
