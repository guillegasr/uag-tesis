import json
import boto3
import os

TABLE_NAME = os.getenv("TABLE_NAME")
EVENT_QUEUE_NAME = os.getenv("EVENT_QUEUE_NAME")
account = "820212852497"
QueueUrl = f"https://sqs.us-east-1.amazonaws.com/{account}/{EVENT_QUEUE_NAME}"

def lambda_handler(event, context):

    client_sqs = boto3.client('sqs')
    message = event['Records'][0]['dynamodb']['NewImage']

    response = client_sqs.send_message(
        QueueUrl=QueueUrl,
        MessageBody=json.dumps(message),
    )
    print("Message sent.")

    return
