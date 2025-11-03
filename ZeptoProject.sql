Create Database Zepto_Project_db;
Use Zepto_Project_db;
drop table zepto;
create table zepto(
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric (8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock text,
quantity integer);

-- Data Exploration

-- Sample Data-- 
select * from zepto
limit 10;

-- Count of Rows--  
select count(*) from zepto;

-- Null Values-- 
select * from zepto 
where 
Category is null
or 
name is null
or 
mrp is null
or 
discountPercent is null
or 
availableQuantity is null
or 
discountedSellingPrice is null
or 
weightInGms is null
or 
outOfStock is null
or 
quantity is null;

-- different product categories--
select distinct category
from zepto
order by category;

 -- products in stock vs out of stock
 select outOfStock, count(sku_id)
 from zepto
 group by outOfStock;
 
  -- product names present multiple times
  select name, count(sku_id) as "Number of SKU's"
  from zepto 
  group by name
  having count(sku_id) > 1
  order by count(sku_id) desc;
  
  -- data cleaing
  --  products with price = 0
  select * from zepto
  where mrp = 0 or discountedSellingPrice = 0;
  
  delete from zepto
  where mrp = 0;
 
 set sql_safe_updates = 0;
 
 -- Convert paise to rupees
 update zepto 
 set mrp = mrp/100.0,
 discountedSellingPrice = discountedSellingPrice /100.0;
 
 select mrp, discountedSellingPrice from zepto;
 
 -- Q1. Find the top 10 best-value based on the discount percentage.
 
 Select distinct name, mrp,discountPercent
 from zepto
 order by discountPercent desc
 limit 10;
 
 -- Q2. What are the products with High MRP but Out of Stock
 
 Select distinct name,mrp
 from zepto
 where outOfStock = "TRUE" and mrp > 300
 order by mrp desc;
 
 -- Q3. Calculate Estimated Revenue for each category 
 
 Select category,
 sum(discountedSellingPrice * availableQuantity) As total_revenue
 from zepto 
 group by category
 order by total_revenue;
 
 -- Q4. Find all products where MRP is greater than 500/- and discount is less than 10%.

Select distinct name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

 -- Q5. Identify the top 5 categories offering the highest average discount percentage.
 
 Select category,
 Round(avg(discountPercent),2) as avg_discount
 from zepto
 group by category
 order by avg_discount desc
 limit 5;
 
 -- Q6. Find the price per gram for products above 100g and sort by best value.
 
 Select distinct name, weightInGms, discountedSellingPrice,
 Round(discountedSellingPrice/weightInGms,2) as price_per_gram
 from zepto
 where weightInGms >= 100
 order by price_per_gram;
 
 -- Q7. Group the products into categories like Low, Medium and Bulk.
 
 Select distinct name, weightInGms,
 case when weightInGms < 1000 Then 'Low'
	  when weightInGms < 5000 Then 'Medium'
	  Else 'Bulk'
      end as weight_category
from zepto;
 
 -- Q8. What is the total Inventory Weight Per Category
 
 Select category,
 sum(weightInGms * availableQuantity) as Total_weight
 from zepto
 group by category
 order by Total_weight;