Create Table customers(
customer_id varchar(100),
customer_unique_id varchar(100),
customer_zip_code_prefix int,
customer_city varchar(50),
customer_state varchar(50)
);
Select * from customers;

Create Table geolocation(
geolocation_zip_code_prefix int,
geolocation_lat float,
geolocation_lng float,
geolocation_city varchar(50),
geolocation_state varchar(50)
);
Select * from geolocation;

Create Table order_items(
order_id Varchar(100),
order_item_id int,
product_id Varchar(100),
seller_id Varchar(100),
shipping_limit_date TIMESTAMP,
price float,
freight_value float
);
Select * from order_items;

Create Table order_payments(
order_id Varchar(100),
payment_sequential int,
payment_type Varchar(50),
payment_installments int,
payment_value float
);
Select * from order_payments;

Create Table order_reviews(
review_id Varchar(100),
order_id Varchar(100),
review_score int, 
review_comment_title Varchar(100),
review_comment_message Varchar(500),
review_creation_date TIMESTAMP,
review_answer_timestamp TIMESTAMP
);
Select * from order_reviews;

Create Table orders(
order_id Varchar(100),
customer_id Varchar(100),
order_status Varchar(50),
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP
);
Select * from orders;

Create Table products(
product_id Varchar(100),
product_category_name Varchar(100),
product_name_lenght float,
product_description_lenght float,
product_photos_qty float,
product_weight_g float,
product_length_cm float,
product_height_cm float,
product_width_cm float
);
Select * from products;

Create Table sellers(
seller_id Varchar(100),
seller_zip_code_prefix int,
seller_city Varchar(50),
seller_state Varchar(50)
);
Select * from sellers;


---- 1.Total orders ----
Select count(*) as total_orders
from orders;

---- 2.Total customers ----
Select count(Distinct customer_unique_id) as total_customers
from customers;

---- 3.Total revenue ----
Select sum(price) as total_revenue
from order_items;

---- 4.Average order value ----

With t1 as(
Select order_id, sum(price) as order_value
from order_items
group by order_id)
Select avg(order_value) as Average_order_value
from t1;

                   ------ Sales Analysis --------
				   
---- 5.Revenue by month ----
Select Extract(YEAR from o.order_purchase_timestamp) as year,
       Extract(MONTH from o.order_purchase_timestamp) as month,
	   round(sum(oi.price)::numeric, 2)) as total_revenue
from orders o
join
order_items oi
on o.order_id = oi.order_id
group by year, month
order by year, month;
	   
---- 6.Top product categories by revenue ----
Select p.product_category_name as product_category_name,
round(sum(oi.price)::numeric, 2) as total_revenue
from products p
join
order_items oi
on p.product_id = oi.product_id
group by p.product_category_name
order by total_revenue desc;

---- 7.Top categories by number of items sold ----
Select p.product_category_name as product_category_name,
sum(oi.order_item_id) as total_items_sold
from products p
join
order_items oi
on p.product_id = oi.product_id
group by product_category_name
order by total_items_sold desc;

             ------- Customer Analysis -------

---- 8.Customers by state ----
Select customer_state, count(Distinct customer_unique_id) as total_customers
from customers
group by customer_state
order by total_customers desc;

---- 9.Revenue by customer state ----
Select c.customer_state as customer_state, round(sum(oi.price)::numeric, 2) as total_revenue
from customers c
join 
orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
group by customer_state
order by total_revenue desc;

---- 10.Repeat customers ----
Select customer_unique_id,
count(Distinct customer_id) as total_orders
from customers
group by customer_unique_id
Having count(Distinct customer_id) > 1
order by total_orders desc;

                ------- Payment Analysis --------

---- 11.Payment method popularity ----
Select payment_type, count(*) as payment_count
from order_payments
group by payment_type
order by payment_count desc;

---- 12.Revenue/payment value by payment type ----
Select payment_type, round(sum(payment_value)::numeric, 2) as total_payment_value,
round(avg(payment_value)::numeric, 2) as avg_payment_value
from order_payments
group by payment_type
order by total_payment_value desc;

---- 13.Average installments by payment type ----
Select payment_type, sum(payment_installments) as total_installments,
round(avg(payment_installments), 2) as average_installments
from order_payments
group by payment_type
order by total_installments desc;

                ------ Order Status Analysis ------

---- 14.Orders by status ----
Select order_status, count(order_id) as total_orders
from orders
group by order_status
order by total_orders desc;

---- 15.Cancellation rate ----
SELECT
    100.0 * SUM(
        CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END
    ) / COUNT(*) AS cancellation_rate
FROM orders;

               -------- Seller Analysis --------

---- 16.Top sellers by revenue ----
Select seller_id, round(sum(price)::numeric, 2) as total_revenue
from order_items
group by seller_id
order by total_revenue;

