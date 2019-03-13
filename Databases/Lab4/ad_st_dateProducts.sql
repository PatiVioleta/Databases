--adauga date in tabela products
CREATE PROC adauga_products
AS

DECLARE @nrdate int
SELECT @nrdate = NoOfRows FROM TestTables WHERE TestID=2 AND TableID=3

DECLARE @i int
SET @i=1;

DELETE FROM productsDetails

WHILE @i<=@nrdate
BEGIN
	INSERT INTO productsDetails(productCode,productType,productFirm,productColor,productDesc)
	VALUES(@i,'cosmetice'+CONVERT (VARCHAR (30), @i),'mark'+CONVERT (VARCHAR (30), @i),'red'+CONVERT (VARCHAR (30), @i),'ruj mark'+CONVERT (VARCHAR (30), @i));

	INSERT INTO products(productCode,brochureID,pageNumber,productName,productPrice)
	VALUES (@i,@i,@i,'ruj mark'+CONVERT (VARCHAR (30), @i),20);

	SET @i=@i+1
END
GO

CREATE PROC sterge_products
AS
	DELETE FROM products
GO

EXEC adauga_brochures EXEC adauga_pages EXEC adauga_products
EXEC sterge_products EXEC sterge_pages EXEC sterge_brochures

SELECT * FROM products
SELECT * FROM productsDetails
SELECT * FROM pages
SELECT * FROM brochures