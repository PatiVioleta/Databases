--produsele cumparate din brosuri care au inceput pe 10.10.2010
CREATE VIEW view_prodPerioada AS
SELECT P.productCode, P.brochureID, P.productName
FROM products P INNER JOIN brochures B
	ON P.brochureID=B.brochureID
WHERE B.startDate='2010-10-10'

--SELECT * FROM view_prodPerioada