---- 17.Seller performance by state ----
Select s.seller_state, count(Distinct s.seller_id) as sellers,
round(sum(oi.price)::numeric, 2) as total_revenue
from sellers s
join
order_items oi
on s.seller_id = oi.seller_id
group by s.seller_state
order by total_revenue desc

              ------ Review Analysis ------

---- 18.Review score distribution ----
Select review_score, count(*) as total_reviews
from order_reviews
group by review_score
order by review_score;

---- 19.Average review score ----
Select avg(review_score) as average_review_score
from order_reviews;

---- 20.Review score vs order status ----
Select o.order_status, round(avg(r.review_score), 2) as average_review_score
from orders o
join
order_reviews r
on o.order_id = r.order_id
group by o.order_status
order by average_review_score desc;

                    ------ Delivery Performance ------

---- 21.Average delivery time ----
Select avg(order_delivered_customer_date - order_purchase_timestamp) as average_delivery_time
from orders
where order_delivered_customer_date is not null;

---- 22.Late deliveries ----
Select count(*) as late_orders
from orders
where order_delivered_customer_date > order_estimated_delivery_date;

---- 23.Late delivery percentage ----
Select 
    100.0 * Sum(
            Case When order_delivered_customer_date > order_estimated_delivery_date
			Then 1
			Else 0
			End
	)/count(*) as late_delivery_percentage
from orders
where order_delivered_customer_date is not null;

       -----   24. Top 3 categories in each state  ------
With t1 as (
Select c.customer_state, p.product_category_name, round(sum(oi.price)::numeric, 2) as revenue
from customers c
join orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
Group by c.customer_state, p.product_category_name),
t2 as (
Select *, dense_rank() over (partition by customer_state order by revenue desc) as category_rank
from t1)
Select customer_state, product_category_name, revenue from t2
where category_rank < 4;

        ---- 25. Monthly Revenue + Month-over-Month Growth -----
With t1 as (
Select Extract (Year from o.order_purchase_timestamp) as year,
       Extract (Month from o.order_purchase_timestamp) as month,
	   Round(sum(oi.price)::numeric, 2) as revenue
from orders o
join
order_items oi
on o.order_id = oi.order_id
Group by year, month
),
t2 as (
Select *, lag(revenue) over(Order by year, month) as previous_month_revenue
from t1)
Select *, Round(
100.0 * (revenue - previous_month_revenue)/nullif(previous_month_revenue, 0), 2) as mom_growth_percentage
from t2
order by year, month

         ----- 26. Customer Lifetime Value -----
Select c.customer_unique_id, count(Distinct c.customer_id) as total_orders,
Round(sum(oi.price)::numeric, 2) as lifetime_value
from customers c
join orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
Group by c.customer_unique_id
order by lifetime_value desc

        ---- 27. Customer Ranking Within Each State (Top 5 Customers in each State) ----
With t1 as (
Select c.customer_state, c.customer_unique_id, round(sum(oi.price)::numeric, 2) as revenue
from customers c
join orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
group by c.customer_state, c.customer_unique_id),
t2 as (
Select *, dense_rank() over(partition by customer_state order by revenue desc) as ranking
from t1)
Select customer_state, customer_unique_id, revenue from t2
where ranking < 6;

                  ---- 28. Repeat vs One-Time Customers ----
With t1 as (
Select c.customer_unique_id, count(Distinct o.order_id) as total_orders
from customers c
join
orders o
on c.customer_id = o.customer_id
group by c.customer_unique_id)
Select case 
        when total_orders = 1 Then 'One Time Customer'
		Else 'Repeat Customer'
		End as customer_type,
		count(*) as total_customers
from t1
group by
      case 
        when total_orders = 1 Then 'One Time Customer'
		Else 'Repeat Customer'
		End;

         ----- 29. Seller Revenue Ranking -----
With t1 as (
Select seller_id,round(sum(price)::numeric, 2) as revenue
from order_items
group by seller_id
order by revenue desc limit 10)
Select *, dense_rank() over(Order by revenue desc) as ranking
from t1

             ------ 30. Delivery Performance by State ------
With t1 as (
Select c.customer_state, o.order_id,
(order_delivered_customer_date - order_purchase_timestamp) as delievery_days
from customers c
join
orders o
on c.customer_id = o.customer_id
where order_delivered_customer_date is not null)
Select customer_state, count(order_id) as delivered_orders,
Avg(delievery_days) as avg_delievery_time
from t1
group by customer_state
order by avg_delievery_time;

               ----- 31. Above-Average Product Categories ------
With t1 as (
Select p.product_category_name, round(sum(oi.price)::numeric, 2) as revenue
from products p
join 
order_items oi
on p.product_id = oi.product_id
group by p.product_category_name)
Select * from t1
where revenue > (Select Avg(revenue) from t1)
order by revenue desc;




Select * from customers;
Select * from geolocation;
Select * from order_items;
Select * from order_payments;
Select * from order_reviews;
Select * from orders;
Select * from products;
Select * from sellers;

