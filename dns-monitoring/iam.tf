resource "aws_iam_role" "dns-resolution-lambda-role" {
  name               = "dns_resolution_lambda"
  tags = var.default_tags
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

data "aws_iam_policy_document" "dns-resolution-allow-put-metric" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "dns-resolution-lambda-policy" {
  name   = "dns-resolution-allow-put-metric"
  path   = "/"
  policy = data.aws_iam_policy_document.dns-resolution-allow-put-metric.json
}

resource "aws_iam_role_policy_attachment" "dns-resolution-lambda-access" {
  role       = aws_iam_role.dns-resolution-lambda-role.name
  policy_arn = aws_iam_policy.dns-resolution-lambda-policy.arn
}



resource "aws_iam_role_policy_attachment" "basic-exec-role" {
  role       = aws_iam_role.dns-resolution-lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_file" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dns-resolution-lambda.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.run-dns-resolution-lambda.arn
}