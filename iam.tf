data "aws_iam_policy" "amazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name = "${var.r_prefix}_ecsTaskExecutionRole"
    assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
    managed_policy_arns = [data.aws_iam_policy.amazonECSTaskExecutionRolePolicy.arn, aws_iam_policy.IAMSSMPolicy.arn]

    max_session_duration = 3600
}

resource "aws_iam_policy" "IAMSSMPolicy" {
  name   = "${var.r_prefix}_ssm_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
