CREATE PROCEDURE [dbo].[DIM_LINHAS_SGE_MERGE]

AS
	MERGE [Auxiliar].[dbo].[DIM_LINHAS_SGE] AS Destino

USING 

(
select CD_GRUPO, CD_SUBGRUPO, DN_GRUPO,
 case CD_SUBGRUPO when '0' then 'O'
				  when '1' then 'E'
                  when '2' then 'E'
                  when '3' then 'E'
                  when '4' then 'E'
                  when '5' then 'E'
                  when '6' then 'E'
                  when '7' then 'E'
                  when '8' then 'E'
                  when '9' then 'E'
                  when '10' then 'E'
                  when '11' then 'E'
                  when '12' then 'E'
                  when '13' then 'X'
                  when '17' then 'E'
                  when '18' then 'E'
                  when '19' then 'E'
                  when '20' then 'E'
                  when '14' then 'E'
                  when '15' then 'E'
                  when '16' then 'E'
                  when '22' then 'I'
                  when '23' then 'I'
                  when '24' then 'I'
                  when '25' then 'I'
                  when '29' then 'E'
                  when '26' then 'E'
                  when '31' then 'E'
                  when '32' then 'I'
                  when '35' then 'I'
                  when '39' then 'I'
                  when '40' then 'E'
                  when '30' then 'E'
                  when '42' then 'I'
                  when '43' then 'I'
                  when '44' then 'I'
                  when '45' then 'E'
                  when '33' then 'E'
                  when '47' then 'E'
                  when '48' then 'I'
                  when '49' then 'E'
                  when '34' then 'E'
                  when '52' then 'E'
                  when '54' then 'E'
                  when '55' then 'E'
                  when '56' then 'E'
                  when '27' then 'E'
                  when '28' then 'E'
                  when '59' then 'I'
                  when '60' then 'A'
                  when '61' then 'E'
                  when '62' then 'O'
                  when '63' then 'E'
                  when '36' then 'E'
                  when '37' then 'E'
                  when '66' then 'E'
 else 'O'
 end
as CD_DIVISAO, CURRENT_TIMESTAMP as DT_SINC
from [fiscal].[dbo].GE005 where TP_APLICACAO='C' and CD_GRUPO=6

)
AS Origem

--Condição: O produto existe nas 2 tabelas e o cliente também

ON (Destino.CD_GRUPO = Origem.CD_GRUPO AND Destino.CD_SUBGRUPO = Origem.CD_SUBGRUPO)

--Se a condição for obedecida, ou seja, existem registros nas duas tabelas

WHEN MATCHED THEN

    UPDATE SET Destino.DN_GRUPO = Origem.DN_GRUPO,
			   Destino.CD_DIVISAO = Origem.CD_DIVISAO,
			   Destino.DT_SINC = Origem.DT_SINC

--Se a condição não foi obedecida porque o registro não existe na tabela de destino

WHEN NOT MATCHED BY TARGET THEN

    INSERT (CD_GRUPO,CD_SUBGRUPO,DN_GRUPO,CD_DIVISAO,DT_SINC)

    VALUES (Origem.CD_GRUPO, Origem.CD_SUBGRUPO,Origem.DN_GRUPO,Origem.CD_DIVISAO,Origem.DT_SINC)

OUTPUT $action, Inserted.*, Deleted.*;

RETURN 0
