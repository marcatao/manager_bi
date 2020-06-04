CREATE PROCEDURE [dbo].[DIM_LINHAS_AGRUPADAS_MERGE]

AS
	MERGE Auxiliar.dbo.DIM_LINHAS_AGRUPADAS AS Destino

USING (
select '0' as CD_LINHA_COTA, 'SEM CLASSIFICAÇÃO' as DN_LINHA_COTA, 'O' as CD_DIVISAO, CURRENT_TIMESTAMP as DT_SINC
union
select A.ID as CD_LINHA_COTA, A.NomeCota as DN_LINHA_COTA ,A.DIVISAO as CD_DIVISAO, CURRENT_TIMESTAMP as DT_SINC
from   INTRANET.dbo.COTA004 A
--where GestaoProdutos='SIM'
) AS Origem

--Condição: O produto existe nas 2 tabelas e o cliente também
ON (Destino.CD_LINHA_COTA = Origem.CD_LINHA_COTA)

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas
WHEN MATCHED THEN

    UPDATE SET Destino.DN_LINHA_COTA = Origem.DN_LINHA_COTA,
			   Destino.CD_DIVISAO = Origem.CD_DIVISAO,
			   Destino.DT_SINC = Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_LINHA_COTA,DN_LINHA_COTA,CD_DIVISAO,DT_SINC)

    VALUES (Origem.CD_LINHA_COTA,Origem.DN_LINHA_COTA,Origem.CD_DIVISAO,Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;





RETURN 0
