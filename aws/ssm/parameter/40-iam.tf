data "aws_iam_policy_document" "write" {
  statement {
    sid = "WriteSSMParameter"

    actions = [
      "ssm:PutParameter",
    ]

    resources = [
      aws_ssm_parameter.parameter.arn,
    ]
  }
}

data "aws_iam_policy_document" "read" {
  statement {
    sid = "ReadSSMParameter"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      aws_ssm_parameter.parameter.arn,
    ]
  }
}

resource "aws_iam_policy" "write" {
  name        = "ssm-write-${data.aws_region.current.region}-${local.underscored_name}"
  path        = "/"
  description = "Allow write only access to SSM parameter ${var.name} (${data.aws_region.current.region})."
  policy      = data.aws_iam_policy_document.write.json
}

resource "aws_iam_policy" "read" {
  name        = "ssm-read-${data.aws_region.current.region}-${local.underscored_name}"
  path        = "/"
  description = "Allow read only access to SSM parameter ${var.name} (${data.aws_region.current.region})."
  policy      = data.aws_iam_policy_document.read.json
}
