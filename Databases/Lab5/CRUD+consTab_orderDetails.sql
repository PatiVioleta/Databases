CREATE PROC CRUD_Insert_orderDetails @orderID int, @shippedDate date, @quantity int, @price real
AS
	IF dbo.existaIdorderDetails(@orderID) =1 
		PRINT ('Acest Id este deja folosit!')
	ELSE
	BEGIN

	IF dbo.validareID(@orderID) = 1 AND dbo.validareNrPozitiv(@quantity) = 1 AND dbo.validareNrPozitiv(@price) = 1
		INSERT INTO orderDetails(orderID,shippedDate,quantity,price)
		VALUES (@orderID,@shippedDate,@quantity,@price)
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Select_orderDetails @orderID int
AS
	IF dbo.existaIdorderDetails(@orderID) = 0
		PRINT ('Nu exista nicio inregistrare!')
	ELSE
	BEGIN
	IF dbo.validareID(@orderID) = 1
		SELECT * FROM orderDetails WHERE orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Update_orderDetails @orderID int, @shippedDate date, @quantity int, @price real
AS
	IF dbo.existaIdorderDetails(@orderID) = 0
		PRINT ('Nu exista nicio inregistrare cu acest id!')
	ELSE
	BEGIN
	IF dbo.validareID(@orderID) = 1 AND dbo.validareNrPozitiv(@quantity) = 1 AND dbo.validareNrPozitiv(@price) = 1
		UPDATE orderDetails
		SET shippedDate=@shippedDate, quantity=@quantity, price=@price
		WHERE orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Delete_orderDetails @orderID int
AS
	IF dbo.existaIdorderDetails(@orderID) = 0
		PRINT ('Nu exista nicio inregistrare cu acest id!')
	ELSE
	BEGIN
	IF dbo.validareID(@orderID) = 1
		DELETE FROM orderDetails WHERE orderID=@orderID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

ALTER TABLE orderDetails
ADD CONSTRAINT c_orderDetails
CHECK (orderID >= 0 and quantity>0 and price>0);

EXEC CRUD_Insert_orderDetails 1, '2018-10-10',2 ,25
EXEC CRUD_Select_orderDetails 1
EXEC CRUD_Delete_orderDetails 1
EXEC CRUD_Update_orderDetails 1, '2018-10-10',4 ,50

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