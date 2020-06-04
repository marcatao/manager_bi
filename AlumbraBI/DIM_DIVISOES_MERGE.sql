CREATE PROCEDURE [dbo].[DIM_DIVISOES_MERGE]
	
AS
	
MERGE [dbo].[DIM_DIVISOES] AS Destino

USING 
(select 'X' as CD_DIVISAO,'Exportação' as DN_DIVISAO,'pe-7s-way' as ICON, CURRENT_TIMESTAMP as DT_SINC
union
select 'I' as CD_DIVISAO,'Iluminação' as DN_DIVISAO,'pe-7s-light' as ICON, CURRENT_TIMESTAMP as DT_SINC 
union
select 'E' as CD_DIVISAO,'Material Elétrico' as DN_DIVISAO,'pe-7s-plug' as ICON, CURRENT_TIMESTAMP as DT_SINC 
union 
select 'T' as CD_DIVISAO,'Televendas' as DN_DIVISAO,'pe-7s-call' as ICON, CURRENT_TIMESTAMP as DT_SINC  
union
select 'O' as CD_DIVISAO,'Outros' as DN_DIVISAO,'pe-7s-help1' as icon, CURRENT_TIMESTAMP as DT_SINC  
union
select 'A' as CD_DIVISAO,'ABB' as DN_DIVISAO,'pe-7s-share' as ICON, CURRENT_TIMESTAMP as DT_SINC  
union
select 'M' as CD_DIVISAO,'Mercado' as DN_DIVISAO,'pe-7s-cart' as ICON, CURRENT_TIMESTAMP as DT_SINC 
union 
select 'F' as CD_DIVISAO,'Funcionários' as DN_DIVISAO,'pe-7s-users' as ICON, CURRENT_TIMESTAMP as DT_SINC 
union 
select 'C' as CD_DIVISAO,'Construção Civil' as DN_DIVISAO,'pe-7s-culture' as ICON, CURRENT_TIMESTAMP as DT_SINC
union 
select 'W' as CD_DIVISAO,'Vendas OnLine' as DN_DIVISAO,'pe-7s-global' as ICON, CURRENT_TIMESTAMP as DT_SINC
union 
select 'D' as CD_DIVISAO,'Venda direta' as DN_DIVISAO,'pe-7s-pin' as ICON, CURRENT_TIMESTAMP as DT_SINC)

AS Origem
--Condição: O produto existe nas 2 tabelas e o cliente também
 ON (Destino.CD_DIVISAO = Origem.CD_DIVISAO)

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas
WHEN MATCHED THEN
    UPDATE SET Destino.CD_DIVISAO = Origem.CD_DIVISAO,
			   Destino.DN_DIVISAO = Origem.DN_DIVISAO,
			   Destino.ICON = Origem.ICON,
			   Destino.DT_SINC = Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CD_DIVISAO, DN_DIVISAO, DT_SINC)
    VALUES (Origem.CD_DIVISAO, Origem.DN_DIVISAO,Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;
										

RETURN 0
