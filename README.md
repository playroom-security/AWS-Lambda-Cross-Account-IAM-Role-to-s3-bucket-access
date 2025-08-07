## Introduction

This lab demonstrates a Lambda function in AWS account 1 (the origin) using Python boto SDK to assume an IAM role in account 2 (the destination), then list the buckets. If you only have 1 AWS account simply repeat the instructions in that account and use the same account id.

To enable a Lambda function in **Account 1** to list objects in an S3 bucket in **Account 2**, you'll need to set up **cross-account access** using IAM roles and resource-based policies. Here's a step-by-step guide tailored for your cloud security focus, including the necessary inline policies.

## **Goals**

- Cross account role assumption
- Creating IAM roles
- Lambda assuming another role
- Basic scripting

## **Lab Architecture**
![Lab Architecture](/Images/lambda-s3.png)

## **Project Structure**
```
cross-account-lambda-s3-access/
├── README.md
├── account1/
│   ├── create_lambda_role.sh
│   ├── lambda_function.py
│   └── deploy_lambda.sh
├── account2/
│   ├── create_s3_access_role.sh
│   └── bucket_policy.json
└── assets/
    └── architecture-diagram.png

```

## **Best practices**

- SEC02-BP02 Use temporary credentials
- SEC02-BP03 Store and use secrets securely

## **Prerequisites**

- An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html)  that you are able to use for testing, that is not used for production or other purposes.
- An IAM user with MFA enabled that can assume roles in your AWS account.
- You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/) .

## **Last Updated**

- August 2015

## Author

- ha5hcat | Cloud security engineer

## **Steps:**

- Create IAM Role in Account 2 (Bucket Owner)
- Attach inline Policy to Role in Account 2
- Modify Lambda Execution Role in Account 1
- Update Lambda Function Code in Account 1


## **References & useful resources**

- [IAM Policies with conditional keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html)