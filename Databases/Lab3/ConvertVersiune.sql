--
CREATE PROC uspProceduriParam @param INT
AS
DECLARE @nr int

SELECT @nr=V.NR 
FROM Versiune V

IF @param<0 or @param>5 PRINT 'Parametru invalid!'
ELSE
	BEGIN
		WHILE @nr<@param
		BEGIN
			DECLARE @nume varchar(20)
			SET @nr=@nr+1

			UPDATE Versiune
			SET NR=@nr

			SET @nume='Direct'+CONVERT(varchar,@nr)
			EXEC @nume
			PRINT 'Am trecut din versiunea '+CONVERT(varchar,@nr-1)+' in versiunea '+CONVERT(varchar,@nr)
		END

		WHILE @param<@nr
		BEGIN
			DECLARE @num varchar(20)
			SET @num='Invers'+CONVERT(varchar,@nr)
			EXEC @num
			PRINT 'Am trecut din versiunea '+CONVERT(varchar,@nr)+' in versiunea '+CONVERT(varchar,@nr-1)

			SET @nr=@nr-1
			UPDATE Versiune
			SET NR=@nr
		END
	END
GO

SELECT *
FROM Versiune

EXEC uspProceduriParam 0