module "dns-monitoring-eu-central-1" {
  source = "./../../dns-monitoring"
  providers = {
    aws = aws.prod-eu-central-1
  }
}