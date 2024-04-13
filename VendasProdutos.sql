/*
Ranking das vendas de produtos por sabor, dentro de um ano espec�fico;
Coluna de percentual de distribui��o de cada sabor em rela��o �s vendas totais
*/
SELECT QUERY_REL.SABOR,
       QUERY_REL.ANO,
       QUERY_REL.QTD_TOTAL,
       QUERY_REL.QTD_GERAL,
       ROUND((QUERY_REL.QTD_TOTAL / QUERY_REL.QTD_GERAL), 3) * 100 AS PERCENT_PARTICIPACAO
FROM
  (SELECT TP.SABOR, --, nf.data_venda
 EXTRACT(YEAR
         FROM NF.DATA_VENDA) AS ANO,
 SUM(INF.QUANTIDADE) AS QTD_TOTAL,

     (SELECT TOTAL_ANO.QTD_TOTAL
      FROM
        (SELECT EXTRACT(YEAR
                        FROM NF.DATA_VENDA) AS ANO,
                SUM(INF.QUANTIDADE) AS QTD_TOTAL
         FROM NOTAS_FISCAIS NF
         INNER JOIN ITENS_NOTAS_FISCAIS INF ON NF.NUMERO = INF.NUMERO
         WHERE EXTRACT(YEAR
                       FROM NF.DATA_VENDA) = 2016
         GROUP BY EXTRACT(YEAR
                          FROM NF.DATA_VENDA)) TOTAL_ANO) AS QTD_GERAL
   FROM TABELA_DE_PRODUTOS TP
   INNER JOIN ITENS_NOTAS_FISCAIS INF ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
   INNER JOIN NOTAS_FISCAIS NF ON INF.NUMERO = NF.NUMERO
   WHERE EXTRACT(YEAR
                 FROM NF.DATA_VENDA) = 2016
   GROUP BY TP.SABOR,
            EXTRACT(YEAR
                    FROM NF.DATA_VENDA)
   ORDER BY SUM(INF.QUANTIDADE) DESC) QUERY_REL;