﻿/*
Deployment script for Auxiliar

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Auxiliar"
:setvar DefaultFilePrefix "Auxiliar"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.SGETESTE\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.SGETESTE\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Altering [dbo].[DIM_PRODUTOS_MERGE]...';


GO
ALTER PROCEDURE [dbo].[DIM_PRODUTOS_MERGE]
 
AS
	MERGE [Auxiliar].[dbo].DIM_PRODUTOS AS Destino

USING (

select CD_FILIAL,
       A.CD_ITEM,
	   DN_ITEM_COM,
	   A.DN_ITEM_IND, 
	   B.CD_CLASSE_ABC, 
	   A.CD_CLASSIF,
	   A.CD_GRUPO,
	   B.CD_SUBGRUPO,
	   C.CD_LINHA,
	   C.VL_CUSTO_INDUST,
	   B.TP_OBSOLETO as TP_OBSOLETO_IND, 
	   C.TP_OBSOLETO as TP_OBSOLETO_COM,
	   CURRENT_TIMESTAMP as DT_SINC

from [FISCAL].[dbo].GE003 A
left join [FISCAL].[dbo].CI107 B on A.CD_ITEM = B.CD_ITEM and A.CD_GRUPO = B.CD_GRUPO and A.CD_SUBGRUPO = B.CD_SUBGRUPO
left join [FISCAL].[dbo].CC105 C on A.CD_ITEM = C.CD_ITEM and A.CD_GRUPO = C.CD_GRUPO and A.CD_SUBGRUPO = C.CD_SUBGRUPO
where A.CD_GRUPO = 6 and CD_SUBGRUPO <> 65
 


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
	        Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;





RETURN 0
GO
PRINT N'Altering [dbo].[FATO_001_MERGE]...';


GO
ALTER PROCEDURE [dbo].[FATO_001_MERGE]
 
AS
	MERGE dbo.FATO_001 AS Destino

USING 
(

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
	  SUM(QT_FATURADA) as QT_FATURADA,
	  SUM(VL_FATURADA) as VL_FATURADA,
	  CD_GRUPO,
	  CD_SUBGRUPO,
	  CD_LINHA,
	  CD_LINHA_COTA,
      CD_DIVISAO,
	  CURRENT_TIMESTAMP as DT_SINC
from(
select         B.Cod_dia,
               A.CD_FILIAL,
			   A.CD_CLIENTE,
			   A.CD_REPRES,
			   A.CD_REGIAO,
			   A.CD_ITEM,
			   A.QT_FATURADA,
			   A.VL_TOT_ITEM as VL_FATURADA,
			   A.CD_GRUPO,
			   A.CD_SUBGRUPO,
			   A.CD_LINHA,
			   isNull((select TOP 1 CD_LINHA_COTA from [FISCAL].[dbo].LINHAS_COTA H where A.CD_GRUPO = H.CD_GRUPO and A.CD_SUBGRUPO = H.CD_SUBGRUPO and A.CD_LINHA=H.CD_LINHA),'0') as CD_LINHA_COTA,
			   A.DIVISAO as CD_DIVISAO
			 
from 
[Fiscal].dbo.FATURAMENTO A
Join [Auxiliar].[dbo].DIM_TEMPO B on A.DT_EMISSAO = B.[Data]
where CD_CLIENTE IN (select CD_CLIENTE from DIM_CLIENTE) and
B.Data > '2018-01-01'
) as T
where CD_GRUPO = 6  and CD_SUBGRUPO not in (65)
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
      CD_DIVISAO


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
	  Destino.CD_CLIENTE = Origem.CD_CLIENTE and
	  Destino.CD_REPRES = Origem.CD_REPRES and
	  Destino.CD_REGIAO = Origem.CD_REGIAO and
	  Destino.CD_ITEM = Origem.CD_ITEM and
	  Destino.CD_GRUPO = Origem.CD_GRUPO and
	  Destino.CD_SUBGRUPO = Origem.CD_SUBGRUPO and
	  Destino.CD_LINHA = Origem.CD_LINHA and
	  Destino.CD_LINHA_COTA = Origem.CD_LINHA_COTA and
      Destino.CD_DIVISAO = Origem.CD_DIVISAO
	  )

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas

WHEN MATCHED THEN

    UPDATE SET 
		Destino.QT_FATURADA = Origem.QT_FATURADA,
		Destino.VL_FATURADA = Origem.VL_FATURADA,
		Destino.DT_SINC=Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (Cod_dia,
			CD_FILIAL,
			CD_CLIENTE,
			CD_REPRES,
			CD_REGIAO,
			CD_ITEM,
			QT_FATURADA,
			VL_FATURADA,
			CD_GRUPO,
			CD_SUBGRUPO,
			CD_LINHA,
			CD_LINHA_COTA,
			CD_DIVISAO,
			DT_SINC)

    VALUES (Origem.Cod_dia,
			Origem.CD_FILIAL,
			Origem.CD_CLIENTE,
			Origem.CD_REPRES,
			Origem.CD_REGIAO,
			Origem.CD_ITEM,
			Origem.QT_FATURADA,
			Origem.VL_FATURADA,
			Origem.CD_GRUPO,
			Origem.CD_SUBGRUPO,
			Origem.CD_LINHA,
			Origem.CD_LINHA_COTA,
			Origem.CD_DIVISAO,
			Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;


RETURN 0
GO
PRINT N'Update complete.';


GO
