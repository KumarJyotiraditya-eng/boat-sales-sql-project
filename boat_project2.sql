CREATE DATABASE Boat;
use boat;

select * from boat_customer;
select * from order_boat;
select * from order_detail;
select * from products;
select * from returns;

# boat_customer
select * from boat_customer;
describe boat_customer;

alter table boat_customer
modify phone char(10);

alter table boat_customer
modify postal_code char(6);

set sql_safe_updates= 0;

Update boat_customer
set registration_date = replace(registration_date, '/','-');

update boat_customer
set registration_date = str_to_date(registration_date, '%d-%m-%Y');

Alter table boat_customer
modify registration_date date;

#order boat
select * from order_boat;
describe order_boat;

update order_boat
set 
order_date = replace(order_date, '/','-'),
shipped_date = replace(shipped_date, '/','-'),
delivery_date = replace(delivery_date, '/','-');

update order_boat
set 
order_date = str_to_date(order_date,'%d-%m-%Y'),
shipped_date = str_to_date(shipped_date,'%d-%m-%Y'),
delivery_date = str_to_date(delivery_date,'%d-%m-%Y');

 Alter table order_boat
 modify order_date date,
 modify shipped_date date,
 modify delivery_date date;
 
 #order  details
 select * from order_detail;
 describe order_detail;
 
 Alter table order_detail
 modify discount_percent float;
 
 #products
 select * from products;
 describe products;
 
Alter table products
modify rating float;
 

#returns
select * from returns;
describe returns;

update returns
set return_date = replace(return_date, '/','-');

update returns
set return_date =  str_to_date(return_date, '%d-%m-%Y');

alter table returns
modify return_date date;


# Find tha total_customer.

select count(customer_id) as total_customer from boat_customer;

select * from boat_customer;

# find tha total customer according the month.

Select
count(distinct customer_id) AS total_customer,
monthname(registration_date) AS month_name
From boat_customer
group by monthname(registration_date);


# Find tha customer according the state.
select
count(distinct customer_id) as total_customer, state from boat_customer
group by state;


# What is avg age of customer.

select 
sum(age)/count(age) as AVG_AGE
from boat_customer;


# total order

select 
sum(customer_id) as total_order from boat_customer;

select * from boat_customer;

# thotal according tha payment method
select
count(distinct customer_id) as total_payment, payment_method
from order_boat
group by payment_method;

# total order according tha month.
select
count(order_id) as total_order,
monthname(order_date) as order_month
from order_boat
group by(order_month);

select * from order_boat;
# total order according tha order channel.

select 
count(order_id) as total_order, order_channel
from order_boat
group by order_channel;


# how many product order in may month. where order status is shipped.

select
count(order_id) as total_order from order_boat
where
monthname(order_date) = 'May' 
and order_status = 'shipped' ;

# total Qty.
select
sum(quantity) as total_qty 
from order_detail;


select * from  order_detail;

# find total Amount.

select 
sum(unit_price) as total_amount from order_detail;


# Total Product
select
count(product_id) as total_product from order_detail;

# product according tha category.
select
count(product_id) as total_product, product_name, category from products
group by product_name, category;

select * from products;

# Avg rating for each category.

select 
sum(product_id)/count(rating) as AVG_Rating, category from products
group by category;
# product according tha review.

select
count(product_id) as total_product, review,product_name
from products
group by review,product_name;

# total Return product.
select * from returns;

select 
count(return_id) as total_return from returns;

# total Return product according tha reason.
select
count(return_id) as Total_return, reason
from returns
group by reason;

# total Return product according refund status.

select 
count(return_id) as total_return, refund_status
from returns
group by refund_status;


select
count(return_id) as total_return,
monthname(return_date) as Month_name
from returns
group by month_name;


#1. Find top 5 highest priced products.
select
product_name,MRP from products
order by MRP desc
limit 5;

# 2. Find how many orders each customer placed.
select * from products;

select
sum(order_id)/count(customer_id) as Total_order from order_boat;

select * from boat_customer;
select * from order_boat;
select * from order_detail;
select * from products;
select * from returns;

#3. Find top 5 customers by revenue.
select 
concat( b.name,' ',b.last_name) as Nam,
sum(d.unit_price) as total_spent 
from order_boat o
join boat_customer b
on b.customer_id = o.customer_id
join order_detail d
on d.order_id = o.order_id
group by b.name,b.last_name
order by total_spent desc
limit 5;

# 4. Find the most sold product.
select
p.product_name,
sum(o.quantity) as Most_sold
from products p
join order_detail o
on p.product_id = o.product_id
group by p.product_name
order by Most_sold desc
limit 1;


