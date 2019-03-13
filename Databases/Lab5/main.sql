CREATE PROC adauga_date
AS

DECLARE @i int
SET @i=1;

DELETE FROM products_orders;
DELETE FROM orders;
DELETE FROM orderDetails;
DELETE FROM payments;
DELETE FROM products;
DELETE FROM productsDetails;
DELETE FROM pages;
DELETE FROM brochures;
DELETE FROM customers;
DELETE FROM customerDetails;

WHILE @i<=10000
BEGIN
	DECLARE @t varchar(20)
	DECLARE @c varchar(20)
	if @i % 2 = 0
		begin SET @t='platita' SET @c='cosmetice' end
	else
		begin SET @t='neplatita'SET @c='ceasuri' end

	INSERT INTO productsDetails(productCode,productType,productFirm,productColor,productDesc)
	VALUES(@i,@c,'mark'+CONVERT (VARCHAR (30), @i),'red'+CONVERT (VARCHAR (30), @i),'ruj mark'+CONVERT (VARCHAR (30), @i));

	INSERT INTO products(productCode,brochureID,pageNumber,productName,productPrice)
	VALUES (@i,@i,null,'ruj mark'+CONVERT (VARCHAR (30), @i),20);

	INSERT INTO orderDetails(orderID,shippedDate,quantity,price)
	VALUES (@i,'2018-07-05',10,100);

	INSERT INTO payments(paymentID,paymentDate)
	VALUES (@i,'2018-01-02');

	INSERT INTO customerDetails(customerID,customerAddress,cardNumber,ages)
	VALUES (@i,'Cluj, Zorilor, Bloc 5',123456789,21)

	INSERT INTO orders(orderID,customerID,paymentID,orderDate,statusOrder)
	VALUES (@i,null,@i,'2018-07-05',@t);

	INSERT INTO products_orders(productCode,brochureID,orderID)
	VALUES (@i,@i,@i)

	SET @i=@i+1
END
GO

EXEC adauga_date

--------------------------------------------

CREATE VIEW view1 AS
SELECT p.productCode,p.productType
FROM productsDetails p
WHERE p.productType='cosmetice'

SELECT * FROM view1

CREATE VIEW view2 AS
SELECT o.orderID,o.statusOrder
FROM orders o
WHERE o.statusOrder='platita'

SELECT * FROM view2

--------------------------------------------
CREATE NONCLUSTERED INDEX idx_nc_productsDetails_productType
	ON productsDetails (productType)

DROP INDEX productsDetails.idx_nc_productsDetails_productType

CREATE NONCLUSTERED INDEX idx_nc_orders_statusOrder
	ON orders (statusOrder)

DROP INDEX orders.idx_nc_orders_statusOrder
--------------------------------------------

SELECT * FROM products_orders;
SELECT * FROM orders;
SELECT * FROM orderDetails;
SELECT * FROM payments;
SELECT * FROM products;
SELECT * FROM productsDetails;
SELECT * FROM pages;
SELECT * FROM brochures;
SELECT * FROM customers;
SELECT * FROM customerDetails;