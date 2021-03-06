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
PRINT N'Creating [dbo].[DIM_REPRESENTANTE_MERGE]...';


GO
CREATE PROCEDURE [dbo].[DIM_REPRESENTANTE_MERGE]
 
AS
 

MERGE [Auxiliar].[dbo].DIM_REPRESENTANTE AS Destino

USING (

select distinct(cd_repres) as CD_REPRES, 
       CD_CGCCPF,
	   DN_FANTASIA,
	   TP_SITUACAO,
	   NR_CONTRATO,
	   CD_REGIAO,
	   CD_GERENTE,
	   CURRENT_TIMESTAMP as DT_SINC
from [FISCAL].[dbo].ge060
where CD_FILIAL not in (3,4,5,6)
 
 


) AS Origem

--Condição: O produto existe nas 2 tabelas e o cliente também

ON (Destino.CD_REPRES = Origem.CD_REPRES)

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas

WHEN MATCHED THEN

    UPDATE SET Destino.CD_CGCCPF = Origem.CD_CGCCPF,
		    	Destino.DN_FANTASIA = Origem.DN_FANTASIA,
				Destino.TP_SITUACAO	= Origem.TP_SITUACAO,
				Destino.NR_CONTRATO	= Origem.NR_CONTRATO,
				Destino.CD_REGIAO = Origem.CD_REGIAO,
				Destino.CD_GERENTE = Origem.CD_GERENTE,
				Destino.DT_SINC = Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_REPRES, 
			CD_CGCCPF,
			DN_FANTASIA,
			TP_SITUACAO,
			NR_CONTRATO,
			CD_REGIAO,
			CD_GERENTE,
			DT_SINC )

    VALUES (Origem.CD_REPRES, 
			Origem.CD_CGCCPF,
			Origem.DN_FANTASIA,
			Origem.TP_SITUACAO,
			Origem.NR_CONTRATO,
			Origem.CD_REGIAO,
			Origem.CD_GERENTE,
			Origem.DT_SINC )

OUTPUT $action, Inserted.*, Deleted.*;
 

RETURN 0
GO
PRINT N'Update complete.';


GO
