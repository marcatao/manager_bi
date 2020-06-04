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
PRINT N'Rename refactoring operation with key 8564cc18-ab69-4af4-9f95-3067c0946f6a is skipped, element [dbo].[DIM_CLIENTE].[DN_BARIRRO] (SqlSimpleColumn) will not be renamed to DN_BAIRRO';


GO
PRINT N'Dropping [dbo].[FK_FATO_001_DIM_CLIENTE]...';


GO
ALTER TABLE [dbo].[FATO_001] DROP CONSTRAINT [FK_FATO_001_DIM_CLIENTE];


GO
PRINT N'Starting rebuilding table [dbo].[DIM_CLIENTE]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_DIM_CLIENTE] (
    [CD_CLIENTE]        INT             NOT NULL,
    [CD_CGCCPF]         CHAR (18)       NULL,
    [DN_FANTASIA]       CHAR (20)       NULL,
    [CD_MUNICIPIO]      CHAR (5)        NULL,
    [DN_MUNICIPIO]      CHAR (35)       NULL,
    [DN_BAIRRO]         CHAR (15)       NULL,
    [CD_CEP]            INT             NULL,
    [NR_ENDERECO]       INT             NULL,
    [CD_UF]             CHAR (4)        NULL,
    [DN_UF]             CHAR (20)       NULL,
    [TP_SITUACAO_SGE]   CHAR (1)        NULL,
    [VL_LIMITE_CREDITO] NUMERIC (16, 2) NULL,
    [DT_SINC]           DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([CD_CLIENTE] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[DIM_CLIENTE])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_DIM_CLIENTE] ([CD_CLIENTE], [CD_CGCCPF], [DN_FANTASIA], [CD_MUNICIPIO], [DN_MUNICIPIO], [CD_CEP], [NR_ENDERECO], [CD_UF], [DN_UF], [TP_SITUACAO_SGE], [VL_LIMITE_CREDITO], [DT_SINC])
        SELECT   [CD_CLIENTE],
                 [CD_CGCCPF],
                 [DN_FANTASIA],
                 [CD_MUNICIPIO],
                 [DN_MUNICIPIO],
                 [CD_CEP],
                 [NR_ENDERECO],
                 [CD_UF],
                 [DN_UF],
                 [TP_SITUACAO_SGE],
                 [VL_LIMITE_CREDITO],
                 [DT_SINC]
        FROM     [dbo].[DIM_CLIENTE]
        ORDER BY [CD_CLIENTE] ASC;
    END

DROP TABLE [dbo].[DIM_CLIENTE];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_DIM_CLIENTE]', N'DIM_CLIENTE';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_FATO_001_DIM_CLIENTE]...';


GO
ALTER TABLE [dbo].[FATO_001] WITH NOCHECK
    ADD CONSTRAINT [FK_FATO_001_DIM_CLIENTE] FOREIGN KEY ([CD_CLIENTE]) REFERENCES [dbo].[DIM_CLIENTE] ([CD_CLIENTE]);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '8564cc18-ab69-4af4-9f95-3067c0946f6a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('8564cc18-ab69-4af4-9f95-3067c0946f6a')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FATO_001] WITH CHECK CHECK CONSTRAINT [FK_FATO_001_DIM_CLIENTE];


GO
PRINT N'Update complete.';


GO
