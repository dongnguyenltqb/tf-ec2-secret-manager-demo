resource "aws_iam_instance_profile" "profile" {
  name = "AWSSecretReadDemoProfile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "AWSSecretReadDemoRole"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
  })
}

resource "aws_iam_policy" "policy" {
  depends_on = [
    aws_secretsmanager_secret_version.current
  ]
  name = "AWSSecretReadDemoPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          aws_secretsmanager_secret.app.id
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
