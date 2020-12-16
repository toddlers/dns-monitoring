data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../../lambda_src"
  output_path = "../../build/dns_resolution_lambda.zip"
}

resource "aws_lambda_function" "dns-resolution-lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "dns_resolution_monitoring"
  description      = "resolve and report the dns status"
  role             = aws_iam_role.dns-resolution-lambda-role.arn
  handler          = "main.handler"
  runtime          = "python3.8"
  timeout          = 30
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  tags = var.default_tags
  environment {
    variables = {
      DNS_ENDPOINTS = join(",", var.dns_endpoints)
    }
  }
}