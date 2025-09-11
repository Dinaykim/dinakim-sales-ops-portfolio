-- Pipeline Stage Distribution
-- Business relevance:
--   Helps assess pipeline health by showing stage distribution.
--   Useful for:
--     - Spotting bottlenecks (too many stuck in Opportunity, etc.)
--     - Validating conversion ratios across stages
--     - Revealing CRM data hygiene issues (e.g., inconsistent stage naming like "1-Lead")
--   Clean, standardized stages are critical for accurate reporting and forecasting.

SELECT
  priority,
  COUNTIF(deal_stage = '1-Lead')       AS Lead,
  COUNTIF(deal_stage = '2-Opportunity') AS Opportunity,
  COUNTIF(deal_stage = '3-Customer')    AS Customer,
  COUNTIF(deal_stage = '4-Lost')        AS Lost
FROM `tensile-imprint-450311-c3.course15.cc_funnel_deal_stage`
GROUP BY priority
ORDER BY priority;