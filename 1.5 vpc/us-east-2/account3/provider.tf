
# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "menakagdttest"
    key    = "account3_us-east-1/terraform.tfstate"
    region = "us-east-1"
    # For State Locking, LockID
    # dynamodb_table = "test-locking" 
  }
}
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  # alias   = var.aws_alias
}

provider "aws" {
  # alias = var.aws_alias
  alias   = "GDTTesting"
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  # alias = var.aws_alias
  alias   = "GDTSecurityHubTesting"
  region  = var.aws_region
  profile = var.aws_profile
}

