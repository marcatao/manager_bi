﻿CREATE TABLE [dbo].[FATO_001]
(
	[Cod_Dia] NVARCHAR(50) NOT NULL , 
    [CD_FILIAL] SMALLINT NOT NULL, 
    [CD_CLIENTE] INT NOT NULL, 
    [CD_REPRES] INT NOT NULL, 
    [CD_REGIAO] CHAR(6) NOT NULL,
	[CD_ITEM] CHAR(16) NOT NULL, 
    [QT_FATURADA] NUMERIC(12, 4) NULL, 
    [VL_FATURADA] NUMERIC(16, 2) NULL, 
	[CD_GRUPO] SMALLINT NOT NULL, 
    [CD_SUBGRUPO] SMALLINT NOT NULL, 
    [CD_LINHA] CHAR(6) NOT NULL, 
    [CD_LINHA_COTA] INT NOT NULL, 
    [CD_DIVISAO] CHAR NOT NULL, 
	[CD_DIVISAO_LINHAS] CHAR NULL,
    [DT_SINC] DATETIME NULL, 
    CONSTRAINT [FK_FATO_001_DIM_DIVISOES] FOREIGN KEY ([CD_DIVISAO]) REFERENCES [DIM_DIVISOES]([CD_DIVISAO]), 
    CONSTRAINT [FK_FATO_001_DIM_LINHAS_AGRUPADAS] FOREIGN KEY ([CD_LINHA_COTA]) REFERENCES [DIM_LINHAS_AGRUPADAS]([CD_LINHA_COTA]), 
    CONSTRAINT [FK_FATO_001_DIM_CLIENTE] FOREIGN KEY ([CD_CLIENTE]) REFERENCES [DIM_CLIENTE]([CD_CLIENTE]), 
    CONSTRAINT [PK_FATO_001] PRIMARY KEY ([Cod_Dia],[CD_FILIAL],[CD_CLIENTE],[CD_REPRES],[CD_REGIAO],[CD_ITEM],[CD_GRUPO],[CD_SUBGRUPO],[CD_LINHA],[CD_LINHA_COTA],[CD_DIVISAO]), 
    CONSTRAINT [FK_FATO_001_DIM_TEMPO] FOREIGN KEY ([Cod_Dia]) REFERENCES [DIM_TEMPO]([Cod_Dia]), 
    CONSTRAINT [FK_FATO_001_DIM_FILIAL] FOREIGN KEY ([CD_FILIAL]) REFERENCES [DIM_FILIAL]([CD_FILIAL]), 
    CONSTRAINT [FK_FATO_001_DIM_LINHAS_SGE] FOREIGN KEY ([CD_GRUPO],[CD_SUBGRUPO]) REFERENCES [DIM_LINHAS_SGE]([CD_GRUPO],[CD_SUBGRUPO]), 
    CONSTRAINT [FK_FATO_001_DIM_REPRESENTANTE] FOREIGN KEY ([CD_REPRES]) REFERENCES [DIM_REPRESENTANTE]([CD_REPRES])
)
