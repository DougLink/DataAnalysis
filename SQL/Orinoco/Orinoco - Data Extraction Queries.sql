-- New shoppers and female shoppers information for a marketing campaign
SELECT shopper_first_name AS 'First Name', shopper_surname AS 'Surname', shopper_email_address AS 'E-mail Address', strftime('%d-%m-%Y',date_joined) AS 'Date Joined', IFNULL(gender,'Not Known') AS 'Gender',
CASE 
WHEN strftime('%m', date('now')) > strftime('%m', date(date_of_birth)) THEN strftime('%Y', date('now')) - strftime('%Y', date(date_of_birth)) 
WHEN strftime('%m', date('now')) = strftime('%m', date(date_of_birth)) THEN 
CASE 
WHEN strftime('%d', date('now')) >= strftime('%d', date(date_of_birth)) THEN strftime('%Y', date('now')) - strftime('%Y', date(date_of_birth)) 
ELSE strftime('%Y', date('now')) - strftime('%Y', date(date_of_birth)) - 1 
END 
WHEN strftime('%m', date('now')) < strftime('%m', date(date_of_birth)) THEN strftime('%Y', date('now')) - strftime('%Y', date(date_of_birth)) - 1 
END AS 'Age' 
FROM shoppers 
WHERE gender IS 'F' OR date_joined >= '2020-01-01' 
ORDER BY Gender, Age DESC; 


-- Customer account history using shopper_id as parameter for website
SELECT shopper_first_name AS 'First Name', shopper_surname AS 'Surname', so.order_id AS 'Order Number', strftime('%d-%m-%Y',order_date) AS 'Order Date', product_description AS 'Product Description', seller_name AS 'Seller Name', op.quantity AS 'Quantity', PRINTF('£%.2f', op.price) AS 'Price', ordered_product_status AS 'Ordered Product Status' 
FROM shoppers s 
INNER JOIN shopper_orders so ON s.shopper_id = so.shopper_id 
INNER JOIN ordered_products op ON so.order_id = op.order_id 
INNER JOIN product_sellers ps ON op.product_id = ps.product_id AND op.seller_id = ps.seller_id 
INNER JOIN products p ON ps.product_id = p.product_id 
INNER JOIN sellers sell ON ps.seller_id = sell.seller_id 
WHERE s.shopper_id=@ShopperID 
ORDER BY order_date DESC;


-- Sales summary report for the business relationship manager
SELECT s.seller_account_ref AS 'Seller Account REF', s.seller_name AS 'Seller Name', IFNULL(p.product_code, 0) AS 'Product Code', IFNULL(p.product_description, 0) AS 'Product Description', SUM(IFNULL(op.quantity, 0)) AS 'Total Quantity Sold', PRINTF("£%.2f", SUM((IFNULL(op.quantity, 0) * ps.price))) AS 'Total Sales' 
FROM sellers s 
LEFT OUTER JOIN product_sellers ps ON s.seller_id = ps.seller_id 
LEFT OUTER JOIN ordered_products op ON ps.seller_id = op.seller_id AND ps.product_id = op.product_id
LEFT OUTER JOIN products p ON ps.product_id = p.product_id 
GROUP BY p.product_id, s.seller_id 
ORDER BY [Total Quantity Sold];


-- Sales Report of products that have sold less than the average of its category 
SELECT category_description AS 'Category Description', product_code AS 'Product Code', product_description AS 'Product Description', PRODAVG.[Average Quantity Sold], CATAVG.[Average Quantity Sold per Category]
FROM
(SELECT c.category_id, category_description, product_code, product_description, PRINTF('%.2f', IFNULL(AVG(quantity), 0)) AS 'Average Quantity Sold'
FROM products p
INNER JOIN categories c ON p.category_id=c.category_id
LEFT OUTER JOIN ordered_products op ON p.product_id=op.product_id
LEFT OUTER JOIN shopper_orders so ON op.order_id=so.order_id
WHERE order_status <>'Cancelled' OR order_status IS NULL
GROUP BY p.product_id) AS PRODAVG
INNER JOIN
(SELECT c.category_id, PRINTF('%.2f', IFNULL(AVG(quantity), 0)) AS 'Average Quantity Sold per Category'
FROM products p
INNER JOIN categories c ON p.category_id=c.category_id
LEFT OUTER JOIN ordered_products op ON p.product_id=op.product_id
LEFT OUTER JOIN shopper_orders so ON op.order_id=so.order_id
WHERE order_status <>'Cancelled' OR order_status IS NULL
GROUP BY c.category_id) AS CATAVG
ON PRODAVG.category_id=CATAVG.category_id
WHERE PRODAVG.[Average Quantity Sold]<CATAVG.[Average Quantity Sold per Category]
ORDER BY PRODAVG.category_description, PRODAVG.product_description;
