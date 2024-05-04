# Set the AWS region
aws_region  = "us-east-2"
aws_profile = "GDTSecurityHubTesting"
aws_alias   = "GDTSecurityHubTesting"

# Define environments for account 3
environments = {
  vpc1 = {
    aws_region = "us-east-2"
    cidr_vpc   = "10.30.0.0/16"
    tags = {
      Name        = "Gdttest"
      Environment = "Production"
      Owner       = "TeamC"
    }
    subpub1       = "10.30.1.0/24"
    az_sub_pub1   = "us-east-2a"
    subpub2       = "10.30.2.0/24"
    az_sub_pub2   = "us-east-2b"
    subpvt1       = "10.30.3.0/24"
    az_sub_pvt1   = "us-east-2a"
    subpvt2       = "10.30.4.0/24"
    az_sub_pvt2   = "us-east-2b"
    ingress_ports = [22, 80, 443]
    egress_ports  = [0]
  }
}
