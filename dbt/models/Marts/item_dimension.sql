SELECT 
    I_ITEM_SK AS Item_ID,
    I_ITEM_DESC AS "Item Description",
    I_CONTAINER AS "Container Type",
    I_MANUFACT_ID AS "Manufacturer ID",
    I_WHOLESALE_COST AS "Wholesale Cost",
    I_BRAND_ID AS "Brand ID",
    I_FORMULATION AS "Formulation",
    I_CURRENT_PRICE AS "Current Price",
    I_SIZE AS "Size",
    I_MANUFACT AS "Manufacturer Name",
    I_REC_START_DATE AS "Record Start Date",
    I_MANAGER_ID AS "Manager ID",
    I_CLASS AS "Class",
    I_ITEM_ID AS "Item Identity",
    I_CLASS_ID AS "Class ID",
    I_CATEGORY AS "Category",
    I_CATEGORY_ID AS "Category ID",
    I_BRAND AS "Brand Name",
    I_UNITS AS "Units",
    I_COLOR AS "Color",
    I_PRODUCT_NAME AS "Product Name",
    I_REC_END_DATE AS "Record End Date"
FROM {{ref('stg_item')}}
