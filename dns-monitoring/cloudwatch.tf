data "aws_iam_account_alias" "current" {}

resource "aws_cloudwatch_event_rule" "run-dns-resolution-lambda" {
  name                = "run-dns-resolution-lambda"
  description         = "execute dns resolution lambda"
  schedule_expression = lookup(var.AutoStopSchedule, var.schedule_expression)
  depends_on          = [aws_lambda_function.dns-resolution-lambda]
  tags = var.default_tags
}


resource "aws_cloudwatch_metric_alarm" "sensu-alarm" {
  count               = length(var.dns_endpoints)
  alarm_name          = format("%s-dns-resolution-%s", data.aws_iam_account_alias.current.account_alias, count.index)
  dimensions          = { endpoint = element(var.dns_endpoints, count.index) }
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  namespace           = "DNSMonitoring"
  metric_name         = "ResolutionCount"
  threshold           = 1
  period              = 300
  treat_missing_data  = "missing"
  statistic           = "Sum"
  tags                = var.default_tags
  alarm_description   = "dns check failing"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.dns_status_updates.arn]
  ok_actions          = [aws_sns_topic.dns_status_updates.arn]
}