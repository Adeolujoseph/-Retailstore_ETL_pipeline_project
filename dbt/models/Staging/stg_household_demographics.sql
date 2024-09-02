SELECT 
    HD_BUY_POTENTIAL,
    HD_INCOME_BAND_SK,
    HD_DEMO_SK,
    HD_DEP_COUNT,
    HD_VEHICLE_COUNT
FROM {{source('tpcds', 'household_demographics')}}