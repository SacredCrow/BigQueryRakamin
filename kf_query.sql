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
  CASE
    WHEN t2.price <= 50000 THEN 0.1
    WHEN t2.price > 50000
  AND t2.price <= 100000 THEN 0.15
    WHEN t2.price > 100000 AND t2.price <= 300000 THEN 0.2
    WHEN t2.price > 300000
  AND t2.price <= 500000 THEN 0.25
    ELSE 0.3
END
  AS persentase_gross_laba,
  t2.price * t0.discount_percentage AS nett_sales,
  t2.price * t0.discount_percentage *
  CASE
    WHEN t2.price <= 50000 THEN 0.1
    WHEN t2.price > 50000
  AND t2.price <= 100000 THEN 0.15
    WHEN t2.price > 100000 AND t2.price <= 300000 THEN 0.2
    WHEN t2.price > 300000
  AND t2.price <= 500000 THEN 0.25
    ELSE 0.3
END
  AS nett_profit,
  t0.rating AS rating_transaksi
FROM
  `kf_final_transaction.kf_final_transaction` AS t0
INNER JOIN
  `kf_kantor_cabang.kf_kantor_cabang` AS t1
ON
  t0.branch_id = t1.branch_id
INNER JOIN
  `kf_product.kf_product` AS t2
ON
  t0.product_id = t2.product_id
