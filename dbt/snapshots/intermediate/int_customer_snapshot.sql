{% snapshot int_customer_snapshot %}
{{ config(
    target_schema="DBT_Intermediate",
    target_database="tpcds",
    unique_key="C_CUSTOMER_SK",
    strategy= "check",
    check_cols="all"
) }}

SELECT * 
FROM {{ref('stg_customer')}}

{% endsnapshot %}