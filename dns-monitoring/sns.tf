resource "aws_sns_topic" "dns_status_updates" {
  name = var.sns_topic_name
  tags = var.default_tags
}