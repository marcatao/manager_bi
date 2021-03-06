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
PRINT N'Altering [dbo].[DIM_CLIENTE_MERGE]...';


GO
ALTER PROCEDURE [dbo].[DIM_CLIENTE_MERGE]

AS
	MERGE [Auxiliar].[dbo].[DIM_CLIENTE] AS Destino

USING 

(select A.CD_CLIENTE,
	   A.CD_CGCCPF,
	   A.DN_FANTASIA,
	   B.CD_MUNICIPIO,
	   C.DN_MUNICIPIO,
	   B.DN_BAIRRO,
	   B.CD_CEP,
	   B.NR_ENDERECO,
	   C.CD_UF,
	   D.DN_UF,
	   A.TP_SITUACAO as TP_SITUACAO_SGE,
	   A.VL_LIMITE_CRED,
	   convert(date,B.DT_IMPLANTACAO) as DT_IMPLANTACAO,
	   B.CD_CNAE as CD_CNAE,
	   CURRENT_TIMESTAMP as  DT_SINC
from [FISCAL].[dbo].GE023 A
left join [FISCAL].[dbo].GE010 B on A.CD_CGCCPF = B.CD_CGCCPF
left join [FISCAL].[dbo].GE013 C on B.CD_MUNICIPIO = C.CD_MUNICIPIO
left join [FISCAL].[dbo].GE012 D on C.CD_UF = D.CD_UF and D.CD_PAIS='0001')

AS Origem

--Verificar alteraçãoes no cliente
ON (Destino.CD_CLIENTE = Origem.CD_CLIENTE AND 
    Destino.CD_CGCCPF = Origem.CD_CGCCPF 
	)

--Os campos que devem alterar
WHEN MATCHED THEN
    UPDATE SET Destino.CD_MUNICIPIO = Origem.CD_MUNICIPIO,
			   Destino.DN_MUNICIPIO = Origem.DN_MUNICIPIO,
			   Destino.DN_BAIRRO = Origem.DN_BAIRRO,
			   Destino.CD_CEP = Origem.CD_CEP,
			   Destino.NR_ENDERECO = Origem.NR_ENDERECO,
	           Destino.CD_UF = Origem.CD_UF,
	           Destino.DN_UF = Origem.DN_UF,
	           Destino.TP_SITUACAO_SGE  = Origem.TP_SITUACAO_SGE,
	           Destino.VL_LIMITE_CRED = Origem.VL_LIMITE_CRED,
			   Destino.DT_IMPLANTACAO = Origem.DT_IMPLANTACAO,
			   Destino.CD_CNAE = Origem.CD_CNAE,
	           Destino.DT_SINC  = Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_CLIENTE, CD_CGCCPF, DN_FANTASIA, CD_MUNICIPIO, DN_MUNICIPIO, DN_BAIRRO, CD_CEP, NR_ENDERECO, CD_UF, DN_UF, TP_SITUACAO_SGE, VL_LIMITE_CRED, DT_IMPLANTACAO,CD_CNAE, DT_SINC)

    VALUES (Origem.CD_CLIENTE, Origem.CD_CGCCPF, Origem.DN_FANTASIA, Origem.CD_MUNICIPIO, Origem.DN_MUNICIPIO, Origem.DN_BAIRRO, Origem.CD_CEP, Origem.NR_ENDERECO, Origem.CD_UF, Origem.DN_UF, Origem.TP_SITUACAO_SGE, Origem.VL_LIMITE_CRED, Origem.DT_IMPLANTACAO, Origem.CD_CNAE, Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;
RETURN 0
GO
PRINT N'Update complete.';


GO
