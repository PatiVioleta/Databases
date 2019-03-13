IF OBJECT_ID('RuteStatii','U') IS NOT NULL
	DROP TABLE RuteStatii
IF OBJECT_ID('Statii','U') IS NOT NULL
	DROP TABLE Statii
IF OBJECT_ID('Rute','U') IS NOT NULL
	DROP TABLE Rute
IF OBJECT_ID('Trenuri','U') IS NOT NULL
	DROP TABLE Trenuri
IF OBJECT_ID('TipuriTren','U') IS NOT NULL
	DROP TABLE TipuriTren

CREATE TABLE TipuriTren
	(CodTT TINYINT PRIMARY KEY IDENTITY(1,1),
	Descriere VARCHAR(100))
CREATE TABLE Trenuri
	(CodT SMALLINT PRIMARY KEY IDENTITY(1,1),
	 NumeT VARCHAR(50),
	 CodTT TINYINT REFERENCES TipuriTren(CodTT))
CREATE TABLE Rute
	(CodR SMALLINT PRIMARY KEY IDENTITY(1,1),
	 NumeR VARCHAR(50) UNIQUE,
	 CodT SMALLINT REFERENCES Trenuri(CodT))
CREATE TABLE Statii
	(CodS SMALLINT PRIMARY KEY IDENTITY(1,1),
	 NumeS VARCHAR(100) UNIQUE)
CREATE TABLE RuteStatii
	(CodR SMALLINT REFERENCES Rute(CodR),
	 CodS SMALLINT REFERENCES Statii(CodS),
	 Sosire TIME,
	 Plecare TIME,
	 PRIMARY KEY(CodR, CodS))
GO

INSERT TipuriTren VALUES('mocanita'),('regio')
INSERT Trenuri VALUES('t1',1),('t2',2),('t3',1)
INSERT Statii VALUES('s1'),('s2'),('s3')
INSERT Rute VALUES('r1',1),('r2',2),('r3',3)
INSERT RuteStatii(CodR, CodS, Sosire, Plecare) VALUES
	(1,1,'7:00','7:10'), (1,2,'8:00','8:10'), (1,3,'9:00','9:10'),
	(2,1,'7:00','7:15'), (2,2,'7:50','8:20'), (2,3,'10:00','10:20'),
	(3,1,'7:50','8:20')

SELECT * FROM TipuriTren
SELECT * FROM Trenuri
SELECT * FROM Rute
SELECT * FROM Statii
SELECT * FROM RuteStatii


GO
CREATE OR ALTER PROC uspStatiePeRuta @NumeR varchar(50), @NumeS varchar(100), @Sosire TIME, @Plecare TIME
AS
	DECLARE @CodR SMALLINT = (SELECT CodR FROM Rute WHERE NumeR=@NumeR),
		@CodS SMALLINT = (SELECT CodS FROM Statii WHERE NumeS=@NumeS)

	IF @CodR IS NULL OR @CodS IS NULL
		RAISERROR('statie/ ruta nu exista', 16, 1)
	ELSE
		IF NOT EXISTS (SELECT * FROM RuteStatii WHERE CodR = @CodR AND CodS=@CodS)
			INSERT RuteStatii(CodR, CodS, Sosire,Plecare)
			VALUES(@CodR,@CodS,@Sosire,@Plecare)
		ELSE
			UPDATE RuteStatii
			SET Sosire=@Sosire, Plecare=@Plecare
			WHERE CodR = @CodR AND CodS=@CodS
GO 

--uspStatiePeRuta 'r3','s1','17:00','17:10'
uspStatiePeRuta 'r3','s2','18:00','18:10'
GO
SELECT * FROM RuteStatii
GO

--Numele rutelor care trec prin toate statiile
CREATE OR ALTER VIEW vRuteCuToateStatiile
AS
SELECT R.NumeR
FROM Rute R
WHERE NOT EXISTS(
	SELECT CodS
	FROM Statii 
	EXCEPT
	SELECT CodS
	FROM RuteStatii
	WHERE CodR=R.CodR
)
GO
SELECT * FROM vRuteCuToateStatiile
SELECT * FROM RuteStatii
GO

--Numele statiilor in care se afla cel putin 2 trenuri in acelasi moment
CREATE OR ALTER FUNCTION ufCrowdedStations()
RETURNS TABLE

RETURN SELECT S.NumeS
FROM Statii S
WHERE S.CodS IN
(
	SELECT rs1.CodS
	FROM RuteStatii rs1 INNER JOIN RuteStatii rs2
		ON rs1.CodS = rs2.CodS and rs1.CodR = rs2.CodR
	WHERE rs2.Sosire <= rs1.Plecare AND rs1.Plecare >= rs1.Sosire
)
GO

SELECT *
FROM ufCrowdedStations()