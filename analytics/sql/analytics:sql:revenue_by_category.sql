-- =========================================================
-- Business relevance:
--   Highlights which product categories drive the most revenue and margin.
--   Useful for:
--     - Deciding where Sales and Marketing should focus efforts
--     - Identifying categories with strong revenue but weak margin or low repeat rates
--     - Supporting strategy on promotions, cross-sell, and bundling
-- =========================================================

-- ---------- PARAMS (edit the default to explore another top category) ----------
DECLARE top_cat STRING DEFAULT 'Bébé & Enfant';

-- ---------- 1) Topline KPIs ----------
SELECT
  COUNT(DISTINCT orders_id)             AS nb_orders,
  COUNT(DISTINCT products_id)           AS nb_products_id,
  COUNT(DISTINCT customers_id)          AS nb_customers_id,
  SUM(turnover)                         AS ttl_turnover,
  SUM(purchase_cost)                    AS ttl_purchase_cost,
  SUM(qty)                              AS ttl_qty,
  ROUND(SAFE_DIVIDE(SUM(turnover) - SUM(purchase_cost), SUM(turnover)) * 100, 2)
                                        AS gross_margin_pct
FROM `<project>.<dataset>.gwz_sales`;

-- ---------- 2) Category_1 performance (rank by revenue & show margin) ----------
SELECT
  category_1,
  COUNT(DISTINCT orders_id)                       AS nb_orders,
  COUNT(DISTINCT products_id)                     AS nb_products_id,
  COUNT(DISTINCT customers_id)                    AS nb_customers_id,
  SUM(turnover)                                   AS ttl_turnover,
  SUM(purchase_cost)                              AS ttl_purchase_cost,
  SUM(qty)                                        AS ttl_qty,
  ROUND(SAFE_DIVIDE(SUM(turnover) - SUM(purchase_cost), SUM(turnover)) * 100, 2)
                                                  AS gross_margin_pct
FROM `<project>.<dataset>.gwz_sales`
GROUP BY category_1
ORDER BY ttl_turnover DESC;

-- ---------- 3) Deep-dive into the chosen Category_1 ----------
-- 3a) Revenue by Category_2/3 (drivers)
SELECT
  category_2,
  category_3,
  SUM(turnover)                      AS ttl_turnover,
  ROUND(SAFE_DIVIDE(SUM(turnover) - SUM(purchase_cost), SUM(turnover)) * 100, 2)
                                     AS gross_margin_pct
FROM `<project>.<dataset>.gwz_sales`
WHERE category_1 = top_cat
GROUP BY category_2, category_3
ORDER BY ttl_turnover DESC;

-- 3b) One-time vs repeat signal: orders per customer
SELECT
  category_2,
  category_3,
  COUNT(DISTINCT orders_id)    AS nb_orders,
  COUNT(DISTINCT customers_id) AS nb_customers_id,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT orders_id),
                    COUNT(DISTINCT customers_id)), 2) AS orders_per_customer
FROM `<project>.<dataset>.gwz_sales`
WHERE category_1 = top_cat
GROUP BY category_2, category_3
ORDER BY orders_per_customer DESC;

-- 3c) Product breadth & pricing (avg selling price)
SELECT
  category_2,
  category_3,
  COUNT(DISTINCT products_id)                    AS nb_distinct_products,
  ROUND(SAFE_DIVIDE(SUM(turnover), SUM(qty)), 2) AS avg_selling_price,
  ROUND(AVG(purchase_cost), 2)                   AS avg_purchase_cost
FROM `<project>.<dataset>.gwz_sales`
WHERE category_1 = top_cat
GROUP BY category_2, category_3
ORDER BY avg_selling_price DESC;
