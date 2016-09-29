output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "role-readonly" {
  value = "${aws_iam_role.readonly.arn}"
}

output "role-admin" {
  value = "${aws_iam_role.admin.arn}"
}
