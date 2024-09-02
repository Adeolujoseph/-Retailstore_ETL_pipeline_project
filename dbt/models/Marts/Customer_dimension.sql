SELECT 
    c_salutation AS customer_salutation,
    c_preferred_cust_flag AS preferred_customer_flag,
    c_first_sales_date_sk AS first_sales_date_id,
    c_customer_sk AS customer_id,
    c_login AS customer_login,
    c_current_cdemo_sk AS current_demographics_id,
    c_first_name AS first_name,
    c_current_hdemo_sk AS current_household_demographics_id,
    c_current_addr_sk AS current_address_id,
    c_last_name AS last_name,
    c_customer_id AS customer_code,
    c_last_review_date_sk AS last_review_date_id,
    c_birth_month AS birth_month,
    c_birth_country AS birth_country,
    c_birth_year AS birth_year,
    c_birth_day AS birth_day,
    c_email_address AS email_address,
    c_first_shipto_date_sk AS first_ship_to_date_id,
    ca_street_name AS street_name,
    ca_suite_number AS suite_number,
    ca_state AS state,
    ca_location_type AS location_type,
    ca_country AS country,
    ca_address_id AS address_code,
    ca_county AS county,
    ca_street_number AS street_number,
    ca_zip AS zip_code,
    ca_city AS city,
    ca_street_type AS street_type,
    ca_gmt_offset AS gmt_offset,
    cd_dep_employed_count AS dependents_employed_count,
    cd_dep_count AS dependents_count,
    cd_credit_rating AS credit_rating,
    cd_education_status AS education_status,
    cd_purchase_estimate AS purchase_estimate,
    cd_marital_status AS marital_status,
    cd_dep_college_count AS dependents_in_college_count,
    cd_gender AS gender,
    hd_buy_potential AS buying_potential,
    hd_income_band_sk AS income_band_id,
    hd_dep_count AS household_dependents_count,
    hd_vehicle_count AS vehicle_count,
    ib_lower_bound AS income_lower_bound,
    ib_upper_bound AS income_upper_bound
FROM 
    {{ref('int_customer_snapshot')}}
LEFT JOIN 
    {{ref('stg_customer_address')}} ON c_current_addr_sk = ca_address_sk
LEFT JOIN 
    {{ref('stg_customer_demographics')}} ON c_current_cdemo_sk = cd_demo_sk
LEFT JOIN 
    {{ref('stg_household_demographics')}} ON c_current_hdemo_sk = hd_demo_sk
LEFT JOIN 
    {{ref('stg_income_band')}} ON hd_income_band_sk = ib_income_band_sk
WHERE 
    dbt_valid_to IS NULL
