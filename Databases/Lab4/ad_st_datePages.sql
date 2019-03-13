--adauga date in tabela pages
CREATE PROC adauga_pages
AS

DECLARE @nrdate int
SELECT @nrdate = NoOfRows FROM TestTables WHERE TestID=2 AND TableID=2

DECLARE @i int
SET @i=1;

WHILE @i<=@nrdate
BEGIN
	INSERT INTO pages(pageNumber,brochureID)
	VALUES(@i,@i);
	SET @i=@i+1
END
GO

CREATE PROC sterge_pages
AS
	DELETE FROM pages
GO

EXEC adauga_brochures EXEC adauga_pages
EXEC sterge_pages EXEC sterge_brochures

SELECT * FROM pages
SELECT * FROM brochures