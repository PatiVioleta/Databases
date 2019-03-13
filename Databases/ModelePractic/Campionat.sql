IF OBJECT_ID('Partide','U') IS NOT NULL
	DROP TABLE Partide
IF OBJECT_ID('Turnee','U') IS NOT NULL
	DROP TABLE Turnee
IF OBJECT_ID('Arene','U') IS NOT NULL
	DROP TABLE Arene
IF OBJECT_ID('Jucatori','U') IS NOT NULL
	DROP TABLE Jucatori

CREATE TABLE Arene
	(CodA INT PRIMARY KEY IDENTITY(1,1),
	NumeA VARCHAR(100) UNIQUE)
CREATE TABLE Turnee
	(CodT INT PRIMARY KEY IDENTITY(1,1),
	 NumeT VARCHAR(100) UNIQUE,
	 Loc VARCHAR(100),
	 TStart DATE,
	 TEnd DATE)
CREATE TABLE Jucatori
	(CodJ INT PRIMARY KEY IDENTITY(1,1),
	 NumeJ VARCHAR(100),
	 Puncte INT,
	 Valoare INT)
CREATE TABLE Partide
	(CodJ1 INT REFERENCES Jucatori(CodJ),
	 CodJ2 INT REFERENCES Jucatori(CodJ),
	 CodA INT REFERENCES Arene(CodA),
	 OraP TIME,
	 DataP DATE,
	 Puncte1 INT,
	 Puncte2 INT,
	 Valoare1 INT,
	 Valoare2 INT,
	 Castigator INT REFERENCES Jucatori(CodJ),
	 CodT INT REFERENCES Turnee(CodT),
	 PRIMARY KEY(CodJ1, CodJ2, CodT))
GO

INSERT Arene VALUES('a1'),('a2')
INSERT Turnee VALUES('t1','sibiu','2018-01-01','2018-02-01'),('t2','bucuresti','2018-03-01','2018-05-01'),('t3','constanta','2018-04-01','2018-07-01')
INSERT Jucatori VALUES('j1',256,6),('j2',450,9),('j3',210,4)
INSERT Partide VALUES(1,2,1,'18:00','2018-01-01',26,100,1,2,2,1),
					(1,3,2,'18:00','2018-02-01',70,10,2,1,1,1),
					(3,2,1,'10:00','2018-01-01',30,60,1,2,2,1),

					(1,2,1,'18:00','2018-03-01',21,50,1,3,2,2),
					(2,3,2,'18:00','2018-04-01',10,50,1,3,3,2),

					(1,2,2,'18:00','2018-03-01',21,50,1,3,2,3),
					(2,3,1,'18:00','2018-04-01',10,50,1,3,3,3)

SELECT * FROM Arene
SELECT * FROM Turnee
SELECT * FROM Jucatori
SELECT * FROM Partide

GO
CREATE OR ALTER PROC uspPartida @NumeT varchar(100), @NumeJ1 varchar(100), @NumeJ2 varchar(100), @Puncte1 INT, @Puncte2 INT,
                                @Valoare1 INT, @Valoare2 INT,@NumeCastigator varchar(100), @NumeA varchar(100), @Data Date, @Ora TIME
AS
	DECLARE @CodT INT = (SELECT CodT FROM Turnee  WHERE NumeT=@NumeT),
		@CodJ1 INT = (SELECT CodJ FROM Jucatori WHERE NumeJ=@NumeJ1),
		@CodJ2 INT = (SELECT CodJ FROM Jucatori WHERE NumeJ=@NumeJ2),
		@Castigator INT = (SELECT CodJ FROM Jucatori WHERE NumeJ=@NumeCastigator),
		@CodA INT = (SELECT CodA FROM Arene WHERE NumeA=@NumeA)

	IF @CodT IS NULL OR @CodJ1 IS NULL OR @CodJ2 IS NULL OR @Castigator IS NULL OR @CodA IS NULL  
		RAISERROR('jucator/ turneu/ castigator/ arena nu exista', 16, 1)
	ELSE
		IF NOT EXISTS (SELECT * FROM Partide WHERE CodJ1 = @CodJ1 AND CodJ2=@CodJ2 AND CodT=@CodT)
			INSERT Partide
			VALUES(@CodJ1,@CodJ2,@CodA,@Ora,@Data,@Puncte1,@Puncte2,@Valoare1,@Valoare2,@Castigator,@CodT)	
GO 

uspPartida 't3', 'j3','j1',20,10,2,1,'j3','a2','2018-05-01','12:00'
GO
SELECT * FROM Partide
GO

--DECLARE @tabela Table (Cod INT, Castiguri INT)
--INSERT INTO @tabela 
--SELECT J.CodJ, nr=COUNT(*)
--FROM Jucatori J INNER JOIN Partide P ON J.CodJ=P.Castigator
--GROUP BY J.CodJ
--ORDER BY nr DESC
--GO


--Numele jucatorilor impreuna cu nr de partide castigate de fiecare
CREATE OR ALTER VIEW vJucatoriOrdonati
AS
SELECT Nume=(SELECT NumeJ FROM Jucatori WHERE J.CodJ=CodJ), Castiguri=COUNT(*)
FROM Jucatori J INNER JOIN Partide P ON J.CodJ=P.Castigator
GROUP BY J.CodJ

GO

SELECT * FROM vJucatoriOrdonati
ORDER BY Castiguri DESC
GO

--Pentru un anumit jucator, punctajul total si valoarea totala
CREATE OR ALTER FUNCTION ufJucatorTotal(@NumeJ varchar(100))
RETURNS TABLE

RETURN SELECT Nume=(SELECT NumeJ FROM Jucatori WHERE @NumeJ=NumeJ),  Puncte = x1.pcte1+x2.pcte2+(SELECT Puncte FROM Jucatori WHERE @NumeJ=NumeJ),
					Valoare = x1.val1+x2.val2+(SELECT Valoare FROM Jucatori WHERE @NumeJ=NumeJ)
FROM 
	(SELECT pcte1=SUM(P.Puncte1), val1=SUM(P.Valoare1)
	FROM Jucatori J INNER JOIN Partide P ON P.CodJ1=J.CodJ
	WHERE J.NumeJ=@NumeJ) x1,
	
	(SELECT pcte2=SUM(P2.Puncte2), val2=SUM(P2.Valoare2)
	FROM Jucatori J INNER JOIN Partide P2 ON P2.CodJ2=J.CodJ
	WHERE J.NumeJ=@NumeJ) x2

GO

SELECT *
FROM ufJucatorTotal('j2')
