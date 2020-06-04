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
PRINT N'Rename refactoring operation with key 204df8f4-b78f-442a-84a5-0c89368f3e1a is skipped, element [dbo].[DIM_PRODUTOS].[Id] (SqlSimpleColumn) will not be renamed to CD_FILIAL';


GO
PRINT N'Creating [dbo].[DIM_PRODUTOS]...';


GO
CREATE TABLE [dbo].[DIM_PRODUTOS] (
    [CD_FILIAL]       INT             NOT NULL,
    [CD_ITEM]         CHAR (16)       NOT NULL,
    [DN_INTEM_COM]    CHAR (50)       NULL,
    [DN_ITEM_IND]     CHAR (50)       NULL,
    [CD_CLASSE_ABC]   CHAR (1)        NULL,
    [CD_CLASSIF]      NUMERIC (10)    NULL,
    [CD_GRUPO]        SMALLINT        NULL,
    [CD_SUBGRUPO]     SMALLINT        NULL,
    [CD_LINHA]        CHAR (6)        NULL,
    [VL_CUSTO_INDUST] NUMERIC (12, 4) NULL,
    [TP_OBSOLETO_IND] CHAR (1)        NULL,
    [TP_OBSOLETO_COM] CHAR (1)        NULL,
    CONSTRAINT [PK_DIM_PRODUTOS] PRIMARY KEY CLUSTERED ([CD_FILIAL] ASC, [CD_ITEM] ASC)
);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '204df8f4-b78f-442a-84a5-0c89368f3e1a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('204df8f4-b78f-442a-84a5-0c89368f3e1a')

GO

GO
PRINT N'Update complete.';


GO