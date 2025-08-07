#!/bin/bash

ROLE_NAME="LambdaExecutionRole"
ZIP_FILE="lambda.zip"

zip $ZIP_FILE lambda_function.py

# Check if the IAM role exists, if not create it
if aws iam get-role --role-name $ROLE_NAME 2>/dev/null; then
  echo "Role $ROLE_NAME already exists."
else
  echo "Creating IAM role $ROLE_NAME..."
  aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://trust-policy.json \
    --description "Role for Lambda function to access S3 in another account" \
    --region us-west-2

# Update the Lambda function code if it already exists
if aws lambda get-function --function-name CrossAccountS3Lister --region us-west-2 2>/dev/null; then
  echo "Function already exists, updating code..."
else
  echo "Creating new Lambda function..."
  aws lambda create-function \
    --function-name CrossAccountS3Lister \
    --runtime python3.9 \
    --role arn:aws:iam::<Account1-ID>:role/$ROLE_NAME \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://$ZIP_FILE \
    --region us-west-2
fi

aws lambda update-function-code \
  --function-name CrossAccountS3Lister \
  --zip-file fileb://$ZIP_FILE  \
  --publish \
  --region us-west-2