-- =========================================================
-- Business relevance:
--   Identifies which products or deals are profitable vs. low-margin.
--   Sales Ops can use this to:
--     - Guide reps toward high-margin opportunities
--     - Spot areas where discounts are eroding profitability
--     - Decide when low-margin products should be bundled or de-prioritized
-- =========================================================

WITH margin_metrics AS (
  SELECT 
    orders_id,
    products_id,
    ROUND(SUM(turnover), 2) AS turnover,
    ROUND(SUM(turnover) - SUM(purchase_cost), 2) AS margin,
    ROUND(SAFE_DIVIDE(SUM(turnover) - SUM(purchase_cost), SUM(turnover)) * 100, 2)
      AS margin_percent
  FROM `project.dataset.gwz_sales_17`
  GROUP BY orders_id, products_id
)

-- Segment deals/products by margin percent
SELECT
  orders_id,
  products_id,
  margin_metrics.turnover,
  margin_metrics.margin,
  margin_metrics.margin_percent,
  CASE
    WHEN margin_metrics.margin_percent >= 40 THEN 'High'
    WHEN margin_metrics.margin_percent <= 5 THEN 'Low'
    WHEN margin_metrics.margin_percent >= 5 AND margin_metrics.margin_percent < 40 THEN 'Medium'
    ELSE 'Unknown'
  END AS margin_level
FROM margin_metrics
ORDER BY orders_id;
-- =========================================================
