-- Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
SELECT
  FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
  COUNT(DISTINCT fullVisitorId) AS visits,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.transactions) AS transactions
FROM`bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331' 
GROUP BY month
ORDER BY month;


-- Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
WITH source_s AS (
  SELECT
    trafficSource.source AS source,
    COUNT(fullVisitorId) AS total_visits,
    SUM(CASE WHEN totals.bounces = 1 THEN 1 ELSE 0 END) AS total_no_of_bounces
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
  GROUP BY source
)

SELECT
  source,
  total_visits,
  total_no_of_bounces,
  ROUND(SAFE_DIVIDE(total_no_of_bounces, total_visits) * 100, 2) AS bounce_rate
FROM source_s
ORDER BY total_visits DESC;


SELECT
    trafficSource.source as source,
    sum(totals.visits) as total_visits,
    sum(totals.Bounces) as total_no_of_bounces,
    (sum(totals.Bounces)/sum(totals.visits))* 100.00 as bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY source
ORDER BY total_visits DESC;


-- Query 3: Revenue by traffic source by week, by month in June 2017
WITH monthly_revenue AS (
  SELECT
    'Month' AS time_type,
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date)) AS time,
    trafficSource.source AS source,
    SAFE_DIVIDE(SUM(product.productRevenue), 1000000) AS revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE product.productRevenue IS NOT NULL
  GROUP BY source, time
),

weekly_revenue AS (
  SELECT
    'Week' AS time_type,
    FORMAT_DATE('%Y-%W', PARSE_DATE('%Y%m%d', date)) AS time,
    trafficSource.source AS source,
    SAFE_DIVIDE(SUM(product.productRevenue), 1000000) AS revenue
  FROM`bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE product.productRevenue IS NOT NULL
  GROUP BY source, time
)
SELECT * FROM monthly_revenue
UNION ALL
SELECT * FROM weekly_revenue
ORDER BY time_type, time, revenue DESC;


-- QUERY 4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
WITH sessions AS (
  SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date)) AS month,
    fullVisitorId,
    totals.pageviews AS pageviews,
    totals.transactions AS transactions,
    EXISTS (
      SELECT 1
      FROM UNNEST(hits) AS h,
        UNNEST(h.product) AS p
      WHERE p.productRevenue IS NOT NULL
    ) AS has_revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
  WHERE _TABLE_SUFFIX BETWEEN '0601' AND '0731'
    AND totals.pageviews IS NOT NULL
),

