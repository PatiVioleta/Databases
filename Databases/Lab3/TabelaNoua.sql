--adaugare tabela noua
CREATE PROC Direct3
AS
CREATE TABLE tabela(tabelaID int PRIMARY KEY NOT NULL, camp1 varchar(20))
GO

CREATE PROC Invers3
AS
DROP TABLE tabela
GO
