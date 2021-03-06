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
PRINT N'The following operation was generated from a refactoring log file 387ba600-a880-4bd7-809c-58e124948cc0';

PRINT N'Rename [dbo].[FK_FATO_001_DIM_LINHAS] to FK_FATO_001_DIM_LINHAS_AGRUPADAS';


GO
EXECUTE sp_rename @objname = N'[dbo].[FK_FATO_001_DIM_LINHAS]', @newname = N'FK_FATO_001_DIM_LINHAS_AGRUPADAS', @objtype = N'OBJECT';


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_LINHAS_AGRUPADAS]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS];


GO
PRINT N'Creating [dbo].[DIM_LINHAS_AGRUPADAS]...';


GO
CREATE TABLE [dbo].[DIM_LINHAS_AGRUPADAS] (
    [CD_LINHA_COTA] INT          NOT NULL,
    [DN_LINHA_COTA] VARCHAR (50) NULL,
    [CD_DIVISAO]    CHAR (1)     NULL,
    [DT_SINC]       DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([CD_LINHA_COTA] ASC)
);


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_LINHAS_AGRUPADAS]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS] FOREIGN KEY ([CD_LINHA_COTA]) REFERENCES [dbo].[DIM_LINHAS_AGRUPADAS] ([CD_LINHA_COTA]);


GO
PRINT N'Creating [dbo].[FK_DIM_LINHAS_DIM_DIVISAO]...';


GO
ALTER TABLE [dbo].[DIM_LINHAS_AGRUPADAS] WITH NOCHECK
    ADD CONSTRAINT [FK_DIM_LINHAS_DIM_DIVISAO] FOREIGN KEY ([CD_DIVISAO]) REFERENCES [dbo].[DIM_DIVISOES] ([CD_DIVISAO]);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '387ba600-a880-4bd7-809c-58e124948cc0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('387ba600-a880-4bd7-809c-58e124948cc0')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS];

ALTER TABLE [dbo].[DIM_LINHAS_AGRUPADAS] WITH CHECK CHECK CONSTRAINT [FK_DIM_LINHAS_DIM_DIVISAO];


GO
PRINT N'Update complete.';


GO
