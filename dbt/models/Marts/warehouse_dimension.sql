SELECT 
    W_WAREHOUSE_SK AS "Warehouse ID",
    W_ZIP AS "ZIP Code",
    W_WAREHOUSE_NAME AS "Warehouse Name",
    W_STREET_NAME AS "Street Name",
    W_STATE AS "State",
    W_CITY AS "City",
    W_COUNTY AS "County",
    W_STREET_TYPE AS "Street Type",
    W_WAREHOUSE_SQ_FT AS "Warehouse Square Footage",
    W_SUITE_NUMBER AS "Suite Number",
    W_STREET_NUMBER AS "Street Number",
    W_COUNTRY AS "Country",
    W_GMT_OFFSET AS "GMT Offset",
    W_WAREHOUSE_ID AS "Warehouse Identity"
FROM {{ref('stg_warehouse')}}
