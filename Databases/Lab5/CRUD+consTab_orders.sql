CREATE PROC CRUD_Insert_orders @orderID int, @orderDate date, @statusOrder varchar(20)
AS
	IF dbo.existaIdOrders(@orderID) =1 
		PRINT ('Acest Id este deja folosit!')
	ELSE
	IF dbo.existaIdorderDetails(@orderID) =0
		PRINT ('Nu exista acest id in tabela orderDetails')
	ELSE
	BEGIN
	IF dbo.validareID(@orderID) = 1 AND dbo.validareStatus(@statusOrder) = 1
		INSERT INTO orders(orderID,customerID, paymentID, orderDate, statusOrder)
		VALUES (@orderID, null, null, @orderDate, @statusOrder)
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Select_orders @orderID int
AS
	IF dbo.existaIdOrders(@orderID) = 0
		PRINT ('Nu exista nicio inregistrare!')
	ELSE
	BEGIN
	IF dbo.validareID(@orderID) = 1
		SELECT * FROM orders WHERE orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Update_orders @orderID int, @orderDate date, @statusOrder varchar(20)
AS
	IF dbo.existaIdOrders(@orderID) = 0
		PRINT ('Nu exista nicio inregistrare cu acest id!')
	ELSE
	BEGIN
	IF dbo.validareID(@orderID) = 1 AND dbo.validareStatus(@statusOrder) = 1
		UPDATE orders
		SET orderID=@orderID, customerID=null, paymentID = null, orderDate= @orderDate, statusOrder= @statusOrder
		WHERE orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Delete_orders @orderID int
AS
	IF dbo.existaIdOrders(@orderID) = 0
		PRINT ('Nu exista nicio inregistrare cu acest id!')
	ELSE
	BEGIN
	IF dbo.validareID(@orderID) = 1
		DELETE FROM orders WHERE orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

ALTER TABLE orders
ADD CONSTRAINT c_orders
CHECK (orderID >= 0 and statusOrder in ('platita','neplatita') );

EXEC CRUD_Insert_orders 1,'2018-07-05','platita'
EXEC CRUD_Select_orders 1
EXEC CRUD_Delete_orders 1
EXEC CRUD_Update_orders 1,'2017-07-20','neplatita'

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