IF OBJECT_ID('MediciPacienti','U') IS NOT NULL
	DROP TABLE MediciPacienti
IF OBJECT_ID('Medici','U') IS NOT NULL
	DROP TABLE Medici
IF OBJECT_ID('Pacienti','U') IS NOT NULL
	DROP TABLE Pacienti
IF OBJECT_ID('Diagnostice','U') IS NOT NULL
	DROP TABLE Diagnostice
IF OBJECT_ID('Specializari','U') IS NOT NULL
	DROP TABLE Specializari

CREATE TABLE Specializari
	(CodS INT PRIMARY KEY IDENTITY(1,1),
	Denumire VARCHAR(100))
CREATE TABLE Diagnostice
	(CodD INT PRIMARY KEY IDENTITY(1,1),
	 Denumire VARCHAR(100) UNIQUE,
	 Descriere VARCHAR(100))
CREATE TABLE Pacienti
	(CodP INT PRIMARY KEY IDENTITY(1,1),
	 NumeP VARCHAR(100),
	 PrenumeP VARCHAR(100),
	 Adresa VARCHAR(100))
CREATE TABLE Medici
	(CodM INT PRIMARY KEY IDENTITY(1,1),
	 NumeM VARCHAR(100),
	 PrenumeM VARCHAR(100),
	 CodS INT REFERENCES Specializari(CodS))
CREATE TABLE MediciPacienti
	(CodM INT REFERENCES Medici(CodM),
	 CodP INT REFERENCES Pacienti(CodP),
	 CodD INT REFERENCES Diagnostice(CodD),
	 DataC DATE,
	 Ora TIME,
	 Observatii VARCHAR(100),
	 PRIMARY KEY(CodM, CodP,DataC))
GO

INSERT Specializari VALUES('s1'),('s2')
INSERT Diagnostice VALUES('d1','den1'),('d2','den2'),('d3','den3')

INSERT Pacienti VALUES('p1','pp1','adr1'),
						('p2','pp2','adr2'),
						('p3','pp3','adr3')

INSERT Medici VALUES ('m1','mm1',1),
					('m2','mm2',2),
					('m3','mm3',1)

INSERT MediciPacienti VALUES(1,1,2,'2018-01-01','16:00','obs'),(1,2,1,'2018-03-01','18:00','obs'),(1,3,1,'2018-01-01','16:00','obs'),
						(2,3,1,'2018-01-01','18:00','obs'),(2,1,2,'2018-01-01','13:00','obs'),
						(3,1,3,'2018-01-01','18:00','obs')

SELECT * FROM Medici
SELECT * FROM Specializari
SELECT * FROM Pacienti
SELECT * FROM Diagnostice
SELECT * FROM MediciPacienti

GO
CREATE OR ALTER PROC uspAdauga @NumeP varchar(100), @NumeM varchar(100), @Diagnostic varchar(100), @Obs varchar(100), @Data DATE, @Ora TIME
AS
	DECLARE @CodP INT = (SELECT CodP FROM Pacienti WHERE NumeP=@NumeP),
		@CodM INT = (SELECT CodM FROM Medici WHERE NumeM=@NumeM),
		@CodD INT = (SELECT CodD FROM Diagnostice WHERE Denumire=@Diagnostic)

	IF @CodP IS NULL OR @CodM IS NULL OR @CodD IS NULL
		RAISERROR('pacient/ medic/ diagnostic nu exista', 16, 1)
	ELSE
		IF NOT EXISTS (SELECT * FROM MediciPacienti WHERE CodP = @CodP AND CodM=@CodM AND DataC=@Data)
			INSERT MediciPacienti
			VALUES(@CodM,@CodP,@CodD,@Data,@Ora,@Obs)
		ELSE
			UPDATE MediciPacienti
			SET CodD=@CodD, Ora=@Ora, Observatii=@Obs
			WHERE CodP = @CodP AND CodM=@CodM AND DataC=@Data
GO 

uspAdauga 'p2', 'm3', 'd1','obser','2018-02-01','20:00'
GO
SELECT * FROM MediciPacienti
GO

CREATE OR ALTER VIEW vMedici
AS
SELECT Nume = (SELECT NumeM FROM Medici WHERE CodM=M.CodM), Prenume = (SELECT PrenumeM FROM Medici WHERE CodM=M.CodM)
FROM Medici M INNER JOIN MediciPacienti MP ON M.CodM=MP.CodM
WHERE MONTH(MP.DataC) = MONTH(GETDATE())
GROUP BY M.CodM
HAVING COUNT(*)>1
GO
SELECT * FROM vMedici
ORDER BY Nume, Prenume
GO

CREATE OR ALTER FUNCTION ufConsZi(@Ora TIME)
RETURNS TABLE

RETURN SELECT M1.NumeM, M1.PrenumeM
FROM Medici M1
WHERE EXISTS (SELECT M.CodM
		FROM Medici M INNER JOIN MediciPacienti MP1 ON M.CodM=MP1.CodM
		              INNER JOIN MediciPacienti MP2 ON M.CodM=MP2.CodM
	    WHERE MP1.DataC=MP2.DataC AND MP1.CodP<>MP2.CodP AND M.CodM=M1.CodM AND MP1.Ora=@Ora AND MP2.Ora=@Ora
		)

GO

SELECT *
FROM ufConsZi('16:00')

-----MEDICII care nu sunt ocupati intr-o anumita zi la o anumita ora
GO
CREATE OR ALTER FUNCTION ufTest(@Date DATE,@Ora TIME)
RETURNS TABLE

RETURN SELECT M1.NumeM, M1.PrenumeM
FROM Medici M1
WHERE NOT EXISTS (SELECT M.CodM
		FROM Medici M INNER JOIN MediciPacienti MP ON M.CodM=MP.CodM
	    WHERE M.CodM=M1.CodM AND MP.DataC=@Date AND (@Ora between MP.Ora AND cast( DATEADD(HOUR, 2, cast(MP.Ora as datetime)) as TIME ))
		)

GO
SELECT *
FROM ufTest('2018-03-01','20:01')

--DECLARE @d TIME
--set @d = '18:00'
--DECLARE @d2 TIME
--set @d2=cast( DATEADD(HOUR, 2, cast(@d as datetime)) as TIME )
--Select @d
--Select @d2