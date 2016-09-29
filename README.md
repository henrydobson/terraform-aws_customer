# AWS Customer Module

# Table of Contents

<!-- MDTOC maxdepth:6 firsth1:2 numbering:0 flatten:0 bullets:1 updateOnSave:1 -->

 - [Prerequisites](#prerequisites)

  - [IAM Roles](#iam-roles)
  - [Policy: allow_account_assume_role](#policy-allow_account_assume_role)
  - [Groups](#groups)
  - [IAM Group Policy](#iam-group-policy)
  - [Console Changes Required](#console-changes-required)

<!-- /MDTOC -->

## Prerequisites

- Create IAM User: terraform
- Create S3 bucket for terraform state: ie. terraform-me
- Attach policy to bucket:

  ```json
  {
      "Version": "2012-10-17",
      "Id": "Policy1468259090486",
      "Statement": [
          {
              "Sid": "Stmt1468256907790",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::ACCOUNT_ID:user/terraform"
              },
              "Action": "s3:*",
              "Resource": "arn:aws:s3:::terraform-me/*"
          }
      ]
  }
  ```

- terraform remote config setup

## IAM Roles

- readonly

- admin

## Policy: allow_account_assume_role

- Accepts the master_account_id variable from your `./terraform.tfvars`
- Allows attached roles to be assumed from the master_account_id provided

## Groups

- Force_MFA

## IAM Group Policy

- Restricts members access to all services unless they have signed in with MFA

## Console Changes Required

- Set custom IAM User Sign In URL
- Setup Config if required
- MFA
- Password policy
- Consolidated billing
- Lambda
