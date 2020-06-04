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
PRINT N'Rename refactoring operation with key d11e0d82-8703-401d-ad8e-b94443d68932, ed5cac98-bbca-48dc-8e23-e672c4d818ca is skipped, element [dbo].[FATO_001].[Id] (SqlSimpleColumn) will not be renamed to Cod_Dia';


GO
PRINT N'Rename refactoring operation with key 16267513-7885-44d3-9459-8d8147636f93 is skipped, element [dbo].[FATO_001].[CD_REGIAO] (SqlSimpleColumn) will not be renamed to CD_LINHA_COTA';


GO
PRINT N'The following operation was generated from a refactoring log file 6bcf523a-14ea-479a-a4d7-8376ac408e65, cb3951c3-0d49-4b25-8349-39c345e474b6';

PRINT N'Rename [dbo].[DIM_LINHAS].[CD_LINHAPROD] to CD_LINHA_COTA';


GO
EXECUTE sp_rename @objname = N'[dbo].[DIM_LINHAS].[CD_LINHAPROD]', @newname = N'CD_LINHA_COTA', @objtype = N'COLUMN';


GO
PRINT N'Rename refactoring operation with key 13d05303-d670-4589-b1d8-11f3b61f7420 is skipped, element [dbo].[DIM_DIVISOES].[Id] (SqlSimpleColumn) will not be renamed to CD_DIVISAO';


GO
PRINT N'Altering [dbo].[DIM_LINHAS]...';


GO
ALTER TABLE [dbo].[DIM_LINHAS]
    ADD [DT_SINC] DATETIME NULL;


GO
PRINT N'Creating [dbo].[DIM_DIVISOES]...';


GO
CREATE TABLE [dbo].[DIM_DIVISOES] (
    [CD_DIVISAO] CHAR (1)      NOT NULL,
    [DN_DIVISAO] NVARCHAR (50) NULL,
    [DT_SINC]    DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([CD_DIVISAO] ASC)
);


GO
PRINT N'Creating [dbo].[FATO_001]...';


GO
CREATE TABLE [dbo].[FATO_001] (
    [Cod_Dia]       NVARCHAR (50)   NOT NULL,
    [CD_FILIAL]     SMALLINT        NOT NULL,
    [CD_CLIENTE]    INT             NOT NULL,
    [CD_REPRES]     INT             NOT NULL,
    [CD_REGIAO]     CHAR (6)        NOT NULL,
    [QT_VENDIDO]    NUMERIC (12, 4) NULL,
    [QT_FATURADO]   NUMERIC (12, 4) NULL,
    [VL_FATURADO]   NUMERIC (16, 2) NULL,
    [VL_VENDIDO]    NUMERIC (16, 2) NULL,
    [CD_ITEM]       CHAR (16)       NULL,
    [CD_GRUPO]      SMALLINT        NULL,
    [CD_SUBGRUPO]   SMALLINT        NULL,
    [CD_LINHA]      CHAR (6)        NULL,
    [CD_LINHA_COTA] INT             NULL,
    [CD_DIVISAO]    CHAR (1)        NULL,
    [DT_SINC]       DATETIME        NULL,
    CONSTRAINT [PK_FATO_001] PRIMARY KEY CLUSTERED ([Cod_Dia] ASC, [CD_FILIAL] ASC, [CD_CLIENTE] ASC, [CD_REPRES] ASC, [CD_REGIAO] ASC)
);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_DIVISOES]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_DIVISOES] FOREIGN KEY ([CD_DIVISAO]) REFERENCES [dbo].[DIM_DIVISOES] ([CD_DIVISAO]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_LINHAS]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_LINHAS] FOREIGN KEY ([CD_LINHA_COTA]) REFERENCES [dbo].[DIM_LINHAS] ([CD_LINHA_COTA]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_CLIENTE]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_CLIENTE] FOREIGN KEY ([CD_CLIENTE]) REFERENCES [dbo].[DIM_CLIENTE] ([CD_CLIENTE]);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_TEMPO]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_TEMPO] FOREIGN KEY ([Cod_Dia]) REFERENCES [dbo].[DIM_TEMPO] ([Cod_Dia]);


GO
PRINT N'Creating [dbo].[FK_DIM_LINHAS_DIM_DIVISAO]...';


GO
ALTER TABLE [dbo].[DIM_LINHAS] WITH NOCHECK
    ADD CONSTRAINT [FK_DIM_LINHAS_DIM_DIVISAO] FOREIGN KEY ([CD_DIVISAO]) REFERENCES [dbo].[DIM_DIVISOES] ([CD_DIVISAO]);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd11e0d82-8703-401d-ad8e-b94443d68932')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d11e0d82-8703-401d-ad8e-b94443d68932')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '16267513-7885-44d3-9459-8d8147636f93')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('16267513-7885-44d3-9459-8d8147636f93')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6bcf523a-14ea-479a-a4d7-8376ac408e65')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6bcf523a-14ea-479a-a4d7-8376ac408e65')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '13d05303-d670-4589-b1d8-11f3b61f7420')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('13d05303-d670-4589-b1d8-11f3b61f7420')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'cb3951c3-0d49-4b25-8349-39c345e474b6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('cb3951c3-0d49-4b25-8349-39c345e474b6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ed5cac98-bbca-48dc-8e23-e672c4d818ca')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ed5cac98-bbca-48dc-8e23-e672c4d818ca')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_DIVISOES];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_LINHAS];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_CLIENTE];

ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_TEMPO];

ALTER TABLE [dbo].[DIM_LINHAS] WITH CHECK CHECK CONSTRAINT [FK_DIM_LINHAS_DIM_DIVISAO];


GO
PRINT N'Update complete.';


GO
