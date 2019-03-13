--adauga date in tabela brochures
CREATE PROC adauga_brochures 
AS

DECLARE @nrdate int
SELECT @nrdate = NoOfRows FROM TestTables WHERE TestID=2 AND TableID=1

DECLARE @i int
DECLARE @startDate DATE
DECLARE @endDate DATE
SET @i=1;
SET @startDate='2010-10-10'
SET @endDate='2010-10-10'

WHILE @i<=@nrdate
BEGIN
	INSERT INTO brochures(brochureID,startDate,endDate)
	VALUES(@i,@startDate,@endDate);
	SET @i=@i+1
END
GO

CREATE PROC sterge_brochures
AS
	DELETE FROM brochures
GO

EXEC adauga_brochures
EXEC sterge_brochures

SELECT * FROM brochures