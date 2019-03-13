CREATE PROC testeaza
AS
DECLARE @startDate DATETIME
DECLARE @endDate DATETIME
DECLARE @ultimID INT

DELETE FROM TestRuns
dbcc checkident(TestRuns, reseed, 0)
DELETE FROM TestRunTables
DELETE FROM TestRunViews

DECLARE @testID INT
DECLARE c0 CURSOR FOR 
	SELECT TestID FROM Tests 

OPEN c0
FETCH NEXT FROM c0 INTO @testID
WHILE @@FETCH_STATUS=0
BEGIN
	--PRINT @testID
	DECLARE @testNume VARCHAR(20)
	SELECT @testNume=t.Name FROM Tests t WHERE t.TestID=@testID

	DECLARE @tableID INT
	DECLARE c1 CURSOR FOR
		SELECT TableID
		FROM Tests t INNER JOIN TestTables tt
		ON t.TestID=tt.TestID
		WHERE t.TestID=@testID
		ORDER BY tt.Position
	OPEN c1
	FETCH NEXT FROM c1 INTO @tableID
	WHILE @@FETCH_STATUS=0
	BEGIN

		DECLARE @nume VARCHAR(40)
		DECLARE @tableNume VARCHAR(20)
		SELECT @tableNume=t.Name FROM Tables t WHERE t.TableID=@tableID

		SET @nume = @testNume+'_'+@tableNume

		SET @startDate = GETDATE()
		EXEC @nume
		SET @endDate = GETDATE()

		INSERT INTO TestRuns(Description,StartAt,EndAt) 
		VALUES(@nume,@startDate,@endDate);

		SELECT TOP 1 @ultimID=t.TestRunID FROM TestRuns t ORDER BY t.TestRunID DESC

		INSERT INTO TestRunTables(TestRunID,TableID,StartAt,EndAt)
		VALUES(@ultimID,@tableID,@startDate,@endDate);

		FETCH NEXT FROM c1 INTO @tableID
	END
	CLOSE c1
	DEALLOCATE c1
	-------------------------------------------------------------------------
	DECLARE @testNumeV VARCHAR(20)
	SELECT @testNumeV=t.Name FROM Tests t WHERE t.TestID=@testID

	DECLARE @viewID INT
	DECLARE c1 CURSOR FOR
		SELECT tt.ViewID
		FROM Tests t INNER JOIN TestViews tt
		ON t.TestID=tt.TestID
		WHERE t.TestID=@testID

	OPEN c1
	FETCH NEXT FROM c1 INTO @viewID
	WHILE @@FETCH_STATUS=0
	BEGIN

		DECLARE @numeV VARCHAR(40)
		DECLARE @tableNumeV VARCHAR(20)
		SELECT @tableNumeV=v.Name FROM Views v WHERE v.ViewID=@viewID

		SET @numeV = @testNume+'_'+@tableNumeV
		SET @startDate = GETDATE()
		EXEC @numeV
		SET @endDate = GETDATE()

		INSERT INTO TestRuns(Description,StartAt,EndAt) 
		VALUES(@numeV,@startDate,@endDate);

		SELECT TOP 1 @ultimID=t.TestRunID FROM TestRuns t ORDER BY t.TestRunID DESC

		INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt)
		VALUES(@ultimID,@viewID,@startDate,@endDate);

		FETCH NEXT FROM c1 INTO @viewID
	END
	CLOSE c1
	DEALLOCATE c1

	PRINT(' ')
	FETCH NEXT FROM c0 INTO @testID
END
CLOSE c0
DEALLOCATE c0

GO

EXEC testeaza

SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
