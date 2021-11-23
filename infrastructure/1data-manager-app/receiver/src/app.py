import json
import boto3
import os

# Environment Variables
TABLE_NAME = os.getenv("TABLE_NAME")

def lambda_handler(event, context):
    body = json.loads(event['Records'][0]['body'])
    id = body['id']
    type = body['type']
    value = body['value']

    client = boto3.client('dynamodb')
    client.update_item(
        ExpressionAttributeNames={
            '#T': 'type',
            '#V': 'value'
        },
        ExpressionAttributeValues={
            ':t': {
                'S': type,
            },
            ':v': {
                'S': value,
            },
        },
        Key={
            'id': {
                'S': id,
            }
        },
        ReturnValues='ALL_NEW',
        TableName=TABLE_NAME,
        UpdateExpression='SET #T = :t, #V = :v'
    )

    return 
