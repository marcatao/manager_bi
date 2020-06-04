CREATE PROCEDURE [dbo].[DIM_PRODUTOS_MERGE]
 
AS
	MERGE [Auxiliar].[dbo].DIM_PRODUTOS AS Destino

USING (

select isnull(CD_FILIAL,1) as CD_FILIAL,
       A.CD_ITEM,
	   DN_ITEM_COM,
	   A.DN_ITEM_IND, 
	   B.CD_CLASSE_ABC, 
	   A.CD_CLASSIF,
	   A.CD_GRUPO,
	   A.CD_SUBGRUPO,
	   C.CD_LINHA,
	   C.VL_CUSTO_INDUST,
	   B.TP_OBSOLETO as TP_OBSOLETO_IND, 
	   C.TP_OBSOLETO as TP_OBSOLETO_COM,
	   C.CD_ORIG_MERCAD,
	   CURRENT_TIMESTAMP as DT_SINC

from [FISCAL].[dbo].GE003 A
join [FISCAL].[dbo].CC105 C on A.CD_ITEM = C.CD_ITEM and A.CD_GRUPO = C.CD_GRUPO and A.CD_SUBGRUPO = C.CD_SUBGRUPO
left join [FISCAL].[dbo].CI107 B on A.CD_ITEM = B.CD_ITEM and A.CD_GRUPO = B.CD_GRUPO and A.CD_SUBGRUPO = B.CD_SUBGRUPO
where A.CD_GRUPO = 6 and  LTRIM(RTRIM(A.CD_SUBGRUPO))  in (select LTRIM(RTRIM(CD_SUBGRUPO)) from DIM_LINHAS_SGE)
 


) AS Origem

--Condição: O produto existe nas 2 tabelas e o cliente também
ON (Destino.CD_FILIAL = Origem.CD_FILIAL and
    Destino.CD_ITEM = Origem.CD_ITEM	)

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas
WHEN MATCHED THEN

    UPDATE SET Destino.DN_ITEM_COM = Origem.DN_ITEM_COM,
	           Destino.DN_ITEM_IND = Origem.DN_ITEM_IND,
	           Destino.CD_CLASSE_ABC = Origem.CD_CLASSE_ABC,
			   Destino.CD_CLASSIF = Origem.CD_CLASSIF,
			   Destino.CD_GRUPO = Origem.CD_GRUPO,
			   Destino.CD_SUBGRUPO = Origem.CD_SUBGRUPO,
			   Destino.CD_LINHA = Origem.CD_LINHA,
			   Destino.VL_CUSTO_INDUST = Origem.VL_CUSTO_INDUST,
			   Destino.TP_OBSOLETO_IND = Origem.TP_OBSOLETO_IND,
	           Destino.TP_OBSOLETO_COM = Origem.TP_OBSOLETO_COM,
	           Destino.CD_ORIG_MERCAD = Origem.CD_ORIG_MERCAD,
	           Destino.DT_SINC = Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_FILIAL,
            CD_ITEM,
	        DN_ITEM_COM,
	        DN_ITEM_IND, 
	        CD_CLASSE_ABC, 
	        CD_CLASSIF,
	        CD_GRUPO,
	        CD_SUBGRUPO,
	        CD_LINHA,
	        VL_CUSTO_INDUST,
	        TP_OBSOLETO_IND, 
	        TP_OBSOLETO_COM,
			CD_ORIG_MERCAD,
	        DT_SINC
			)

    VALUES (Origem.CD_FILIAL,
            Origem.CD_ITEM,
	        Origem.DN_ITEM_COM,
	        Origem.DN_ITEM_IND, 
	        Origem.CD_CLASSE_ABC, 
	        Origem.CD_CLASSIF,
	        Origem.CD_GRUPO,
	        Origem.CD_SUBGRUPO,
	        Origem.CD_LINHA,
	        Origem.VL_CUSTO_INDUST,
	        Origem.TP_OBSOLETO_IND, 
	        Origem.TP_OBSOLETO_COM,
			Origem.CD_ORIG_MERCAD,
			Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;





RETURN 0
