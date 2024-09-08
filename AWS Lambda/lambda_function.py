# -*- coding: utf-8 -*-

def lambda_handler(event, context):
  import snowflake.connector as sf
  import boto3
  import os
  import toml

  config = toml.load('config.toml')

  def snowflake_config():
    credentials= {
        'account': config['snowflake']['account'],
        'warehouse': config['snowflake']['warehouse'],
        'database': config['snowflake']['database'],
        'schema': config['snowflake']['schema'],
        'table': config['snowflake']['table'],
        'user': config['snowflake']['user'],
        'role': config['snowflake']['role'],
        'stage_name': config['snowflake']['stage_name'],
        'password': os.getenv('SNOWFLAKE_PASSWORD')
    }
    return credentials

  def s3_config():
    s3_conf = {
        'file_name': config['s3']['file_name'],
        'bucket': config['s3']['bucket'],
        'local_file_path': config['s3']['local_file_path'],
        'aws_access_key_id': os.getenv('AWS_ACCESS_KEY_IDD'),
        'aws_secret_access_key': os.getenv('AWS_SECRET_ACCESS_KEYY'),
    }
    return s3_conf

  def connect_snowflake(credentials):
    conn = sf.connect(
        user=credentials['user'],
        password=credentials['password'],
        account=credentials['account'],
        warehouse=credentials['warehouse'],
        database=credentials['database'],
        schema=credentials['schema'],
        role=credentials['role']
    )
    return conn

  def download_from_s3(s3_config):
    client = boto3.client(
        's3',aws_access_key_id=s3_config['aws_access_key_id'],
        aws_secret_access_key=s3_config['aws_secret_access_key']
    )
    client.download_file(
        Bucket=s3_conf['bucket'],
        Key=s3_conf['file_name'],
        Filename=s3_conf['local_file_path'],
        ExtraArgs={'RequestPayer': 'requester'}
    )

    print("File downloaded from S3 successfully.")

  def upload_file_to_snowflake(conn, credentials, s3_config):
    cursor = conn.cursor()
    cursor.execute(f"use schema {credentials['schema']};")
    cursor.execute("CREATE or REPLACE FILE FORMAT COMMA_CSV TYPE ='CSV' FIELD_DELIMITER = ',';")
    # Create stage
    cursor.execute(f"CREATE OR REPLACE STAGE {credentials['stage_name']} FILE_FORMAT =COMMA_CSV")
    cursor.execute(f"PUT 'file://{s3_config['local_file_path']}' @{credentials['stage_name']}")
    # Truncate the table
    cursor.execute(f"truncate table {credentials['schema']}.{credentials['table']};")
    # Load the data from the stage into a table
    cursor.execute(f"COPY INTO {credentials['schema']}.{credentials['table']} FROM @{credentials['stage_name']}/{s3_config['file_name']} FILE_FORMAT =COMMA_CSV ON_ERROR = 'CONTINUE';")
    print("File uploaded to Snowflake successfully.")
    # Close the cursor and connection
    cursor.close()
    conn.close()

  credentials = snowflake_config()
  s3_conf = s3_config()
  conn = connect_snowflake(credentials)
  download_from_s3(s3_conf)
  upload_file_to_snowflake(conn, credentials, s3_conf)
  return {
      'statusCode': 200,
      'body': 'File uploaded to Snowflake successfully.'
  }
