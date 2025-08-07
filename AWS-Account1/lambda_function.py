import json
import boto3
import os
import uuid

def handler(event, context):
    """Lambda function to list objects in an S3 bucket in Account 2 using a cross-account IAM role."""
    # Set the AWS region if not already set
    if 'AWS_DEFAULT_REGION' not in os.environ:
        os.environ['AWS_DEFAULT_REGION'] = 'us-west-2'  # Replace with your desired AWS region  
    # Log the event for debugging
    print(f"Received event: {json.dumps(event)}")
    # Log the context for debugging
    print(f"Received context: {json.dumps(context.__dict__)}")
    # Ensure the required environment variables are set
    
    try:
        # Replace with the ARN of the role in Account 2
        account2RoleArn = 'arn:aws:iam::2222-2222-2222:role/Lambdas3LisBucketPolicy'
        
        # Replace with the name of the target S3 bucket
        target_bucket = 'my-target-bucket'  # Replace with your target bucket name

        # Assume the role in Account 2
        sts_client = boto3.client('sts')
        response = sts_client.assume_role(
            RoleArn=account2RoleArn,
            RoleSessionName="{}-s3".format(str(uuid.uuid4())[:5])
        )

        # Create a session using the temporary credentials
        session = boto3.Session(
            aws_access_key_id=response['Credentials']['AccessKeyId'],
            aws_secret_access_key=response['Credentials']['SecretAccessKey'],
            aws_session_token=response['Credentials']['SessionToken']
        )

        # Use the session to create an S3 client
        s3 = session.client('s3')

        # List objects in the specified bucket
        object_list = s3.list_objects_v2(Bucket=target_bucket)

        # Extract object keys
        if 'Contents' in object_list:
            keys = [obj['Key'] for obj in object_list['Contents']]
            print(f"Objects in bucket '{target_bucket}': {keys}")
            return keys
        else:
            print(f"No objects found in bucket '{target_bucket}'.")
            return []

    except Exception as e:
        print(f"Error: {e}")
        raise e
