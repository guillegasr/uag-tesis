import json
import boto3
import os

TABLE_NAME = os.getenv("TABLE_NAME")

def lambda_handler(event, context):
    client = boto3.client('dynamodb')

    response = client.scan(
        TableName=TABLE_NAME,
    )

    return {
        'statusCode': 200,
        'body': json.dumps(response),
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        }
    }
