terraform {
  required_providers {
    aws = {
      version = ">=4.9.0"
      source  = "hashicorp/aws"
    }
  }
}




provider "aws" {
  profile = "default"
  region  = "us-west-1"
}


resource "aws_lambda_function" "myfunction" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name    = "myfunction"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "function.lambda_handler"
  runtime          = "python3.8"
}


resource "aws_iam_role" "iam_for_lambda" {
 name   = "iam_for_lambda"
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




resource "aws_iam_policy" "aws_iam_policy_for_terraform_resume_project_policy" {
  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the resume project role"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:us-west-1:598432830149:*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ],
        "Resource": "arn:aws:dynamodb:us-west-1:598432830149:table/cloudresume-challenge"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "aws_iam_policy_for_terraform_resume_project_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.aws_iam_policy_for_terraform_resume_project_policy.arn

}







data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/function.py"
  output_path = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.myfunction.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["https://joseportugalresume.com"]
  }

}
