﻿CREATE TABLE [dbo].[DIM_FILIAL]
(
	[CD_FILIAL] SMALLINT NOT NULL PRIMARY KEY, 
    [DN_FANTASIA] CHAR(20) NULL, 
    [DN_RAZAO] CHAR(40) NULL, 
    [CD_CGCCPF] CHAR(18) NULL, 
    [DT_SINC] DATETIME NULL
)