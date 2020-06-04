﻿CREATE TABLE [dbo].[DIM_PRODUTOS]
(
	[CD_FILIAL] INT NOT NULL , 
    [CD_ITEM] CHAR(16) NOT NULL, 
    [DN_ITEM_COM] CHAR(50) NULL, 
    [DN_ITEM_IND] CHAR(50) NULL, 
    [CD_CLASSE_ABC] CHAR NULL, 
    [CD_CLASSIF] NUMERIC(10) NULL, 
    [CD_GRUPO] SMALLINT NULL, 
    [CD_SUBGRUPO] SMALLINT NULL,
	[CD_LINHA] CHAR(6) NULL, 
    [VL_CUSTO_INDUST] NUMERIC(12, 4) NULL, 
    [TP_OBSOLETO_IND] CHAR NULL, 
    [TP_OBSOLETO_COM] CHAR NULL, 
	[CD_ORIG_MERCAD] SMALLINT NULL, 
    [DT_SINC] DATETIME NULL,     
    CONSTRAINT [PK_DIM_PRODUTOS] PRIMARY KEY ([CD_ITEM]), 
    CONSTRAINT [FK_DIM_PRODUTOS_DIM_LINHAS_SGE] FOREIGN KEY ([CD_GRUPO],[CD_SUBGRUPO]) REFERENCES [DIM_LINHAS_SGE]([CD_GRUPO],[CD_SUBGRUPO]) 
)
