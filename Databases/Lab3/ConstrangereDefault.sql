--setare valoare implicita
CREATE PROC Direct2
AS
ALTER TABLE productsDetails
ADD CONSTRAINT co DEFAULT N'black' FOR productColor
GO 

CREATE PROC Invers2
AS
ALTER TABLE productsDetails
DROP CONSTRAINT co
GO