import time
import json
import boto3

session = boto3.session.Session(profile_name='personal')
account = "820212852497"
environment = "beta"
userId = "4636267"

QueueUrl = f"https://sqs.us-east-1.amazonaws.com/{account}/{environment}-{userId}-data-consumer"

if __name__ == '__main__':
    try:
        while(True):
            client_sqs = session.client('sqs')
            response = client_sqs.receive_message(
                QueueUrl=QueueUrl
            )
            if response.get("Messages",None):
                message = response['Messages'][0]
                receipt_handle = message['ReceiptHandle']

                client_sqs.delete_message(
                    QueueUrl=QueueUrl,
                    ReceiptHandle=receipt_handle
                )
                print('Received and deleted message: %s' % message)
            time.sleep(5)
    except:
        print("Something went wrong.")
