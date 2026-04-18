resource "aws_iam_user" "user" {
  name = "${var.name}-${data.aws_region.current.region}"
  path = "/"
}

resource "aws_iam_user_policy_attachment" "attachment" {
  for_each = var.policy_arns

  user       = aws_iam_user.user.name
  policy_arn = each.key
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}
