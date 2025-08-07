#!/bin/bash

# This script creates a Lambda execution role in AWS Account 1
# that allows it to assume a role in AWS Account 2. 
# Ensure you have AWS CLI configured with the correct credentials for Account 1.
set -e
# Replace with your actual AWS Account ID for Account 2


ACCOUNT2_ID="<Account2-ID>"
ROLE_NAME="LambdaExecutionRole"

cat <<EOF > trust-policy.json
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
  --assume-role-policy-document file://trust-policy.json

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
aws iam attach-role-policy --role-name $ROLE_NAME \
  --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"       
aws iam attach-role-policy --role-name $ROLE_NAME \
  --policy-arn "arn:aws:iam::aws:policy/AWSLambdaVPCAccessExecutionRole"
  