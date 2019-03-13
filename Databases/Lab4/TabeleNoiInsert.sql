INSERT INTO Tables(Name)
VALUES('brochures'),
('pages'),
('products');

INSERT INTO Views(Name)
VALUES('prodPretMaxim'),
('prodPerioada'),
('brosuriNrProduse');

INSERT INTO Tests(Name)
VALUES('sterge'),
('adauga'),
('select');

INSERT INTO TestViews(TestID, ViewID)
VALUES(3,1),
(3,2),
(3,3);

INSERT INTO TestTables(TestID, TableID, NoOfRows, Position)
VALUES(1, 3, 1000, 1),
(1, 2, 10000, 2),
(1, 1, 10000, 3),
(2, 1, 10000, 1),
(2, 2, 10000, 2),
(2, 3, 10000, 3);

SELECT * FROM Tables
SELECT * FROM Tests
SELECT * FROM Views
SELECT * FROM TestViews
SELECT * FROM TestTables

dbcc checkident(Tables, reseed, 0)
dbcc checkident(Tests, reseed, 0)
dbcc checkident(Views, reseed, 0)

DELETE FROM Tables
DELETE FROM TestViews
DELETE FROM Tests
DELETE FROM Views
DELETE FROM TestTables
