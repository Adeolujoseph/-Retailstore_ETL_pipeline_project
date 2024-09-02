{{
    config(
        materialization='incremental',
        unique_key=['inv_date_sk', 'inv_item_sk', 'inv_warehouse_sk']
    )
}}

select *
from {{ref('stg_inventory')}}
LEFT JOIN {{ref('stg_date_dim')}}
on inv_date_sk = d_date_sk
{% if is_incremental() %}
where cal_dt >= (select coalesce(max(cal_dt), 0) from {{ this }} )
{% endif %}
