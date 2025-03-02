CREATE TABLE kimia_farma.kf_analisa_kimia_farma AS

WITH kf_final_transaction_laba AS
(
  SELECT *,
    CASE
      WHEN nett_sales <= 50000 THEN 0.1
      WHEN nett_sales > 50000 AND nett_sales <= 100000 THEN 0.15
      WHEN nett_sales > 100000 AND nett_sales <= 300000 THEN 0.2
      WHEN nett_sales > 300000 AND nett_sales <= 500000 THEN 0.25
      ELSE 0.3
    END AS persentase_gross_laba
  FROM
  (
    SELECT *,
      CAST(ROUND(price * (1 - discount_percentage/100)) AS INT64) AS nett_sales
    FROM
      `kimia_farma.kf_final_transaction`
  )
)

SELECT
  t0.transaction_id,
  t0.date,
  t1.branch_id,
  t1.branch_name,
  t1.kota,
  t1.provinsi,
  t1.rating AS rating_cabang,
  t0.customer_name,
  t2.product_id,
  t2.product_name,
  t2.price AS actual_price,
  t0.discount_percentage,
  t0.persentase_gross_laba,
  t0.nett_sales,
  CAST(ROUND(t0.nett_sales * t0.persentase_gross_laba) AS INT64) AS nett_profit,
  t0.rating AS rating_transaksi,
FROM
  kf_final_transaction_laba AS t0
LEFT JOIN
  `kimia_farma.kf_kantor_cabang` AS t1
ON
  t0.branch_id = t1.branch_id
LEFT JOIN
  `kimia_farma.kf_product` AS t2
ON
  t0.product_id = t2.product_id
ORDER BY
  t0.date ASC
