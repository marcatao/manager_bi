﻿CREATE TABLE [dbo].[DIM_DIVISOES]
(
	[CD_DIVISAO] CHAR NOT NULL PRIMARY KEY, 
    [DN_DIVISAO] NVARCHAR(50) NULL, 
    [ICON] CHAR(15) NULL,
	[DT_SINC] DATETIME NULL
    
)
