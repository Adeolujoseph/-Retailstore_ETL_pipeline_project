{{
    config(
        materialization='incremental',
        unique_key=['sold_date_sk', 'cal_dt', 'item_sk', 'warehouse_sk']
    )
}}

with cte as (
SELECT 
        ws_sold_date_sk AS sold_date_sk, 
        cal_dt, 
        yr_num,
        wk_num, 
        ws_item_sk AS item_sk,
        ws_warehouse_sk AS warehouse_sk, 
        ws_quantity AS sales_quantity,
        ws_net_paid AS sales_amount, 
        ws_net_profit AS net_profit
    FROM 
        {{ref('stg_web_sales')}}
    LEFT JOIN 
        {{ref('stg_date_dim')}} ON ws_sold_date_sk = d_date_sk
    UNION ALL
    SELECT 
        cs_sold_date_sk AS sold_date_sk, 
        cal_dt, 
        yr_num,
        wk_num, 
        cs_item_sk AS item_sk,
        cs_warehouse_sk AS warehouse_sk, 
        cs_quantity AS sales_quantity,
        cs_net_paid AS sales_amount, 
        cs_net_profit AS net_profit
    FROM 
        {{ref('stg_catalog_sales')}}
    LEFT JOIN 
        {{ref('stg_date_dim')}} ON cs_sold_date_sk = d_date_sk
    
) 
SELECT 
    sold_date_sk, 
    cal_dt, 
    item_sk,
    yr_num,
    wk_num,
    warehouse_sk, 
    SUM(sales_quantity) AS sales_qty_item_wh_day,
    SUM(sales_amount) AS sales_amount_item_wh_day, 
    SUM(net_profit) AS net_profit_item_wh_day
FROM cte
    {% if is_incremental() %}
    where cal_dt >= (select coalesce(max(cal_dt), 0) from {{ this }} )
    {% endif %}
GROUP BY 1, 2, 3, 4, 5,6
