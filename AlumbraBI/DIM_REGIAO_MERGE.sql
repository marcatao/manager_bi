CREATE PROCEDURE [dbo].[DIM_REGIAO_MERGE]
 as 
BEGIN TRANSACTION

MERGE [Auxiliar].dbo.DIM_REGIAO AS Destino

USING (select CD_REGIAO,DE_REGIAO as SUPERVISOR,DN_FANTASIA as DN_REGIAO,0 as CD_FUNC_RESP from fiscal.dbo.ge080)

AS Origem

--Condição: O produto existe nas 2 tabelas e o cliente também

ON (Destino.CD_REGIAO = Origem.CD_REGIAO)

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas

WHEN MATCHED THEN

    UPDATE SET Destino.SUPERVISOR = Origem.SUPERVISOR,
			   Destino.DN_REGIAO = Origem.DN_REGIAO,
			   Destino.CD_FUNC_RESP = Origem.CD_FUNC_RESP

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_REGIAO,SUPERVISOR,DN_REGIAO,CD_FUNC_RESP)

    VALUES (Origem.CD_REGIAO,Origem.SUPERVISOR,Origem.DN_REGIAO,Origem.CD_FUNC_RESP)

OUTPUT $action, Inserted.*, Deleted.*;

RETURN 0
