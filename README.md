# Retail store ELT pipeline project
## Project Overview: 
I designed and developed an ELT (Extract, Load, Transform) pipeline for a retail store. The pipeline performs the following functions:
1. Data Collection:
OLTP Data: Data is extracted from the store’s OLTP database (RDS) and loaded into Snowflake using Airbyte. This process is scheduled to run daily.
S3 Data: Data is also collected from an S3 bucket and loaded into Snowflake using an AWS Lambda function. This Lambda function is orchestrated to run daily at 6 AM using Amazon EventBridge.
2. Data Transformation:
The data in Snowflake is transformed using dbt (Data Build Tool) to meet business requirements. The transformation models are scheduled to run using a cron job.
3. Data Visualization:
The transformed data is used to create visualizations in Metabase. Metabase is configured to refresh its data daily to ensure up-to-date reports and dashboards.

## Project Architecture:
![image](https://github.com/user-attachments/assets/271dd6cd-42d9-4607-ae0d-553862a0d50c)

## Business Scenerio:
A retail store needs a Data Engineer to develop an ELT (Extract, Load, Transform) pipeline that extracts raw data from the company’s database, transforms it to meet business needs, and offers a platform for Data Analysts to create visualizations that address key business questions.
![image](https://github.com/user-attachments/assets/7133e9d8-a812-4ba5-b063-386e92e2d0ea)

## Business Questions:

1.Identification of the highest and lowest-performing items of the week by analyzing sales amounts and quantities.
2.Display of items with low supply levels for each week.
3.Detection of items experiencing low stock levels, along with their corresponding week and warehouse numbers, marked as "True".
4.Analysis of Revenue 
5.Analysis of Customer 
6.Analysis of Warehouse based on low stock items and Revenue



## Steps:
1. Integration of some raw tables, such as several customer-related tables, into one table.
2. Creation of a new fact table with additional metrics:
    sum_qty_wk: Sum of sales_quantity for the current week.
  
    sum_amt_wk: Sum of sales_amount for the current week.
    
    sum_profit_wk: Sum of net_profit for the current week.
    
    avg_qty_dy: Average daily sales_quantity for the current week (calculated as sum_qty_wk/7).
    
    inv_on_hand_qty_wk: Item inventory on hand at the end of each week across all warehouses (equivalent to the inventory on hand at the end of the weekend).
    
    wks_sply: Weeks of supply, an estimated metric indicating how many weeks the inventory can supply the sales (calculated as inv_on_hand_qty_wk/sum_qty_wk).
    
    low_stock_flg_wk: Low stock weekly flag. If, during the week, there is a single day where [(avg_qty_dy > 0 && avg_qty_dy > inventory_on_hand_qty_wk)], then set the flag to True.
