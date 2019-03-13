CREATE PROC CRUD_Insert_products @productCode int, @brochureID int, @pageNumber int, @productName varchar(20), @productPrice real
AS
	IF dbo.existaIdProducts(@productCode, @brochureID) =1
		PRINT ('Acest cod+brochure este deja folosit!')
	ELSE
	IF dbo.existaIdBrochure(@brochureID) =0
		PRINT ('Nu exista acest id in tabela brochure')
	ELSE
	IF dbo.existaIdProductsDetails(@productCode) =0
		PRINT ('Nu exista acest cod in tabela productsDetails')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareID(@brochureID) = 1 AND dbo.validareID(@pageNumber) = 1 AND dbo.validareNrPozitiv(@productPrice) = 1
		INSERT INTO products
		VALUES (@productCode, @brochureID, @pageNumber, @productName, @productPrice)
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Select_products @productCode int, @brochureID int
AS
	IF dbo.existaIdProducts(@productCode, @brochureID) =0
		PRINT ('Nu exista acest cod+brochure!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1
		SELECT * FROM products WHERE productCode=@productCode and brochureID=@brochureID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Update_products @productCode int, @brochureID int, @pageNumber int, @productName varchar(20), @productPrice real
AS
	IF dbo.existaIdProducts(@productCode, @brochureID) =0
		PRINT ('Nu exista acest cod+brochure!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareID(@brochureID) = 1 AND dbo.validareID(@pageNumber) = 1 AND dbo.validareNrPozitiv(@productPrice) = 1
		UPDATE products
		SET pageNumber= @pageNumber, productName= @productName,productPrice= @productPrice
		WHERE productCode=@productCode and brochureID=@brochureID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Delete_products @productCode int, @brochureID int
AS
	IF dbo.existaIdProducts(@productCode, @brochureID) =0
		PRINT ('Nu exista acest cod+brochure!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareID(@brochureID) = 1
		DELETE FROM products WHERE productCode=@productCode and brochureID=@brochureID
	ELSE
		PRINT ('Date incorecte!')
	END
GO

ALTER TABLE products
ADD CONSTRAINT c_products
CHECK (productCode >= 0 and brochureID >=0 and pageNumber >=0 and productPrice>0 );

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