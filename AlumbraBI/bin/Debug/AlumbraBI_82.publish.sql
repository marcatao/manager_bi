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
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.SOLO\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.SOLO\MSSQL\DATA\"

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
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET RECOVERY FULL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Dropping [dbo].[FK_DIM_PRODUTOS_DIM_LINHAS_SGE]...';


GO
ALTER TABLE [dbo].[DIM_PRODUTOS] DROP CONSTRAINT [FK_DIM_PRODUTOS_DIM_LINHAS_SGE];


GO
PRINT N'Starting rebuilding table [dbo].[DIM_PRODUTOS]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_DIM_PRODUTOS] (
    [CD_FILIAL]       INT             NOT NULL,
    [CD_ITEM]         CHAR (16)       NOT NULL,
    [DN_ITEM_COM]     CHAR (50)       NULL,
    [DN_ITEM_IND]     CHAR (50)       NULL,
    [CD_CLASSE_ABC]   CHAR (1)        NULL,
    [CD_CLASSIF]      NUMERIC (10)    NULL,
    [CD_GRUPO]        SMALLINT        NULL,
    [CD_SUBGRUPO]     SMALLINT        NULL,
    [CD_LINHA]        CHAR (6)        NULL,
    [VL_CUSTO_INDUST] NUMERIC (12, 4) NULL,
    [TP_OBSOLETO_IND] CHAR (1)        NULL,
    [TP_OBSOLETO_COM] CHAR (1)        NULL,
    [CD_ORIG_MERCAD]  SMALLINT        NULL,
    [DT_SINC]         DATETIME        NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_DIM_PRODUTOS1] PRIMARY KEY CLUSTERED ([CD_ITEM] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[DIM_PRODUTOS])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_DIM_PRODUTOS] ([CD_ITEM], [CD_FILIAL], [DN_ITEM_COM], [DN_ITEM_IND], [CD_CLASSE_ABC], [CD_CLASSIF], [CD_GRUPO], [CD_SUBGRUPO], [CD_LINHA], [VL_CUSTO_INDUST], [TP_OBSOLETO_IND], [TP_OBSOLETO_COM], [DT_SINC])
        SELECT   [CD_ITEM],
                 [CD_FILIAL],
                 [DN_ITEM_COM],
                 [DN_ITEM_IND],
                 [CD_CLASSE_ABC],
                 [CD_CLASSIF],
                 [CD_GRUPO],
                 [CD_SUBGRUPO],
                 [CD_LINHA],
                 [VL_CUSTO_INDUST],
                 [TP_OBSOLETO_IND],
                 [TP_OBSOLETO_COM],
                 [DT_SINC]
        FROM     [dbo].[DIM_PRODUTOS]
        ORDER BY [CD_ITEM] ASC;
    END

DROP TABLE [dbo].[DIM_PRODUTOS];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_DIM_PRODUTOS]', N'DIM_PRODUTOS';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_DIM_PRODUTOS1]', N'PK_DIM_PRODUTOS', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_DIM_PRODUTOS_DIM_LINHAS_SGE]...';


GO
ALTER TABLE [dbo].[DIM_PRODUTOS] WITH NOCHECK
    ADD CONSTRAINT [FK_DIM_PRODUTOS_DIM_LINHAS_SGE] FOREIGN KEY ([CD_GRUPO], [CD_SUBGRUPO]) REFERENCES [dbo].[DIM_LINHAS_SGE] ([CD_GRUPO], [CD_SUBGRUPO]);


GO
PRINT N'Altering [dbo].[DIM_PRODUTOS_MERGE]...';


GO
ALTER PROCEDURE [dbo].[DIM_PRODUTOS_MERGE]
 
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
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[DIM_PRODUTOS] WITH CHECK CHECK CONSTRAINT [FK_DIM_PRODUTOS_DIM_LINHAS_SGE];


GO
PRINT N'Update complete.';


GO
