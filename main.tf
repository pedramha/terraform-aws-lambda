provider "aws" {
  region = var.region
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "test"
  length = 4
}


resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  acl    = "private"
    tags = {
    "env" = "test"
  }
}

data "archive_file" "lambdaFunc_lambda_bucket" {
  type = "zip"

  source_dir  = var.src_path
  output_path = var.target_path
}

resource "aws_s3_bucket_object" "lambdaFunc_lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = var.target_path
  source = data.archive_file.lambdaFunc_lambda_bucket.output_path

  etag = filemd5(data.archive_file.lambdaFunc_lambda_bucket.output_path)
    tags = {
    "env" = "test"
  }
}

resource "aws_lambda_function" "lambdaFunc" {
  function_name = var.function_name

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambdaFunc_lambda_bucket.key

  runtime = var.lambda_runtime
  handler = var.handler

  source_code_hash = data.archive_file.lambdaFunc_lambda_bucket.output_base64sha256

  role                           = aws_iam_role.lambda_exec.arn
  reserved_concurrent_executions = var.concurrent_executions
  tags = {
    "env" = "test"
  }
}

resource "aws_lambda_alias" "con_lambda_alias" {
  name             = "lambda_alias"
  description      = "for blue green deployments OR for concurrency"
  function_name    = aws_lambda_function.lambdaFunc.arn
  function_version = var.function_version
}

resource "aws_lambda_provisioned_concurrency_config" "config" {
  function_name                     = aws_lambda_alias.con_lambda_alias.function_name
  provisioned_concurrent_executions = var.provisioned_concurrent_executions
  qualifier                         = aws_lambda_alias.con_lambda_alias.name
}


resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}