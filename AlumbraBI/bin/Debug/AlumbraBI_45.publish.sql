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
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_TEMPO]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_TEMPO];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_FILIAL]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_FILIAL];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_CLIENTE]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_CLIENTE];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_DIVISOES]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_DIVISOES];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_LINHAS_SGE]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_LINHAS_SGE];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_LINHAS_AGRUPADAS]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS];


GO
PRINT N'Starting rebuilding table [dbo].[FATO_001]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_FATO_001] (
    [Cod_Dia]       NVARCHAR (50)   NOT NULL,
    [CD_FILIAL]     SMALLINT        NOT NULL,
    [CD_CLIENTE]    INT             NOT NULL,
    [CD_REPRES]     INT             NOT NULL,
    [CD_REGIAO]     CHAR (6)        NOT NULL,
    [CD_ITEM]       CHAR (16)       NOT NULL,
    [QT_VENDIDA]    NUMERIC (12, 4) NULL,
    [QT_FATURADA]   NUMERIC (12, 4) NULL,
    [VL_VENDIDA]    NUMERIC (16, 2) NULL,
    [VL_FATURADA]   NUMERIC (16, 2) NULL,
    [CD_GRUPO]      SMALLINT        NOT NULL,
    [CD_SUBGRUPO]   SMALLINT        NOT NULL,
    [CD_LINHA]      CHAR (6)        NOT NULL,
    [CD_LINHA_COTA] INT             NOT NULL,
    [CD_DIVISAO]    CHAR (1)        NOT NULL,
    [DT_SINC]       DATETIME        NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_FATO_0011] PRIMARY KEY CLUSTERED ([Cod_Dia] ASC, [CD_FILIAL] ASC, [CD_CLIENTE] ASC, [CD_REPRES] ASC, [CD_REGIAO] ASC, [CD_ITEM] ASC, [CD_GRUPO] ASC, [CD_SUBGRUPO] ASC, [CD_LINHA] ASC, [CD_LINHA_COTA] ASC, [CD_DIVISAO] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[FATO_001])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_FATO_001] ([Cod_Dia], [CD_FILIAL], [CD_CLIENTE], [CD_REPRES], [CD_REGIAO], [CD_ITEM], [CD_GRUPO], [CD_SUBGRUPO], [CD_LINHA], [CD_LINHA_COTA], [CD_DIVISAO], [QT_FATURADA], [VL_FATURADA], [DT_SINC])
        SELECT   [Cod_Dia],
                 [CD_FILIAL],
                 [CD_CLIENTE],
                 [CD_REPRES],
                 [CD_REGIAO],
                 [CD_ITEM],
                 [CD_GRUPO],
                 [CD_SUBGRUPO],
                 [CD_LINHA],
                 [CD_LINHA_COTA],
                 [CD_DIVISAO],
                 [QT_FATURADA],
                 [VL_FATURADA],
                 [DT_SINC]
        FROM     [dbo].[FATO_001]
        ORDER BY [Cod_Dia] ASC, [CD_FILIAL] ASC, [CD_CLIENTE] ASC, [CD_REPRES] ASC, [CD_REGIAO] ASC, [CD_ITEM] ASC, [CD_GRUPO] ASC, [CD_SUBGRUPO] ASC, [CD_LINHA] ASC, [CD_LINHA_COTA] ASC, [CD_DIVISAO] ASC;
    END

DROP TABLE [dbo].[FATO_001];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_FATO_001]', N'FATO_001';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_FATO_0011]', N'PK_FATO_001', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_TEMPO]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_TEMPO] FOREIGN KEY ([Cod_Dia]) REFERENCES [dbo].[DIM_TEMPO] ([Cod_Dia]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_FILIAL]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_FILIAL] FOREIGN KEY ([CD_FILIAL]) REFERENCES [dbo].[DIM_FILIAL] ([CD_FILIAL]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_CLIENTE]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_CLIENTE] FOREIGN KEY ([CD_CLIENTE]) REFERENCES [dbo].[DIM_CLIENTE] ([CD_CLIENTE]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_DIVISOES]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_DIVISOES] FOREIGN KEY ([CD_DIVISAO]) REFERENCES [dbo].[DIM_DIVISOES] ([CD_DIVISAO]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_LINHAS_SGE]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_LINHAS_SGE] FOREIGN KEY ([CD_GRUPO], [CD_SUBGRUPO]) REFERENCES [dbo].[DIM_LINHAS_SGE] ([CD_GRUPO], [CD_SUBGRUPO]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_LINHAS_AGRUPADAS]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS] FOREIGN KEY ([CD_LINHA_COTA]) REFERENCES [dbo].[DIM_LINHAS_AGRUPADAS] ([CD_LINHA_COTA]);


GO
PRINT N'Creating [dbo].[FATO_001_MERGE]...';


GO
CREATE PROCEDURE [dbo].[FATO_001_MERGE]
 
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
) as T
where CD_GRUPO = 6 and CD_CLIENTE not in (12197,12200,15621,18745)
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
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_TEMPO];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_FILIAL];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_CLIENTE];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_DIVISOES];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_LINHAS_SGE];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS];


GO
PRINT N'Update complete.';


GO
