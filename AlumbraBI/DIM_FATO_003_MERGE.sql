CREATE PROCEDURE [dbo].[DIM_FATO_003_MERGE]
 as 
MERGE dbo.FATO_003 AS Destino

USING 
(

--********************************************************************************--
--********************************************************************************--
--********************************************************************************--
--********************************************************************************--

 
select Cod_Dia, 
      '1'as CD_FILIAL,
	  CD_REPRES,
	  CD_REGIAO,
	  COTA_LINHA as VL_COTA,
	  ID_LINHA as CD_LINHA_COTA,
	  DIVISAO as CD_DIVISAO,
	  CURRENT_TIMESTAMP as DT_SINC 
FROM(
SELECT F.Cod_Dia, 
       B.CD_REPRES,
	   C.CD_REGIAO,
       (SUM(B.VALOR_COTA)*(SUM(E.VALOR)))/100 as COTA, 

A.DIVISAO,  B.ID_COTA,
D.ID_LINHA,
SUM(D.PERCENTUAL) as PERCENTUAL_LINHA,
case SUM(D.PERCENTUAL) when 0 then '0' ELSE
(((SUM(B.VALOR_COTA)*(SUM(E.VALOR)))/100)*(SUM(D.PERCENTUAL)))/100
END as COTA_LINHA
  FROM [INTRANET].[dbo].[COTA006] A
  join [INTRANET].[dbo].[COTA008] B on  A.ID = B.ID_COTA
  join [FISCAL].dbo.GE060 C on B.CD_REPRES = C.CD_REPRES and C.CD_FILIAL=1
  join [intranet].[dbo].COTA009 D on A.ID = D.ID_COTA and B.CD_REPRES = D.ID_REPRES
  join [INTRANET].[dbo].COTA010 E on A.ID = E.ID_COTA and C.CD_REGIAO = E.CD_REGIAO
  join [Auxiliar].dbo.DIM_TEMPO F on E.PERIODO = F.Data
group by  F.Cod_Dia,C.CD_REGIAO, B.ID_COTA, A.DIVISAO,B.CD_REPRES,ID_LINHA , DT_INICIO, DT_FIM
) as DT


--********************************************************************************--
--********************************************************************************--
--********************************************************************************--
--********************************************************************************--
)

AS Origem

--Condição: O produto existe nas 2 tabelas e o cliente também

ON (  
      Destino.Cod_dia = Origem.Cod_dia and
	  Destino.CD_FILIAL = Origem.CD_FILIAL and
	  Destino.CD_REPRES = Origem.CD_REPRES and
	  Destino.CD_REGIAO = Origem.CD_REGIAO and
	  Destino.CD_LINHA_COTA = Origem.CD_LINHA_COTA and
      Destino.CD_DIVISAO = Origem.CD_DIVISAO 
	  )

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas

WHEN MATCHED THEN

    UPDATE SET 
		Destino.VL_COTA = Origem.VL_COTA

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (Cod_dia,
			CD_FILIAL,
			CD_REPRES,
			CD_REGIAO,
			VL_COTA,	
			CD_LINHA_COTA,
			CD_DIVISAO,
			DT_SINC)

    VALUES (Origem.Cod_dia,
			Origem.CD_FILIAL,
			Origem.CD_REPRES,
			Origem.CD_REGIAO,
			Origem.VL_COTA,
			Origem.CD_LINHA_COTA,
			Origem.CD_DIVISAO,
			Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;
RETURN 0
