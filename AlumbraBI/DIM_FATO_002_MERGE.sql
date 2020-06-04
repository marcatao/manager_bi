CREATE PROCEDURE [dbo].[DIM_FATO_002_MERGE]
 
AS

MERGE dbo.FATO_002 AS Destino

USING (


--********************************************************************************--
--********************************************************************************--
--********************************************************************************--
--********************************************************************************--


select 
      Cod_dia,
	  CD_FILIAL,
	  CD_CLIENTE,
	  CD_REPRES,
	  CD_REGIAO,
	  CD_ITEM,
	  SUM(QTD) as QT_VENDIDA,
	  SUM(VALOR) as VL_VENDIDO,
	  CD_GRUPO,
	  CD_SUBGRUPO,
	  CD_LINHA,
	  CD_LINHA_COTA,
      CD_DIVISAO,
	  CD_DIVISAO_LINHA,
	  CURRENT_TIMESTAMP as DT_SINC
from(

select         B.Cod_dia,
               A.CD_FILIAL,
			   A.CD_CLIENTE,
			   A.CD_REPRES,
			   A.CD_REGIAO,
			   A.CD_ITEM,
			   A.QTD,
			   A.VALOR,
			   '6' as CD_GRUPO,
			   A.CD_SUBGRUPO,
			   A.CD_LINHA,
			   isNull((select TOP 1 CD_LINHA_COTA from [FISCAL].[dbo].LINHAS_COTA H where 6 = H.CD_GRUPO and A.CD_SUBGRUPO = H.CD_SUBGRUPO and A.CD_LINHA=H.CD_LINHA),'0') as CD_LINHA_COTA,
			   A.DIVISAO as CD_DIVISAO,
			   A.CD_DIVISAO_LINHA
			 
from 
[Fiscal].dbo.VENDAS A
Join [Auxiliar].[dbo].DIM_TEMPO B on A.DT_IMPLANTACAO = B.[Data]
where CD_CLIENTE IN (select CD_CLIENTE from DIM_CLIENTE) and
B.Data > '2010-01-01' and  A.CD_SUBGRUPO  in (select CD_SUBGRUPO from DIM_LINHAS_SGE)
) as T
where CD_GRUPO = 6 
group by
      Cod_dia,
	  CD_FILIAL,
	  CD_CLIENTE,
	  CD_REPRES,
	  CD_REGIAO,
	  CD_ITEM,
	  CD_GRUPO,
	  CD_SUBGRUPO,
	  CD_LINHA,
	  CD_LINHA_COTA,
      CD_DIVISAO,
	  CD_DIVISAO_LINHA

--********************************************************************************--
--********************************************************************************--
--********************************************************************************--
--********************************************************************************--

)

AS Origem
ON (  
      Destino.Cod_dia = Origem.Cod_dia and
	  Destino.CD_FILIAL = Origem.CD_FILIAL and
	  Destino.CD_CLIENTE = Origem.CD_CLIENTE and
	  Destino.CD_REPRES = Origem.CD_REPRES and
	  Destino.CD_REGIAO = Origem.CD_REGIAO and
	  Destino.CD_ITEM = Origem.CD_ITEM and
	  Destino.CD_GRUPO = Origem.CD_GRUPO and
	  Destino.CD_SUBGRUPO = Origem.CD_SUBGRUPO and
	  Destino.CD_LINHA = Origem.CD_LINHA and
	  Destino.CD_LINHA_COTA = Origem.CD_LINHA_COTA and
      Destino.CD_DIVISAO = Origem.CD_DIVISAO and 
	  Destino.CD_DIVISAO_LINHA = Origem.CD_DIVISAO_LINHA
	  )

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas

WHEN MATCHED THEN

    UPDATE SET 
		Destino.QT_VENDIDA = Origem.QT_VENDIDA,
		Destino.VL_VENDIDO = Origem.VL_VENDIDO,
		Destino.DT_SINC=Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (Cod_dia,
			CD_FILIAL,
			CD_CLIENTE,
			CD_REPRES,
			CD_REGIAO,
			CD_ITEM,
			QT_VENDIDA,
			VL_VENDIDO,
			CD_GRUPO,
			CD_SUBGRUPO,
			CD_LINHA,
			CD_LINHA_COTA,
			CD_DIVISAO,
			CD_DIVISAO_LINHA,
			DT_SINC)

    VALUES (Origem.Cod_dia,
			Origem.CD_FILIAL,
			Origem.CD_CLIENTE,
			Origem.CD_REPRES,
			Origem.CD_REGIAO,
			Origem.CD_ITEM,
			Origem.QT_VENDIDA,
			Origem.VL_VENDIDO,
			Origem.CD_GRUPO,
			Origem.CD_SUBGRUPO,
			Origem.CD_LINHA,
			Origem.CD_LINHA_COTA,
			Origem.CD_DIVISAO,
			Origem.CD_DIVISAO_LINHA,
			Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;

 
RETURN 0
