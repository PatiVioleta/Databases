--Selecteaza produsele care au pretul maxim
CREATE VIEW view_prodPretMaxim AS
SELECT *
FROM products p
WHERE p.productPrice=(
	SELECT MAX(p.productPrice)
	FROM products p) 

--SELECT * FROM view_prodPretMaxim