# 5. Find customers who ordered more than once.
select
p.product_name
from products p
join order_detail o
on p.product_id = o.product_id
where o.quantity > '1'
group by p.product_name;

# Show the monthly growth (increase/decrease in revenue).

select
p.product_name,
sum(o.quantity) as Total_sell,
monthname(b.order_date) as Monthly_sell
from products p
join order_detail o
on p.product_id = o.product_id
join order_boat b
on b.order_id = o.order_id
group by p.product_name, monthly_sell
order by Monthly_sell desc;


#7. Calculate return rate.
select
sum(o.order_id)/sum(r.return_id) as return_rate
from returns r
join order_detail o
on o.order_detail_id = r.order_detail_id;

#8. Find most returned product.
select
p.product_name,
count(r.return_id) as Total_return
from products p
join order_detail o
on o.product_id = p.product_id
join returns r
on r.order_detail_id = o.order_detail_id
group by p.product_name
order by total_return desc
limit 1 ;

#9. Which product is most profitable?
select
p.product_name,
sum(o.quantity) as total_profit
from products p
join order_detail o
on o.product_id = p.product_id
group by p.product_name
order by total_profit desc
limit 1;


# 10. Find inactive customers (no orders in last 30/60 days).
select * from boat_customer;
select * from order_boat;
select * from order_detail;
select * from products;
select * from returns;

select
b.name,b.last_name
from order_boat o 
join boat_customer b
on o.customer_id = b.customer_id
where o.order_date >= '2025-09-09'- interval 30 DAY;

SELECT MIN(order_date), MAX(order_date) FROM order_boat;



#11. Find 2nd highest selling product.
select
p.product_name,
sum(o.quantity) as total_profit
from products p
join order_detail o
on o.product_id = p.product_id
group by p.product_name
order by total_profit desc
limit 1, 1;



#12. Find customers who ordered in consecutive days.
select
b.name,
b.last_name,
o1.order_date as First_day,
o2.order_date as Last_day
from order_boat o1
join order_boat o2
on o1.customer_id = o2.customer_id
and datediff(o1.order_date,o2.order_date) = 1
join boat_customer b
on b.customer_id = o1.customer_id
group by b.name, b.last_name, first_day, last_day;

#13. Find customers who spent above average.
select
order_id,
avg(unit_price * quantity) as avg_ 
from order_detail
group by order_id;

select 
b.name,
b.last_name






SELECT
b.name,
b.last_name,
AVG(d.quantity) AS avg_t
FROM boat_customer b
JOIN order_boat o
ON b.customer_id = o.customer_id
JOIN order_detail d
ON o.order_id = d.order_id
GROUP BY b.customer_id, b.name, b.last_name;


#14. Find orders with maximum number of items.

select
p.product_name,
sum(o.quantity) as MAX_ORDER
from products p
join order_detail o
on o.product_id = p.product_id
group by p.product_name
order by MAX_ORDER desc
limit 1;



# 15. Find daily average sales.


# 16. How many products were returned in each category?.

select
p.product_name,
p.category,
sum(r.return_id) as Total_return
from returns r
join order_detail o
on r.Order_Detail_id = o.Order_Detail_id
join products p
on p.product_id = o.product_id
group by p.product_name,p.category
order by p.category;

#17.How many products were returned in February, and what were the reasons for those returns?.
select
p.product_name,
r.reason,
monthname(r.return_date) as Month_name,
count(r.return_id) as Total_return
from returns r
join order_detail o
on r.Order_Detail_id = o.Order_Detail_id
join products p
on p.product_id = o.product_id
where monthname(r.return_date) = 'february'
group by p.product_name,r.reason,Month_name;

#18.How many products were ordered through each order channel, and what is the total amount for each channel?.
select
p.product_name,
o.order_channel,
count(o.order_channel) as Total_order,
sum(b.unit_price * b.quantity) as Total_amount
from products p
join order_detail b
on b.product_id = p.product_id
join order_boat o
on o.order_id = b.order_id
group by p.product_name, o.Order_Channel;


# 19.Find the total revenue generated in May 2024 for each state.
SELECT
    b.name,
    b.last_name,
    b.state,
    monthname(o.order_date) AS month_number,
    SUM(d.unit_price * d.quantity) AS total_revenue
FROM boat_customer b
JOIN order_boat o
    ON b.customer_id = o.customer_id
JOIN order_detail d
    ON o.order_id = d.order_id
WHERE monthname(o.order_date) = 'May'
  AND YEAR(o.order_date) = 2024
GROUP BY b.customer_id, b.name, b.last_name, monthname(o.order_date), b.state;


# 20.How many days does it take for a product to be delivered?
SELECT
order_id,
DATEDIFF(delivery_date, order_date) AS delivery_days
FROM order_boat;

select * from order_boat;