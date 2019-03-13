--adaugare cheie straina
CREATE PROC Direct5
AS
ALTER TABLE brochures
WITH NOCHECK ADD CONSTRAINT con FOREIGN KEY(brochureID) REFERENCES customerdetails(customerID)
GO

CREATE PROC Invers5
AS
ALTER TABLE brochures
DROP CONSTRAINT con
GO

EXEC Invers5