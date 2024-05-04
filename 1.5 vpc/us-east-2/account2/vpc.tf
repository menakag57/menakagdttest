

module "vpc_account1" {
  source = "../../Child module"
  # for_each     = var.environments["account1"]
  environments = var.environments
  aws_region   = var.aws_region

  providers = {
    aws = aws

  }
}