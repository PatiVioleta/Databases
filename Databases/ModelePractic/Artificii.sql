IF OBJECT_ID('AdultiArtificii','U') IS NOT NULL
	DROP TABLE AdultiArtificii
IF OBJECT_ID('Adulti','U') IS NOT NULL
	DROP TABLE Adulti
IF OBJECT_ID('Artificii','U') IS NOT NULL
	DROP TABLE Artificii
IF OBJECT_ID('Categorii','U') IS NOT NULL
	DROP TABLE Categorii
IF OBJECT_ID('Tipuri','U') IS NOT NULL
	DROP TABLE Tipuri

CREATE TABLE Tipuri
	(CodT INT PRIMARY KEY IDENTITY(1,1),
	Denumire VARCHAR(100),
	PretMin FLOAT)
CREATE TABLE Categorii
	(CodC INT PRIMARY KEY IDENTITY(1,1),
	 Denumire VARCHAR(100),
	 PretMin FLOAT,
	 PretMax FLOAT)
CREATE TABLE Artificii
	(CodAr INT PRIMARY KEY IDENTITY(1,1),
	 CodC INT REFERENCES Categorii(CodC),
	 CodT INT REFERENCES Tipuri(CodT),
	 Denumire VARCHAR(100) UNIQUE,
	 DurataLansare TIME
	 )
CREATE TABLE Adulti
	(CodAd INT PRIMARY KEY IDENTITY(1,1),
	 Nume VARCHAR(100) UNIQUE,
	 Gen VARCHAR(100),
	 DataNastere DATETIME)
CREATE TABLE AdultiArtificii
	(CodAd INT REFERENCES Adulti(CodAd),
	 CodAr INT REFERENCES Artificii(CodAr),
	 DataLansare DATE,
	 OraLansare TIME,
	 PRIMARY KEY(CodAd, CodAr))
GO

INSERT Categorii VALUES('c1',10,20),('c2',20,30)
INSERT Tipuri VALUES('t1',10),('t2',20),('t3',30)
INSERT Artificii VALUES(1,1,'a1','05:00'),(1,2,'a2','05:00'),(2,3,'a3','05:00'),(2,3,'a4','05:00')
INSERT Adulti VALUES('adult1','f','2000-01-01'),('adult2','m','2000-01-01'),('adult3','m','2000-01-01')
INSERT AdultiArtificii(CodAd, CodAr, DataLansare, OraLansare) VALUES
	(1,1,'2018-01-01','7:10'), (1,2,'2018-01-01','8:10'), (1,3,'2018-01-01','9:10'),(1,4,'2018-01-01','9:10'),
	(2,1,'2018-01-01','7:15'), (2,2,'2018-01-01','8:20'), (2,3,'2018-01-01','10:20'),
	(3,1,'2018-01-01','8:20')

SELECT * FROM Categorii
SELECT * FROM Tipuri
SELECT * FROM Artificii
SELECT * FROM Adulti
SELECT * FROM AdultiArtificii

GO
CREATE OR ALTER PROC uspAdauga @NumeAd varchar(100), @DenumireAr varchar(100), @DataLansare DATE, @OraLansare TIME
AS
	DECLARE @CodAd INT = (SELECT CodAd FROM Adulti WHERE Nume=@NumeAd),
		@CodAr INT = (SELECT CodAr FROM Artificii WHERE Denumire=@DenumireAr)

	IF @CodAd IS NULL OR @CodAr IS NULL
		RAISERROR('adult/ artificiu nu exista', 16, 1)
	ELSE
		IF NOT EXISTS (SELECT * FROM AdultiArtificii WHERE CodAr = @CodAr AND CodAd=@CodAd)
			INSERT AdultiArtificii(CodAd, CodAr,DataLansare,OraLansare)
			VALUES(@CodAd,@CodAr,@DataLansare,@OraLansare)
		ELSE
			UPDATE AdultiArtificii
			SET DataLansare=@DataLansare, OraLansare=@OraLansare
			WHERE CodAr = @CodAr AND CodAd=@CodAd
GO

uspAdauga 'adult3','a2','2019-01-01','18:10'
GO
uspAdauga 'adult1','a1','2019-01-01','18:10'
GO
GO
--uspAdauga 'adu','a1','2019-01-01','18:10'
SELECT * FROM AdultiArtificii
GO 

CREATE OR ALTER VIEW vArtificiiTip
AS
SELECT Tip = T.Denumire, PretMinim = T.PretMin, Artificiu = A.Denumire, DurataLansare = A.DurataLansare, Categorie = C.Denumire
FROM Artificii A INNER JOIN Tipuri T
				ON A.CodT=T.CodT
				INNER JOIN Categorii C
				ON C.CodC=A.CodC


GO
SELECT * FROM vArtificiiTip
ORDER BY Tip
GO

CREATE OR ALTER FUNCTION ufAdulti(@N INT)
RETURNS TABLE

RETURN SELECT A.Nume
FROM Adulti A
WHERE A.CodAd IN
(
	SELECT A1.CodAd
	FROM Adulti A1 INNER JOIN AdultiArtificii AA
		ON A1.CodAd = AA.CodAd
	GROUP BY A1.CodAd
	HAVING COUNT(*)>=@N
)
GO

SELECT *
FROM ufAdulti(4)