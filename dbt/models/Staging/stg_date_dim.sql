SELECT 
    D_DATE_ID,
    CAL_DT,
    DAY_OF_WK_DESC,
    WK_NUM,
    MNTH_NUM,
    YR_MNTH_NUM,
    D_DATE_SK,
    YR_NUM,
    DAY_OF_WK_NUM,
    YR_WK_NUM
FROM {{source('tpcds', 'date_dim')}}