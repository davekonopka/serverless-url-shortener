provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "${var.aws_region}"
}

resource "aws_dynamodb_table" "redir_urls" {
  name = "redir_urls"
  read_capacity = 1
  write_capacity = 1
  hash_key = "token"
  stream_enabled = false
  attribute {
    name = "token"
    type = "S"
  }
}

resource "aws_iam_role_policy" "redir_logs_rw" {
    name = "redir_logs_rw"
    role = "${aws_iam_role.lambda_redir.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchRW",
            "Resource": "*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "redir_data_rw" {
    name = "redir_data_rw"
    role = "${aws_iam_role.lambda_redir.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DynamoDBRW",
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:Get*",
                "dynamodb:PutItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
      ]
}
EOF
}

resource "aws_iam_role" "lambda_redir" {
    name = "lambda_redir"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
