#!/bin/bash

# This script creates a role in AWS Account1 that allows a Lambda function to assume a role in Account2.
# This script assumes you have AWS CLI configured with the necessary permissions.
# Replace <Account2-ID> with the actual AWS Account ID of Account2
# Replace <Account2-ID> with the actual AWS Account ID of Account2      


ACCOUNT2_ID="<Account2-ID>"
ROLE_NAME="LambdaExecutionRole"

# Create a role for the Lambda function in Account1
cat <<EOF > assume-role-policy.json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "lambda.amazonaws.com" },
    "Action": "sts:AssumeRole"
  }]
}
EOF

aws iam create-role --role-name $ROLE_NAME \
  --assume-role-policy-document file://assume-role-policy.json

# Create a trust policy to allow the Lambda function in Account1 to assume the role in Account2
cat <<EOF > cross-account-policy.json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::$ACCOUNT2_ID:role/LambdaS3AccessRole"
  }]
}
EOF

aws iam put-role-policy --role-name $ROLE_NAME \
  --policy-name "AssumeCrossAccountRole" \
  --policy-document file://cross-account-policy.json

# Attach necessary policies to the rolePAccessExecutionRole"
aws iam attach-role-policy --role-name $ROLE_NAME \
  --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
aws iam attach-role-policy --role-name $ROLE_NAME \
  --policy-arn "arn:aws:iam::aws:policy/AWSLambdaVP 

