SELECT 
    IB_LOWER_BOUND,
    IB_INCOME_BAND_SK,
    IB_UPPER_BOUND
FROM {{source('tpcds', 'income_band')}}