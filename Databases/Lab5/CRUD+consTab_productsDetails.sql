CREATE PROC CRUD_Insert_productsDetails @productCode int,@productType varchar(20),@productFirm varchar(20),@productColor varchar(10),@productDesc varchar(100)
AS
	IF dbo.existaIdProductsDetails(@productCode) =1 
		PRINT ('Acest cod de produs este deja folosit!')
	ELSE
	BEGIN

	IF dbo.validareID(@productCode) = 1 AND dbo.validareType(@productType) = 1
		INSERT INTO productsDetails
		VALUES (@productCode,@productType,@productFirm,@productColor,@productDesc)
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Select_productsDetails @productCode int
AS
	IF dbo.existaIdProductsDetails(@productCode) =0 
		PRINT ('Nu exista nicio inregistrare cu acest cod!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1
		SELECT * FROM productsDetails WHERE productCode=@productCode
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Update_productsDetails @productCode int,@productType varchar(20),@productFirm varchar(20),@productColor varchar(10),@productDesc varchar(100)
AS
	IF dbo.existaIdProductsDetails(@productCode) = 0
		PRINT ('Nu exista nicio inregistrare cu acest cod!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1 AND dbo.validareType(@productType) = 1
		UPDATE productsDetails
		SET productType=@productType, productFirm=@productFirm, productColor=@productColor, productDesc=@productDesc
		WHERE productCode=@productCode
	ELSE
		PRINT ('Date incorecte!')
	END
GO

CREATE PROC CRUD_Delete_productsDetails @productCode int
AS
	IF dbo.existaIdProductsDetails(@productCode) =0 
		PRINT ('Nu exista nicio inregistrare cu acest cod!')
	ELSE
	BEGIN
	IF dbo.validareID(@productCode) = 1
		DELETE FROM productsDetails WHERE productCode=@productCode
	ELSE
		PRINT ('Date incorecte!')
	END
GO

ALTER TABLE productsDetails
ADD CONSTRAINT c_productsDetails
CHECK (productCode >= 0 and productType IN('cosmetice','parfumuri','accesorii','ceasuri','ingrijire'));

EXEC CRUD_Insert_productsDetails 1, 'parfumuri','mark' ,null, null
EXEC CRUD_Select_productsDetails 1
EXEC CRUD_Delete_productsDetails 1
EXEC CRUD_Update_productsDetails 1, 'ceasuri','mark' ,null, null

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