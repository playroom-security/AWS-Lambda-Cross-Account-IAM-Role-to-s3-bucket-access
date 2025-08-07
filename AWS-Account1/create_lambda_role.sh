#!/bin/bash

# This script creates a Lambda execution role in AWS Account 1
# that allows it to assume a role in AWS Account 2. 
# Ensure you have AWS CLI configured with the correct credentials for Account 1.
set -e
# Replace with your actual AWS Account ID for Account 2


account1_id="1111-1111-1111" # Replace with your Account2 ID
account2_id="2222-2222-2222" # Replace with your Account1 ID
export AWS_DEFAULT_REGION="us-west-2" # Set your desired AWS region
ROLE_NAME="Lambdas3ExecutionRoledemo"

cat <<EOF > trust-policy.json
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
  --assume-role-policy-document file://trust-policy.json

cat <<EOF > cross-account-policy.json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::$account2_id:role/Lambdas3LisBucketPolicy",
    "Condition": {
      "StringLike": {
        "aws:UserAgent": "AWS_Lambda_Python*"

  }]
},
{
            "Sid": "logsstreamevent",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:us-east-1:$account1_id:log-group:/aws/lambda/Lambda-Assume-Roles*/*"
        },
        {
            "Sid": "logsgroup",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        }
    ]
}

EOF

aws iam put-role-policy --role-name $ROLE_NAME \
  --policy-name "AssumeCrossAccountRole" \
  --policy-document file://cross-account-policy.json
aws iam attach-role-policy --role-name $ROLE_NAME \
  --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" 