CREATE PROC select_prodPretMaxim
AS
	SELECT * FROM view_prodPretMaxim
GO

CREATE PROC select_prodPerioada
AS
	SELECT * FROM view_prodPerioada
GO

CREATE PROC select_brosuriNrProduse
AS
	SELECT * FROM view_brosuriNrProduse
GO

EXEC adauga_brochures EXEC adauga_pages EXEC adauga_products
EXEC select_prodPretMaxim
EXEC select_prodPerioada
EXEC select_brosuriNrProduse
EXEC sterge_products EXEC sterge_pages EXEC sterge_brochures

SELECT * FROM brochures
SELECT * FROM pages
SELECT * FROM products