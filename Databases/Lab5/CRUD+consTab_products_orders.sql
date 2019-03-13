CREATE PROC CRUD_Insert_products_orders @productCode int, @brochureID int, @orderID int
AS
	IF dbo.existaIdProductsOrders(@productCode, @brochureID, @orderID) =1
		PRINT ('Aceasta legatura products-orders exista deja!')
	ELSE
	IF dbo.existaIdProducts(@productCode, @brochureID) =0
		PRINT ('Nu exista acest cod+brochure in tabela products')
	ELSE
	IF dbo.existaIdOrders(@orderID) =0
		PRINT ('Nu exista acest id in tabela orders')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareID(@brochureID) = 1 AND dbo.validareID(@orderID) = 1
		INSERT INTO products_orders
		VALUES (@productCode, @brochureID, @orderID)
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Select_products_orders @productCode int, @brochureID int, @orderID int
AS
	IF dbo.existaIdProductsOrders(@productCode, @brochureID, @orderID) =0
		PRINT ('Aceasta legatura products-orders nu exista!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareID(@brochureID) = 1 AND dbo.validareID(@orderID) = 1
		SELECT * FROM products_orders WHERE productCode=@productCode and brochureID=@brochureID and orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Update_products_orders @productCode int, @brochureID int, @orderID int
AS
	IF dbo.existaIdProductsOrders(@productCode, @brochureID, @orderID) =0
		PRINT ('Aceasta legatura products-orders nu exista!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareID(@brochureID) = 1 AND dbo.validareID(@orderID) = 1
		UPDATE products_orders
		SET productCode=@productCode, brochureID=@brochureID, orderID=@orderID
		WHERE productCode=@productCode and brochureID=@brochureID and orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Delete_products_orders @productCode int, @brochureID int, @orderID int
AS
	IF dbo.existaIdProductsOrders(@productCode, @brochureID, @orderID) =0
		PRINT ('Aceasta legatura products-orders nu exista!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareID(@brochureID) = 1 AND dbo.validareID(@orderID) = 1
		DELETE FROM products_orders WHERE productCode=@productCode and brochureID=@brochureID and orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

ALTER TABLE products_orders
ADD CONSTRAINT c_products_orders
CHECK (productCode >= 0 and brochureID >=0 and orderID >=0);

EXEC CRUD_Insert_products_orders 1, 1, 1
EXEC CRUD_Select_products_orders 1, 1, 1
EXEC CRUD_Delete_products_orders 1, 1, 1
--EXEC CRUD_Update_products_orders 1, 1, 1

EXEC CRUD_Insert_orders 1,'2018-07-05','platita'
EXEC CRUD_Select_orders 1
EXEC CRUD_Delete_orders 1
EXEC CRUD_Update_orders 1,'2017-07-20','neplatita'

EXEC CRUD_Insert_products 1, 1, null, 'ruj', 30 
EXEC CRUD_Select_products 1, 1
EXEC CRUD_Delete_products 1, 1
EXEC CRUD_Update_products 1, 1, null, 'ruj', 100 

INSERT INTO brochures(brochureID,startDate,endDate)
VALUES(1,'2018-01-01','2018-01-25')

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