purchaser_data AS (
  SELECT
    month,
    SUM(pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_purchase
  FROM sessions
  WHERE transactions >= 1
    AND has_revenue
  GROUP BY month
),

non_purchaser_data AS (
  SELECT
    month,
    SUM(pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_non_purchase
  FROM sessions
  WHERE transactions IS NULL
    AND NOT has_revenue
  GROUP BY month
)

SELECT
  COALESCE(p.month, n.month) AS month,
  p.avg_pageviews_purchase,
  n.avg_pageviews_non_purchase
FROM purchaser_data p
FULL JOIN non_purchaser_data n
ON p.month = n.month
ORDER BY month;
-- Query 05: Average number of transactions per user that made a purchase in July 2017
WITH purchasers AS (
  SELECT
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
    fullVisitorId,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE _TABLE_SUFFIX BETWEEN '0701' AND '0731'
    AND totals.transactions IS NOT NULL
    AND product.productRevenue IS NOT NULL
)

SELECT
  month,
  ROUND(SAFE_DIVIDE(SUM(transactions), COUNT(DISTINCT fullVisitorId)), 2) AS avg_total_transactions_per_user
FROM purchasers
GROUP BY month;

-->
select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    sum(totals.transactions)/count(distinct fullvisitorid) as Avg_total_transactions_per_user
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    ,unnest (hits) hits,
    unnest(product) product
where  totals.transactions>=1
and product.productRevenue is not null
group by month;


-- Query 06: Average amount of money spent per session. Only include purchaser data in July 2017
WITH sessions AS (
  SELECT
    PARSE_DATE('%Y%m%d', date) AS session_date,
    totals.visits AS visits,
    product.productRevenue AS productRevenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE totals.transactions IS NOT NULL
    AND product.productRevenue IS NOT NULL
)

SELECT
  FORMAT_DATE('%Y%m', session_date) AS month,
  ROUND(SAFE_DIVIDE(SUM(productRevenue) / 1000000, SUM(visits)), 2) AS avg_revenue_by_user_per_visit
FROM sessions
GROUP BY month
ORDER BY month;

select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    ((sum(product.productRevenue)/sum(totals.visits))/power(10,6)) as avg_revenue_by_user_per_visit
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
  ,unnest(hits) hits
  ,unnest(product) product
where product.productRevenue is not null
  and totals.transactions>=1
group by month;


-- Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
WITH buyers AS (
  SELECT fullVisitorId
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
    AND product.productRevenue IS NOT NULL
    AND totals.transactions >= 1
)

SELECT
  product.v2ProductName AS product_name,
  SUM(product.productQuantity) AS total_quantity_ordered
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
  UNNEST(hits) AS hits,
  UNNEST(hits.product) AS product
WHERE fullVisitorId IN 
  (SELECT fullVisitorId 
  FROM buyers)
  AND product.productRevenue IS NOT NULL
  AND totals.transactions >= 1
  AND product.v2ProductName <> "YouTube Men's Vintage Henley"
GROUP BY product_name
ORDER BY total_quantity_ordered DESC;

-- cách trình bày của a

-- subquery:
select
    product.v2productname as other_purchased_product,
    sum(product.productQuantity) as quantity
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
where fullvisitorid in (select distinct fullvisitorid
                        from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
                        unnest(hits) as hits,
                        unnest(hits.product) as product
                        where product.v2productname = "YouTube Men's Vintage Henley"
                        and product.productRevenue is not null
                        AND totals.transactions>=1)
  and product.v2productname != "YouTube Men's Vintage Henley"
  and product.productRevenue is not null
  AND totals.transactions>=1
group by other_purchased_product
order by quantity desc;

-- CTE:
-- ở bảng buyer_list này, mình chỉ muốn tìm ra danh sách nhưng ng mua, thì nó người ngta sẽ mua nhiều lần chẳng hặn
-- khi mình select distinct fullVisitorId, nó sẽ 3 người, nhưng nếu mình select fullVisitorId
-- nó ra 6 dòng, tường ứng với 6 record trong bảng, rồi nó mang 6 dòng này, đi mapping tiếp với câu dưới, nên nó bị dup lên

with buyer_list as(
    SELECT
        distinct fullVisitorId  
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    , UNNEST(hits) AS hits
    , UNNEST(hits.product) as product
    WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
    AND totals.transactions>=1
    AND product.productRevenue is not null
)

SELECT
  product.v2ProductName AS other_purchased_products,
  SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
JOIN buyer_list using(fullVisitorId)
WHERE product.v2ProductName != "YouTube Men's Vintage Henley"
 and product.productRevenue is not null
 AND totals.transactions>=1
GROUP BY other_purchased_products
ORDER BY quantity DESC;



-- Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.
-- Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level.
WITH raw_data AS (
  SELECT
    PARSE_DATE('%Y%m%d', date) AS full_date,
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
    CAST(hits.eCommerceAction.action_type AS INT) AS action_type,
    product.productRevenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331' 
    AND CAST(hits.eCommerceAction.action_type AS INT) IN (2, 3, 6)
)

SELECT
  month,
  SUM(CASE WHEN action_type = 2 THEN 1 ELSE 0 END) AS num_product_view,
  SUM(CASE WHEN action_type = 3 THEN 1 ELSE 0 END) AS num_addtocart,
  SUM(CASE WHEN action_type = 6 AND productRevenue IS NOT NULL THEN 1 ELSE 0 END) AS num_purchase,
  ROUND(SAFE_DIVIDE(SUM(CASE WHEN action_type = 3 THEN 1 ELSE 0 END) * 100, SUM(CASE WHEN action_type = 2 THEN 1 ELSE 0 END)), 2) AS add_to_cart_rate,
  ROUND(SAFE_DIVIDE(SUM(CASE WHEN action_type = 6 AND productRevenue IS NOT NULL THEN 1 ELSE 0 END) * 100, SUM(CASE WHEN action_type = 2 THEN 1 ELSE 0 END)), 2) AS purchase_rate
FROM raw_data
GROUP BY month
ORDER BY month;

-- bài yêu cầu tính số sản phầm, mình nên count productName hay productSKU thì sẽ hợp lý hơn là count action_type
-- k nên xài inner join, nếu table1 có 10 record,table2 có 5 record,table3 có 1 record, thì sau khi inner join, output chỉ ra 1 record

-- Cách 1:dùng CTE  
with
product_view as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_product_view
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '2'
  GROUP BY 1
),

add_to_cart as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_addtocart
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '3'
  GROUP BY 1
),

purchase as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '6'
  and product.productRevenue is not null   --phải thêm điều kiện này để đảm bảo có revenue
  group by 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month;


with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CASE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,UNNEST(hits) as hits
,UNNEST (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select 
	*,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data;


