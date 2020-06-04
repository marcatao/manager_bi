CREATE PROCEDURE [dbo].[DIM_REPRESENTANTE_MERGE]
 
AS
 

MERGE [Auxiliar].[dbo].DIM_REPRESENTANTE AS Destino

USING (

select distinct(cd_repres) as CD_REPRES, 
       CD_CGCCPF,
	   DN_FANTASIA,
	   TP_SITUACAO,
	   NR_CONTRATO,
	   CD_REGIAO,
	   CD_GERENTE,
	   CURRENT_TIMESTAMP as DT_SINC
from [FISCAL].[dbo].ge060
where CD_FILIAL not in (3,4,5,6)
 
 


) AS Origem

--Condição: O produto existe nas 2 tabelas e o cliente também

ON (Destino.CD_REPRES = Origem.CD_REPRES)

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas

WHEN MATCHED THEN

    UPDATE SET Destino.CD_CGCCPF = Origem.CD_CGCCPF,
		    	Destino.DN_FANTASIA = Origem.DN_FANTASIA,
				Destino.TP_SITUACAO	= Origem.TP_SITUACAO,
				Destino.NR_CONTRATO	= Origem.NR_CONTRATO,
				Destino.CD_REGIAO = Origem.CD_REGIAO,
				Destino.CD_GERENTE = Origem.CD_GERENTE,
				Destino.DT_SINC = Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_REPRES, 
			CD_CGCCPF,
			DN_FANTASIA,
			TP_SITUACAO,
			NR_CONTRATO,
			CD_REGIAO,
			CD_GERENTE,
			DT_SINC )

    VALUES (Origem.CD_REPRES, 
			Origem.CD_CGCCPF,
			Origem.DN_FANTASIA,
			Origem.TP_SITUACAO,
			Origem.NR_CONTRATO,
			Origem.CD_REGIAO,
			Origem.CD_GERENTE,
			Origem.DT_SINC )

OUTPUT $action, Inserted.*, Deleted.*;
 

RETURN 0
