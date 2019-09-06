DROP VIEW GOA.V_SALESREPORT;

/* Formatted on 2019/9/2 18:11:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GOA.V_SALESREPORT
(
   DB,
   ORDERTYPE,
   SALESORDER,
   SHIPAREA,
   DELIVERYAREA,
   MODEL,
   PRICETAX,
   DELIVERYORDER,
   SHIPDATE,
   CUSTOMER,
   CUSTOMERNAME,
   TAXRATE,
   PN,
   PSU,
   PSUMODEL,
   QUANTITY,
   CURRENCY,
   EXCHANGERATE,
   WAREHOUSE,
   WNAME,
   WARRANTY,
   MODELTYPE,
   AMOUNTTAX,
   SALEAREA
)
AS
   SELECT   'GS' AS "db",
            --DB(gs&gs),
            oea00 AS "type",                                           --类型,
            oga16 AS "order",                                        --订单号,
            oeaud07 AS "shipArea",                                 --出货区域,
            oga26 AS "deliveryArea",                               --收货区域,
            ogbud02 AS "model",                                        --型号,
            oeb13 AS "priceTax",                                   --含税单价,
            oga01 AS "deliveryOrder",                              --出货单号,
            oga02 AS "shipDate",                                   --出货日期,
            oga03 AS "customer",                                   --客户编号,
            oga032 AS "customerName",                              --客户简称,
            oga211 AS "TaxRate",                                       --税率,
            ogb04 AS "PN",                                             --料号,
            ogb092 AS "PSU",                                       --电源料号,
            ogbud04 AS "PSUModel",                                 --电源型号,
            TRUNC (ogb12) AS "quantity",                           --出货数量,
            oea23 AS "currency",                                       --币种,
            oga24 AS "exchangeRate",                                  -- 汇率,
            ogb09 AS "warehouse",                                  --出货仓库,
            imd02 AS "wName",                                      --仓库简称,
            oebud06 AS "warranty",                                   --保修期,
            CASE
               WHEN     b.ima105 = 'Y'
                    AND b.ima03 IS NOT NULL
                    AND b.ima01 LIKE '96%'
               THEN
                  'GOODS'
               WHEN b.ima105 <> 'Y' AND b.ima03 IS NOT NULL
               THEN
                  'PSU'
               WHEN b.ima03 IS NULL
               THEN
                  'OTHER'
            END
               AS MODELTYPE,                                        --产品类别
            ogb14t AS "amountTax",                                  --含税金额
            occud07 AS "saleArea"                         --销售客户区域190618
     FROM         gs.oga_file
               LEFT JOIN
                  gs.oea_file
               ON oea01 = oga16
            LEFT JOIN
               gs.occ_file
            ON oga03 = occ01,          gs.ogb_file
                                    LEFT JOIN
                                       gs.oeb_file
                                    ON ogb31 = oeb01 AND ogb32 = oeb03
                                 LEFT JOIN
                                    gs.ima_file b
                                 ON ogb04 = ima01
                              LEFT JOIN
                                 gs.imd_file
                              ON ogb09 = imd01
    WHERE       ogb01 = oga01
            AND oga03 <> 'GSN03001'                                        --?
            AND ogapost = 'Y'                                         --已过账
            AND oga02 > TO_DATE ('2012/12/31', 'yyyy/mm/dd') --数据从12以后开始
            AND oga00 = '1'                                --出货别 1.正常出货
            AND oga09 = '2'
   UNION ALL
   SELECT   'GSN' AS "db",                                       --DB(gs&gsn),
            oea00 AS "type",                                           --类型,
            oga16 AS "order",                                        --订单号,
            oeaud07 AS "shipArea",                                 --出货区域,
            oga26 AS "deliveryArea",                               --收货区域,
            ogbud02 AS "model",                                        --型号,
            oeb13 AS "priceTax",                                   --含税单价,
            oga01 AS "deliveryOrder",                              --出货单号,
            oga02 AS "shipDate",                                   --出货日期,
            oga03 AS "customer",                                   --客户编号,
            oga032 AS "customerName",                              --客户简称,
            oga211 AS "TaxRate",                                       --税率,
            ogb04 AS "PN",                                             --料号,
            ogb092 AS "PSU",                                       --电源料号,
            ogbud04 AS "PSUModel",                                 --电源型号,
            TRUNC (ogb12) AS "quantity",                           --出货数量,
            oea23 AS "currency",                                       --币种,
            oga24 AS "exchangeRate",                                  -- 汇率,
            ogb09 AS "warehouse",                                  --出货仓库,
            imd02 AS "wName",                                      --仓库简称,
            oebud06 AS "warranty",                                   --保修期,
            CASE
               WHEN     b.ima105 = 'Y'
                    AND b.ima03 IS NOT NULL
                    AND b.ima01 LIKE '96%'
               THEN
                  'GOODS'
               WHEN b.ima105 <> 'Y' AND b.ima03 IS NOT NULL
               THEN
                  'PSU'
               WHEN b.ima03 IS NULL
               THEN
                  'OTHER'
            END
               AS MODELTYPE,                                        --产品类别
            ogb14t AS "amountTax",                                  --含税金额
            occud07 AS "saleArea"                         --销售客户区域190618
     FROM         gsn.oga_file
               LEFT JOIN
                  gsn.oea_file
               ON oea01 = oga16
            LEFT JOIN
               gsn.occ_file
            ON oga03 = occ01,          gsn.ogb_file
                                    LEFT JOIN
                                       gsn.oeb_file
                                    ON ogb31 = oeb01 AND ogb32 = oeb03
                                 LEFT JOIN
                                    gsn.ima_file b
                                 ON ogb04 = ima01
                              LEFT JOIN
                                 gsn.imd_file
                              ON ogb09 = imd01
    WHERE       ogb01 = oga01
            AND oga03 <> 'GSN03001'                                        --?
            AND ogapost = 'Y'                                         --已过账
            AND oga02 > TO_DATE ('2012/12/31', 'yyyy/mm/dd') --数据从12以后开始
            AND oga00 = '1'                                --出货别 1.正常出货
            AND oga09 = '2'
            AND SUBSTR (oga16, 1, 4) <> 'NF10';


GRANT SELECT ON GOA.V_SALESREPORT TO PUBLIC;
