{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAllUsersToListAccounts",
            "Effect": "Allow",
            "Action": [
                "iam:ListAccountAliases",
                "iam:ListUsers"
            ],
            "Resource": [
                "arn:aws:iam::${account_id}:user/*"
            ]
        },
        {
            "Sid": "AllowIndividualUserToSeeTheirAccountInformation",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:CreateLoginProfile",
                "iam:DeleteLoginProfile",
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary",
                "iam:GetLoginProfile",
                "iam:UpdateLoginProfile"
            ],
            "Resource": [
                "arn:aws:iam::${account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToListTheirMFA",
            "Effect": "Allow",
            "Action": [
                "iam:ListVirtualMFADevices",
                "iam:ListMFADevices"
            ],
            "Resource": [
                "arn:aws:iam::${account_id}:mfa/*",
                "arn:aws:iam::${account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToManageThierMFA",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "DoNotAllowAnythingOtherThanAboveUnlessMFAd",
            "Effect": "Deny",
            "NotAction": "iam:*",
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:MultiFactorAuthAge": "true"
                }
            }
        }
    ]
}
