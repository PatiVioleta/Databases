IF OBJECT_ID('Comentarii','U') IS NOT NULL
	DROP TABLE Comentarii
IF OBJECT_ID('Note','U') IS NOT NULL
	DROP TABLE Note
IF OBJECT_ID('Taskuri','U') IS NOT NULL
	DROP TABLE Taskuri
IF OBJECT_ID('Studenti','U') IS NOT NULL
	DROP TABLE Studenti
IF OBJECT_ID('Grupe','U') IS NOT NULL
	DROP TABLE Grupe

CREATE TABLE Grupe
	(CodG INT PRIMARY KEY IDENTITY(1,1),
	NumeG VARCHAR(100) UNIQUE)
CREATE TABLE Studenti
	(CodS INT PRIMARY KEY IDENTITY(1,1),
	 NumeS VARCHAR(50),
	 CodG INT REFERENCES Grupe(CodG))
CREATE TABLE Taskuri
	(CodT INT PRIMARY KEY IDENTITY(1,1),
	 NumeT VARCHAR(50) UNIQUE)
CREATE TABLE Note
	(CodS INT REFERENCES Studenti(CodS),
	 CodT INT REFERENCES Taskuri(CodT),
	 Nota FLOAT,
	 PRIMARY KEY(CodS, CodT))
CREATE TABLE Comentarii
	(CodC INT PRIMARY KEY IDENTITY(1,1),
	 Stare VARCHAR(100),
	 CodS INT,
	 CodT INT,
	 FOREIGN KEY (CodS,CodT) REFERENCES NOTE(CodS,CodT),
	 CHECK (Stare IN ('rezolvat','deschis')))
GO

INSERT Grupe VALUES('gr1'),('gr2')
INSERT Studenti VALUES('s1',1),('s2',2),('s3',1)
INSERT Taskuri VALUES('t1'),('t2'),('t3')
INSERT Note(CodS, CodT, Nota) VALUES
	(1,1,9), (1,2,8), (1,3,10),
	(2,1,9.5), (2,2,7), (2,3,8.4),
	(3,1,10)
INSERT Comentarii VALUES('rezolvat',1,1),('deschis',1,2),('rezolvat',1,1),
('rezolvat',1,3),('rezolvat',2,1),('rezolvat',2,2),
('rezolvat',3,1),('deschis',3,1),('rezolvat',3,1)

SELECT * FROM Grupe
SELECT * FROM Studenti
SELECT * FROM Taskuri
SELECT * FROM Note
SELECT * FROM Comentarii

GO
CREATE OR ALTER PROC uspStudentNotaComentariu @NumeS varchar(50), @NumeT varchar(100), @Nota FLOAT, @Comentariu varchar(100)
AS
	DECLARE @CodS INT = (SELECT CodS FROM Studenti WHERE NumeS=@NumeS),
		@CodT INT = (SELECT CodT FROM Taskuri WHERE NumeT=@NumeT)

	IF @CodS IS NULL OR @CodT IS NULL
		RAISERROR('student/ ruta nu exista', 16, 1)
	ELSE
		IF NOT EXISTS (SELECT * FROM Note WHERE CodT = @CodT AND CodS=@CodS)
		BEGIN
			INSERT Note
			VALUES(@CodS,@CodT,@Nota)
			INSERT Comentarii
			VALUES(@Comentariu,@CodS,@CodT)
			END
		ELSE
		BEGIN
			UPDATE Note
			SET Nota=@Nota
			WHERE CodT = @CodT AND CodS=@CodS
			INSERT Comentarii
			VALUES(@Comentariu,@CodS,@CodT)
			END
GO 

uspStudentNotaComentariu 's1', 't1', 9.6, 'rezolvat'
GO
uspStudentNotaComentariu 's3', 't2', 8.1, 'deschis'
GO
SELECT * FROM Note
GO

--Studentii care au cel putin o nota care are asociat un mesaj deschis
CREATE OR ALTER VIEW vStudentiCuStareaDeschis
AS
	SELECT DISTINCT S.NumeS
	FROM Studenti S INNER JOIN Note N  ON S.CodS=N.CodS
		INNER JOIN Comentarii C ON N.CodS=C.CodS AND N.CodT=N.CodT
	WHERE C.Stare='deschis'
GO
SELECT * FROM vStudentiCuStareaDeschis
SELECT * FROM Note
GO

--Pt studentii dintr-o anumita grupa afiseaza mediile finale
CREATE OR ALTER FUNCTION ufNoteFinale(@Grupa varchar(100))
RETURNS TABLE

RETURN SELECT Nume = (SELECT S2.NumeS FROM Studenti S2 WHERE S2.CodS=S.CodS), Final = SUM(N.Nota)/(SELECT COUNT(*) FROM Taskuri)
FROM Studenti S INNER JOIN Note N ON S.CodS=N.CodS
	INNER JOIN Grupe G ON S.CodG=G.CodG
WHERE G.NumeG=@Grupa
GROUP BY S.CodS

GO

SELECT *
FROM ufNoteFinale('gr1')