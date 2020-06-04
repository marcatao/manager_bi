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
PRINT N'Creating [dbo].[DIM_FILIAL_MERGE]...';


GO
CREATE PROCEDURE [dbo].[DIM_FILIAL_MERGE]
	
AS
MERGE [Auxiliar].[dbo].[DIM_FILIAL] AS Destino

USING (select CD_FILIAL, DN_FANTASIA,DN_RAZAO,CD_CGCCPF,CURRENT_TIMESTAMP as DT_SINC from [Fiscal].[dbo].[GE018]) AS Origem
ON (Destino.CD_FILIAL = Origem.CD_FILIAL AND Destino.DN_FANTASIA = Origem.DN_FANTASIA and Destino.DN_RAZAO = Origem.DN_RAZAO and Destino.CD_CGCCPF = Origem.CD_CGCCPF)

WHEN MATCHED THEN
    UPDATE SET Destino.DN_FANTASIA = Origem.DN_FANTASIA, Destino.DT_SINC=Origem.DT_SINC

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_FILIAL, DN_FANTASIA, DN_RAZAO, CD_CGCCPF,DT_SINC)
    VALUES (Origem.CD_FILIAL, Origem.DN_FANTASIA, Origem.DN_RAZAO, Origem.CD_CGCCPF, Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;

RETURN 0
GO
PRINT N'Update complete.';


GO