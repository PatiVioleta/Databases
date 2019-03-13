
--Selecteaza toate produsele care au fost cumparate pana in prezent  (cod, nume, pret, descriere)
SELECT DISTINCT p.productCode, p.productName, p.productPrice, pd.productDesc
FROM products p INNER JOIN products_orders l
	ON p.productCode=l.productCode and p.brochureID=l.brochureID
	INNER JOIN productsDetails pd
	ON p.productCode=pd.productCode

--Selecteaza brosurile din care s-au cumparat mai mult de 5 rujuri si nr respectiv
SELECT p.brochureID, NR_produse=COUNT(*)
FROM products p INNER JOIN products_orders l
	ON p.productCode=l.productCode and p.brochureID=l.brochureID
	INNER JOIN productsDetails pd
	ON p.productCode=pd.productCode
	WHERE pd.productDesc LIKE '%ruj%'
	GROUP BY p.brochureID
	HAVING COUNT(*)>5

--Care sunt brosurile din care s-au comandat cel putin doua produse mai scumpe de 85 lei fiecare
SELECT p.brochureID
FROM products P INNER JOIN products_orders PO
	ON P.productCode=PO.productCode and P.brochureID=PO.brochureID
WHERE p.productPrice > 85
GROUP BY p.brochureID
HAVING COUNT(*)>1

--Calculeaza suma tuturor comenzilor efectuate(platite sau nu) din orice campanie pentru fiecare client
SELECT o.customerID, Suma_Totala=SUM(p.productPrice)
FROM orders O INNER JOIN products_orders PO
	ON o.orderID=po.orderID
		INNER JOIN products p
		ON p.productCode=po.productCode
				GROUP BY o.customerID

--Selecteaza toti clientii care au minim 20 de ani
SELECT *
FROM customers C INNER JOIN customerDetails CD
	ON c.customerID=cd.customerID
	WHERE cd.ages>=20

--Ordoneaza clientii in functie de sumele pe care le-au platit
SELECT o.customerID, sumaTotala=SUM(p.productPrice)
FROM orders O INNER JOIN products_orders PO
	ON o.orderID=po.orderID
		INNER JOIN products p
		ON p.productCode=po.productCode
		WHERE O.statusOrder='platita'
				GROUP BY o.customerID
				ORDER BY sumaTotala DESC

--Ordoneaza clientii in functie de comanda separata cea mai mare pusa de fiecare
SELECT o.customerID, comandaMaxima=MAX(p.productPrice)
FROM orders O INNER JOIN products_orders PO
	ON o.orderID=po.orderID
		INNER JOIN products p
		ON p.productCode=po.productCode
		WHERE O.statusOrder='platita'
				GROUP BY o.customerID
				ORDER BY comandaMaxima DESC

--Selecteaza clientul cu cele mai mari comenzi platite din campania 2 care are peste 20 ani
SELECT TOP 1 CastigatorId=o.customerID ,sumaTotala=SUM(p.productPrice)
	FROM orders O INNER JOIN products_orders PO
	ON o.orderID=po.orderID
		INNER JOIN products p
		ON p.productCode=po.productCode
		INNER JOIN customerDetails CD
		ON o.customerID=cd.customerID
		WHERE O.statusOrder='platita' and p.brochureID=2 and cd.ages>=20
				GROUP BY o.customerID
				HAVING COUNT(*)>1
				ORDER BY sumaTotala DESC

--Selecteaza produsele care au pretul maxim
SELECT *
FROM products p
Where p.productPrice=(
	SELECT MAX(p.productPrice)
	FROM products p) 

--Selecteaza toate numele produselor comandate de fiecare client, varsta si id-ul clientului
SELECT DISTINCT o.customerID, p.productName, CD.ages
FROM orders O INNER JOIN products_orders PO
ON o.orderID=po.orderID
	INNER JOIN products p
	ON p.productCode=po.productCode
	INNER JOIN customerDetails CD
	ON o.customerID=cd.customerID

SELECT *
FROM products p
WHERE p.brochureID=1 and p.pageNumber=1

select *
from pages

delete from products where productCode=1234

INSERT INTO products
		VALUES (3456,1,1,'ada',123)