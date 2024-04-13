-- QUERY PARA IDENTIFICAR DEVEDORES/CREDORES

SELECT TV.MES_ANO,
       TC.CPF,
       TC.NOME,
       TC.VOLUME_DE_COMPRA AS LIMITE_CREDITO,
       TV.QUANTIDADE_TOTAL,
       TC.VOLUME_DE_COMPRA - TV.QUANTIDADE_TOTAL AS VALOR_SALDO,
       (CASE
            WHEN TC.VOLUME_DE_COMPRA >= TV.QUANTIDADE_TOTAL THEN 'SALDO CREDOR'
            ELSE 'SALDO DEVEDOR'
        END) AS TIPO_SALDO
FROM TABELA_DE_CLIENTES TC
INNER JOIN
  (SELECT NF.CPF,
          TO_CHAR(NF.DATA_VENDA, 'MM-YYYY') AS MES_ANO,
          SUM(INF.QUANTIDADE) AS QUANTIDADE_TOTAL
   FROM NOTAS_FISCAIS NF
   INNER JOIN ITENS_NOTAS_FISCAIS INF ON NF.NUMERO = INF.NUMERO
   GROUP BY CPF,
            TO_CHAR(NF.DATA_VENDA, 'MM-YYYY')) TV ON TV.CPF = TC.CPF;