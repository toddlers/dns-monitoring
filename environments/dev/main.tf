module "dns-monitoring-eu-central-1" {
  source = "./../../dns-monitoring"
  providers = {
    aws = aws.dev-eu-central-1
  }
}