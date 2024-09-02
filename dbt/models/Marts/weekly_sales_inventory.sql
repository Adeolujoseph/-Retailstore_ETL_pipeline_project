{{
    config(
        materialization='incremental',
        unique_key=['item_sk', 'date_yr', 'wk_num', 'warehouse_sk']
    )
}}

with summary_sales_wk as (
    SELECT 
        item_sk,
        yr_num as date_yr, 
        wk_num, 
        warehouse_sk, 
        SUM(sales_qty_item_wh_day) AS sales_qty_per_week, 
        SUM(net_profit_item_wh_day) AS net_profit_per_week,
        SUM(sales_amount_item_wh_day) AS sales_amount_per_week,
        SUM(sales_qty_item_wh_day)/7 AS avg_daily_sales_qty
    FROM 
        {{ref('int_facts_daily_sales')}}
    GROUP BY 1, 2, 3, 4
    ORDER BY 1, 2, 3, 4
), 
summary_inventory as (
    SELECT 
        inv_item_sk, 
        yr_num AS date_yr, 
        wk_num,
        inv_warehouse_sk, 
        SUM(inv_quantity_on_hand) AS qty_on_hand_per_week
    FROM 
        {{ref('int_inventory')}}
    GROUP BY 1, 2, 3, 4
    ORDER BY 1, 2, 3, 4
), 
date_by_wk AS (
    SELECT 
        yr_num,
        wk_num,
        MIN(cal_dt) AS date
    FROM 
        {{ref('stg_date_dim')}}
    GROUP BY yr_num, wk_num
)
SELECT DISTINCT
    COALESCE(s.item_sk, i.inv_item_sk) AS item_id,
    COALESCE(s.date_yr, i.date_yr) AS year,
    COALESCE(s.wk_num, i.wk_num) AS week_number,
    d.date AS week_start_date,
    COALESCE(s.warehouse_sk, i.inv_warehouse_sk) AS warehouse_id,
    s.sales_qty_per_week AS sales_quantity_per_week,
    s.sales_amount_per_week AS sales_amount_per_week,
    s.net_profit_per_week AS net_profit_per_week,
    s.avg_daily_sales_qty AS average_daily_sales_quantity,
    COALESCE(i.qty_on_hand_per_week,0) AS quantity_on_hand_per_week,
    CASE 
        WHEN quantity_on_hand_per_week = 0 THEN 0
        ELSE quantity_on_hand_per_week / sales_quantity_per_week
    END AS weeks_of_supply,
    CASE 
        WHEN average_daily_sales_quantity > 0 AND average_daily_sales_quantity > quantity_on_hand_per_week THEN true
        ELSE false
    END AS low_stock_flag
FROM 
    summary_sales_wk s
FULL OUTER JOIN 
    summary_inventory i
    ON s.item_sk = i.inv_item_sk
    AND s.date_yr = i.date_yr
    AND s.wk_num = i.wk_num
    AND s.warehouse_sk = i.inv_warehouse_sk
LEFT JOIN 
    date_by_wk d 
    ON s.date_yr = d.yr_num 
    AND s.wk_num = d.wk_num
WHERE 
    s.sales_qty_per_week > 0  
{% if is_incremental() %}
    AND (week_start_date >= (SELECT MAX(week_start_date) FROM {{ this }}))
{% endif %}
