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

