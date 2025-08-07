import boto3

# AWS Lambda function to access an S3 bucket in another AWS account
# This function assumes a role in Account2 to access an S3 bucket.
def lambda_handler(event, context):
    sts_client = boto3.client('sts')
    assumed_role = sts_client.assume_role( 
        RoleArn="arn:aws:iam::<Account2-ID>:role/LambdaS3AccessRole", # Replace <Account2-ID> with the actual AWS Account ID of Account2
        RoleSessionName="LambdaSession" # A unique session name for the assumed role
    )

    # Use the temporary credentials to create an S3 client
    creds = assumed_role['Credentials'] # Get the temporary credentials
    s3 = boto3.client(
        's3',
        aws_access_key_id=creds['AccessKeyId'], # Access Key ID
        aws_secret_access_key=creds['SecretAccessKey'], # Secret Access Key
        aws_session_token=creds['SessionToken'] # Session Token
    )

    response = s3.list_objects_v2(Bucket='<Bucket-Name>') # Replace with the actual bucket name in Account2
    print(response)
    return {
        'statusCode': 200,
        'body': response
    }
# Ensure that the Lambda function has the necessary permissions to assume the role in Account2
# and that the role in Account2 trusts the Lambda function's execution role in Account1.
# Replace <Account2-ID> with the actual AWS Account ID of Account2 and <Bucket-Name> with the name of the S3 bucket in Account2.
# This code assumes that the Lambda function is running in Account1 and needs to access resources in Account2.
# Make sure to configure the IAM roles and policies correctly to allow cross-account access.
# Note: This code is for demonstration purposes and may need adjustments based on your specific use case and AWS environment.
