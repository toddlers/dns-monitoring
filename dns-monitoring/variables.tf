variable "aws_region" {
  type    = string
  default = "us-east-1"
}


variable "schedule_expression" {
  default     = "3"
  description = "the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
}
variable "AutoStopSchedule" {
  default = {
    "1" = "cron(30 * * * ? *)"
    "2" = "cron(0 */1 * * ? *)"
    "3" = "cron(0 */1 * * ? *)"
    "4" = "cron(0 */12 * * ? *)"
    "5" = "cron(0 10 * * ? *)"
  }
}

# update the below list for dns endpoint private or public
variable "dns_endpoints" {
  type = list(any)
  default = [
    "google.com",
    "gmail.com",
    "linkedin.com",
  ]
}

variable "default_tags" {
  type = map(any)
  default = {
    Product     = "DNS"
    Environment = "prod"
    Application = "dns-monitoring"
  }
}

variable "slack_channel" {
  type    = string
  default = "ips-cloud-monitoring-prod"

}

variable "sensu_client_name" {
  type    = string
  default = "ips-cloud"
}

variable "sns_topic_name" {
  type = string
  default = "dns-monitoring-alerts"
}