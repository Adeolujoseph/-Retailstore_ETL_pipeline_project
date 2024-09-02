SELECT 
    D_DATE_SK AS "Date ID",
    CAL_DT AS "Calendar Date",
    DAY_OF_WK_DESC AS "Day of Week",
    WK_NUM AS "Week Number",
    MNTH_NUM AS "Month Number",
    YR_MNTH_NUM AS "Year-Month Number",
    YR_NUM AS "Year Number",
    DAY_OF_WK_NUM AS "Day of Week Number",
    YR_WK_NUM AS "Year-Week Number"
FROM {{ref('stg_date_dim')}}
