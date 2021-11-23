import json
import boto3

session = boto3.session.Session(profile_name='personal')
account = "820212852497"
environment = "beta"
userId = "4636267"

QueueUrl = f"https://sqs.us-east-1.amazonaws.com/{account}/{environment}-{userId}-data-receiver"

if __name__ == '__main__':
    try:
        # Update your code to create a json object to be sended to queue.
        client_sqs = session.client('sqs')
        message = json.dumps({
            "id": "1",
            "type": "T",
            "value": "110"
        })

        response = client_sqs.send_message(
            QueueUrl=QueueUrl,
            MessageBody=message,
        )
        print("Message sent.")
    except:
        print("Something went wrong.")
