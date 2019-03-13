--adaugare camp nou
CREATE PROC Direct4
AS
ALTER TABLE products
ADD col_noua INT
GO

CREATE PROC Invers4
AS
ALTER TABLE products
DROP COLUMN col_noua
GO