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
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_DIVISOES]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_DIVISOES];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_LINHAS_AGRUPADAS]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_TEMPO]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_TEMPO];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_FILIAL]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_FILIAL];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_LINHAS_SGE]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_LINHAS_SGE];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_REPRESENTANTE]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_REPRESENTANTE];


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_CLIENTE]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_CLIENTE];


GO
PRINT N'Starting rebuilding table [dbo].[FATO_001]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_FATO_001] (
    [Cod_Dia]          NVARCHAR (50)   NOT NULL,
    [CD_FILIAL]        SMALLINT        NOT NULL,
    [CD_CLIENTE]       INT             NOT NULL,
    [CD_REPRES]        INT             NOT NULL,
    [CD_REGIAO]        CHAR (6)        NOT NULL,
    [CD_ITEM]          CHAR (16)       NOT NULL,
    [QT_FATURADA]      NUMERIC (12, 4) NULL,
    [VL_FATURADA]      NUMERIC (16, 2) NULL,
    [CD_GRUPO]         SMALLINT        NOT NULL,
    [CD_SUBGRUPO]      SMALLINT        NOT NULL,
    [CD_LINHA]         CHAR (6)        NOT NULL,
    [CD_LINHA_COTA]    INT             NOT NULL,
    [CD_DIVISAO]       CHAR (1)        NOT NULL,
    [CD_DIVISAO_LINHA] CHAR (1)        NULL,
    [DT_SINC]          DATETIME        NULL,
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
PRINT N'Starting rebuilding table [dbo].[FATO_002]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_FATO_002] (
    [Cod_Dia]          NVARCHAR (50)   NOT NULL,
    [CD_FILIAL]        SMALLINT        NOT NULL,
    [CD_CLIENTE]       INT             NOT NULL,
    [CD_REPRES]        INT             NOT NULL,
    [CD_REGIAO]        CHAR (6)        NOT NULL,
    [CD_ITEM]          CHAR (16)       NOT NULL,
    [QT_VENDIDA]       NUMERIC (12, 4) NULL,
    [VL_VENDIDO]       NUMERIC (16, 2) NOT NULL,
    [CD_GRUPO]         SMALLINT        NOT NULL,
    [CD_SUBGRUPO]      SMALLINT        NOT NULL,
    [CD_LINHA]         CHAR (6)        NOT NULL,
    [CD_LINHA_COTA]    INT             NOT NULL,
    [CD_DIVISAO]       CHAR (1)        NOT NULL,
    [CD_DIVISAO_LINHA] CHAR (1)        NULL,
    [DT_SINC]          DATETIME        NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_FATO_0021] PRIMARY KEY CLUSTERED ([Cod_Dia] ASC, [CD_FILIAL] ASC, [CD_CLIENTE] ASC, [CD_REPRES] ASC, [CD_REGIAO] ASC, [VL_VENDIDO] ASC, [CD_GRUPO] ASC, [CD_SUBGRUPO] ASC, [CD_LINHA] ASC, [CD_LINHA_COTA] ASC, [CD_DIVISAO] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[FATO_002])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_FATO_002] ([Cod_Dia], [CD_FILIAL], [CD_CLIENTE], [CD_REPRES], [CD_REGIAO], [VL_VENDIDO], [CD_GRUPO], [CD_SUBGRUPO], [CD_LINHA], [CD_LINHA_COTA], [CD_DIVISAO], [CD_ITEM], [QT_VENDIDA], [DT_SINC])
        SELECT   [Cod_Dia],
                 [CD_FILIAL],
                 [CD_CLIENTE],
                 [CD_REPRES],
                 [CD_REGIAO],
                 [VL_VENDIDO],
                 [CD_GRUPO],
                 [CD_SUBGRUPO],
                 [CD_LINHA],
                 [CD_LINHA_COTA],
                 [CD_DIVISAO],
                 [CD_ITEM],
                 [QT_VENDIDA],
                 [DT_SINC]
        FROM     [dbo].[FATO_002]
        ORDER BY [Cod_Dia] ASC, [CD_FILIAL] ASC, [CD_CLIENTE] ASC, [CD_REPRES] ASC, [CD_REGIAO] ASC, [VL_VENDIDO] ASC, [CD_GRUPO] ASC, [CD_SUBGRUPO] ASC, [CD_LINHA] ASC, [CD_LINHA_COTA] ASC, [CD_DIVISAO] ASC;
    END

DROP TABLE [dbo].[FATO_002];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_FATO_002]', N'FATO_002';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_FATO_0021]', N'PK_FATO_002', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_DIVISOES]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_DIVISOES] FOREIGN KEY ([CD_DIVISAO]) REFERENCES [dbo].[DIM_DIVISOES] ([CD_DIVISAO]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_LINHAS_AGRUPADAS]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS] FOREIGN KEY ([CD_LINHA_COTA]) REFERENCES [dbo].[DIM_LINHAS_AGRUPADAS] ([CD_LINHA_COTA]);


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
PRINT N'Creating [dbo].[FK_FATO_001_DIM_LINHAS_SGE]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_LINHAS_SGE] FOREIGN KEY ([CD_GRUPO], [CD_SUBGRUPO]) REFERENCES [dbo].[DIM_LINHAS_SGE] ([CD_GRUPO], [CD_SUBGRUPO]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_REPRESENTANTE]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_REPRESENTANTE] FOREIGN KEY ([CD_REPRES]) REFERENCES [dbo].[DIM_REPRESENTANTE] ([CD_REPRES]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_CLIENTE]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_CLIENTE] FOREIGN KEY ([CD_CLIENTE]) REFERENCES [dbo].[DIM_CLIENTE] ([CD_CLIENTE]);


GO
PRINT N'Refreshing [dbo].[FATO_001_MERGE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[FATO_001_MERGE]';


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_DIVISOES];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_TEMPO];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_FILIAL];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_LINHAS_SGE];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_REPRESENTANTE];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_CLIENTE];


GO
PRINT N'Update complete.';


GO
