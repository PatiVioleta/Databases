CREATE FUNCTION validareID (@id int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	IF @id<0 
		SET @ok=0
	ELSE
		SET @ok=1
	RETURN @ok
END
GO

CREATE FUNCTION validareNrPozitiv (@nr int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	IF @nr<=0 
		SET @ok=0
	ELSE
		SET @ok=1
	RETURN @ok
END
GO

CREATE FUNCTION validareStatus (@status varchar(20))
RETURNS INT
BEGIN
	DECLARE @ok INT
	IF @status='platita' or @status='neplatita'
		SET @ok=1
	ELSE
		SET @ok=0
	RETURN @ok
END
GO

CREATE FUNCTION existaIdorderDetails (@id int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	DECLARE @nr INT

	SELECT @nr=COUNT(*)
	FROM orderDetails o
	WHERE o.orderID=@id

	IF  @nr>0 
		SET @ok=1
	ELSE
		SET @ok=0

	RETURN @ok
END
GO

CREATE FUNCTION existaIdOrders (@id int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	SET @ok=0

	SELECT @ok=COUNT(*)
	FROM orders o
	WHERE o.orderID=@id

	RETURN @ok
END
GO

CREATE FUNCTION existaIdProductsDetails (@id int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	SET @ok=0

	SELECT @ok=COUNT(*)
	FROM productsDetails o
	WHERE o.productCode=@id

	RETURN @ok
END
GO

CREATE FUNCTION validareType (@type varchar(20))
RETURNS INT
BEGIN
	DECLARE @ok INT
	IF @type in('cosmetice','parfumuri','accesorii','ceasuri','ingrijire')
		SET @ok=1
	ELSE
		SET @ok=0
	RETURN @ok
END
GO

CREATE FUNCTION existaIdBrochure (@id int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	SET @ok=0

	SELECT @ok=COUNT(*)
	FROM brochures o
	WHERE o.brochureID=@id

	RETURN @ok
END
GO

CREATE FUNCTION existaIdProducts (@code int, @bro int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	SET @ok=0

	SELECT @ok=COUNT(*)
	FROM products o
	WHERE o.brochureID=@bro and o.productCode=@code

	RETURN @ok
END
GO

CREATE FUNCTION existaIdProductsOrders (@code int, @bro int, @orderID int)
RETURNS INT
BEGIN
	DECLARE @ok INT
	SET @ok=0

	SELECT @ok=COUNT(*)
	FROM products_orders o
	WHERE o.brochureID=@bro and o.productCode=@code and o.orderID=@orderID

	RETURN @ok
END
GO