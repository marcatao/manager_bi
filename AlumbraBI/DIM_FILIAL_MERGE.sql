﻿CREATE PROCEDURE [dbo].[DIM_FILIAL_MERGE]
	
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