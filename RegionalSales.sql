SELECT *
FROM (
    SELECT NVL(saleArea, 'NULL') AS SALEAREA
        , DECODE(DB, 'GSN', 'RMB', 'GS', 'USD') AS currency
        , SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(SYSDATE, 'Q') AND TRUNC(SYSDATE) THEN amountTax
        END) AS thisquater, SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'Q') AND TRUNC(ADD_MONTHS(SYSDATE, -12)) THEN amountTax
        END) AS sameperiod
        , ROUND((SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(SYSDATE, 'Q') AND TRUNC(SYSDATE) THEN amountTax
        END) / DECODE(SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'Q') AND TRUNC(ADD_MONTHS(SYSDATE, -12)) THEN amountTax
        END), 0, 1, SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'Q') AND TRUNC(ADD_MONTHS(SYSDATE, -12)) THEN amountTax
        END)) - 1) * 100, 2) AS rate
        , SUM(CASE 
            WHEN shipdate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -3) AND TRUNC(SYSDATE, 'q') - 1 THEN amountTax
        END) AS lastquarter, SUM(CASE 
            WHEN shipdate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -6) AND ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -3) - 1 THEN amountTax
        END) AS last2quarter
        , SUM(CASE 
            WHEN shipdate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -9) AND ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -6) - 1 THEN amountTax
        END) AS last3quarter
    FROM (
        SELECT DECODE(saleArea, '1', 'APAC', '2', 'EMEA', '3', 'LATAM', '4', 'NA', '5', 'None-Regional-ITSP', '6', 'UNDEFINE', DECODE(db, 'GS', 'UNDEFINE', 'GSN')) AS saleArea
            , db, shipdate
            , DECODE(DB, 'GS', DECODE(currency, 'RMB', amountTax * EXCHANGErate, amountTax), 'GSN', DECODE(currency, 'USD', amountTax * EXCHANGErate, amountTax)) AS amountTax
        FROM goa.v_salesreport
        WHERE modeltype = 'GOODS'
            AND SALEAREA IN ('1', '2', '3', '4')
    ) a
    GROUP BY NVL(SALEAREA, 'NULL'), DB
)
WHERE (thisquater > 0
        OR sameperiod > 0
        OR lastquarter > 0
        OR last2quarter > 0
        OR last3quarter > 0)
    AND SALEAREA != 'GSN'
UNION ALL
SELECT ' ', ' ', NULL, NULL, NULL
    , NULL, NULL, NULL
FROM DUAL
UNION ALL
SELECT *
FROM (
    SELECT NVL(saleArea, 'NULL') AS SALEAREA
        , DECODE(DB, 'GSN', 'RMB', 'GS', 'USD') AS currency
        , SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(SYSDATE, 'Q') AND TRUNC(SYSDATE) THEN amountTax
        END) AS thisquater, SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'Q') AND TRUNC(ADD_MONTHS(SYSDATE, -12)) THEN amountTax
        END) AS sameperiod
        , ROUND((SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(SYSDATE, 'Q') AND TRUNC(SYSDATE) THEN amountTax
        END) / DECODE(SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'Q') AND TRUNC(ADD_MONTHS(SYSDATE, -12)) THEN amountTax
        END), 0, 1, SUM(CASE 
            WHEN shipdate BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'Q') AND TRUNC(ADD_MONTHS(SYSDATE, -12)) THEN amountTax
        END)) - 1) * 100, 2) AS rate
        , SUM(CASE 
            WHEN shipdate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -3) AND TRUNC(SYSDATE, 'q') - 1 THEN amountTax
        END) AS lastquarter, SUM(CASE 
            WHEN shipdate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -6) AND ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -3) - 1 THEN amountTax
        END) AS last2quarter
        , SUM(CASE 
            WHEN shipdate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -9) AND ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -6) - 1 THEN amountTax
        END) AS last3quarter
    FROM (
        SELECT DECODE(saleArea, '1', 'APAC', '2', 'EMEA', '3', 'LATAM', '4', 'NA', '5', 'None-Regional-ITSP', '6', 'UNDEFINE', DECODE(db, 'GS', 'UNDEFINE', 'GSN')) AS saleArea
            , db, shipdate
            , DECODE(DB, 'GS', DECODE(currency, 'RMB', amountTax * EXCHANGErate, amountTax), 'GSN', DECODE(currency, 'USD', amountTax * EXCHANGErate, amountTax)) AS amountTax
        FROM goa.v_salesreport
        WHERE modeltype = 'GOODS'
            AND SALEAREA NOT IN ('1', '2', '3', '4')
    ) a
    GROUP BY NVL(SALEAREA, 'NULL'), DB
)
WHERE (thisquater > 0
        OR sameperiod > 0
        OR lastquarter > 0
        OR last2quarter > 0
        OR last3quarter > 0)
    AND SALEAREA != 'GSN'