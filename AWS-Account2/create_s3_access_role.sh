#!/bin/bash

# This script creates a role in AWS Account1 that allows a Lambda function to assume a role in Account2.
# This script assumes you have AWS CLI configured with the necessary permissions.
# Replace <Account2-ID> with the actual AWS Account ID of Account2
# Replace <Account2-ID> with the actual AWS Account ID of Account2      


account2_id="2222-2222-2222" # Replace with your Account2 ID
account1_id="1111-1111-1111" # Replace with your Account1 ID
set -e
# Set the AWS region
export AWS_DEFAULT_REGION="us-west-2" # Set your desired AWS region
ROLE_NAME="Lambdas3LisBucketPolicy" # Name of the IAM role for Lambda execution

# Create a role for the Lambda function in Account1
cat <<EOF > assume-role-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::$account2_id:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
EOF

aws iam create-role --role-name $ROLE_NAME \
  --assume-role-policy-document file://assume-role-policy.json \
  --profile general

# Create a trust policy to allow the Lambda function in Account1 to assume the role in Account2
cat <<EOF > cross-account-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3ListAllMyBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        }
    ]
}
EOF

aws iam put-role-policy --role-name $ROLE_NAME \
  --policy-name "AssumeCrossAccountRole" \
  --policy-document file://cross-account-policy.json \
  --profile general

# Attach necessary policies to the rolePAccessExecutionRole"
aws iam attach-role-policy --role-name $ROLE_NAME \
  --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" \
  --profile general

