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
/*
The column [dbo].[FATO_003].[CD_LINHA] is being dropped, data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[FATO_003])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Starting rebuilding table [dbo].[FATO_003]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_FATO_003] (
    [Cod_Mes_Ano]      NVARCHAR (50)   NOT NULL,
    [CD_FILIAL]        SMALLINT        NOT NULL,
    [CD_REPRES]        INT             NOT NULL,
    [CD_REGIAO]        CHAR (6)        NOT NULL,
    [VL_COTA]          NUMERIC (16, 2) NULL,
    [CD_GRUPO]         SMALLINT        NOT NULL,
    [CD_SUBGRUPO]      SMALLINT        NOT NULL,
    [CD_LINHA_COTA]    INT             NOT NULL,
    [CD_DIVISAO]       CHAR (1)        NOT NULL,
    [CD_DIVISAO_LINHA] CHAR (1)        NULL,
    [DT_SINC]          DATETIME        NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_FATO_0031] PRIMARY KEY CLUSTERED ([Cod_Mes_Ano] ASC, [CD_FILIAL] ASC, [CD_REPRES] ASC, [CD_REGIAO] ASC, [CD_GRUPO] ASC, [CD_SUBGRUPO] ASC, [CD_LINHA_COTA] ASC, [CD_DIVISAO] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[FATO_003])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_FATO_003] ([Cod_Mes_Ano], [CD_FILIAL], [CD_REPRES], [CD_REGIAO], [CD_GRUPO], [CD_SUBGRUPO], [CD_LINHA_COTA], [CD_DIVISAO], [VL_COTA], [CD_DIVISAO_LINHA], [DT_SINC])
        SELECT   [Cod_Mes_Ano],
                 [CD_FILIAL],
                 [CD_REPRES],
                 [CD_REGIAO],
                 [CD_GRUPO],
                 [CD_SUBGRUPO],
                 [CD_LINHA_COTA],
                 [CD_DIVISAO],
                 [VL_COTA],
                 [CD_DIVISAO_LINHA],
                 [DT_SINC]
        FROM     [dbo].[FATO_003]
        ORDER BY [Cod_Mes_Ano] ASC, [CD_FILIAL] ASC, [CD_REPRES] ASC, [CD_REGIAO] ASC, [CD_GRUPO] ASC, [CD_SUBGRUPO] ASC, [CD_LINHA_COTA] ASC, [CD_DIVISAO] ASC;
    END

DROP TABLE [dbo].[FATO_003];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_FATO_003]', N'FATO_003';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_FATO_0031]', N'PK_FATO_003', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Update complete.';


GO
