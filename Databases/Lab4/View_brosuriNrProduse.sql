--Nr de produse din fiecare brosura
CREATE VIEW view_brosuriNrProduse AS
SELECT p.brochureID, Nr_produse=COUNT(*)
FROM products P INNER JOIN brochures B
	ON P.brochureID=B.brochureID
GROUP BY p.brochureID

--SELECT * FROM view_brosuriNrProduse