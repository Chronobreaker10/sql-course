select row_number() over (order by votes desc) as place, name, rating from films order by votes desc;

select row_number() over () as line_num, order_id, product_id from orders_products order by order_id, product_id;

select row_number() over (order by price) as num, name, count, price from products order by price offset 10 limit 5;