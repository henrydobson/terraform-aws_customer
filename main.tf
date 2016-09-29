provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

data "aws_caller_identity" "current" { }

# Manage roles 
data "template_file" "allow_account_assume_role" {
  template = "${file("${path.module}/policies/allow_account_assume_role.tpl")}"

  vars {
    account_id = "${var.master_account_id}"
  }
}

resource "aws_iam_role" "readonly" {
    name = "readonly"
    assume_role_policy = "${data.template_file.allow_account_assume_role.rendered}"
}

resource "aws_iam_role_policy_attachment" "readonlyaccess" {
    role = "${aws_iam_role.readonly.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role" "admin" {
    name = "admin"
    assume_role_policy = "${data.template_file.allow_account_assume_role.rendered}"
}

resource "aws_iam_role_policy_attachment" "adminaccess" {
    role = "${aws_iam_role.admin.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Manage policies for Force_MFA
resource "aws_iam_policy" "allow_config_put_evaluations" {
    name = "allow_config_put_evaluations"
    policy = "${file("${path.module}/policies/allow_config_put_evaluations.json")}"
}

resource "aws_iam_policy_attachment" "lambda_iam_mfa_check-attach" {
    name = "lambda_iam_mfa_check-attachment"
    roles = ["${aws_iam_role.lambda_iam_mfa_check.name}"]
    policy_arn = "${aws_iam_policy.allow_config_put_evaluations.arn}"
}

resource "aws_iam_policy" "allow_iam_mfa_read" {
    name = "allow_iam_mfa_read"
    policy = "${file("${path.module}/policies/allow_iam_mfa_read.json")}"
}

resource "aws_iam_policy_attachment" "allow_iam_mfa_read-attach" {
    name = "allow_iam_mfa_read-attachment"
    roles = ["${aws_iam_role.lambda_iam_mfa_check.name}"]
    policy_arn = "${aws_iam_policy.allow_iam_mfa_read.arn}"
}

resource "aws_iam_role_policy" "lambda_basic_execution" {
    name = "oneClick_lambda_basic_execution"
    role = "${aws_iam_role.lambda_iam_mfa_check.id}"
    policy = "${file("${path.module}/policies/lambda_basic_execution.json")}"
}

resource "aws_iam_role" "lambda_iam_mfa_check" {
    name = "lambda_iam_mfa_check_role"
    assume_role_policy = ${file("${path.module}/policies/allow_lambda_assume_role.json")}
}

data "template_file" "force_mfa" {
  template = "${file("${path.module}/policies/force_mfa.tpl")}"
  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_group_policy" "force_mfa" {
    name = "Force_MFA"
    group = "${aws_iam_group.force_mfa.id}"
    policy = "${data.template_file.force_mfa.rendered}"
}

resource "aws_iam_group" "force_mfa" {
    name = "Force_MFA"
}
