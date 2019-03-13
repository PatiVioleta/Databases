--modificare tip coloana
CREATE PROC Direct1
AS
ALTER TABLE productsDetails
ALTER COLUMN productFirm nvarchar(30)
GO

CREATE PROC Invers1
AS
ALTER TABLE productsDetails
ALTER COLUMN productFirm varchar(20)
GO