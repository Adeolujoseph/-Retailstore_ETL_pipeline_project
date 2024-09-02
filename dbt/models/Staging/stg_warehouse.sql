SELECT 
    W_ZIP,
    W_WAREHOUSE_NAME,
    W_STREET_NAME,
    W_STATE,
    W_CITY,
    W_COUNTY,
    W_STREET_TYPE,
    W_WAREHOUSE_SQ_FT,
    W_SUITE_NUMBER,
    W_STREET_NUMBER,
    W_COUNTRY,
    W_WAREHOUSE_SK,
    W_GMT_OFFSET,
    W_WAREHOUSE_ID
FROM {{source('tpcds', 'warehouse')}}