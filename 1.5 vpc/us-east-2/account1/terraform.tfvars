# Set the AWS region
aws_region  = "us-east-2"
aws_profile = "GDTTesting"
aws_alias   = "GDTTesting"

# Define environments for account 2
environments = {
  vpc1 = {
    aws_region = "us-east-2"
    cidr_vpc   = "10.20.0.0/16"
    tags = {
      Name        = "Gdttest"
      Environment = "Production"
      Owner       = "TeamB"
    }
    subpub1       = "10.20.1.0/24"
    az_sub_pub1   = "us-east-2a"
    subpub2       = "10.20.2.0/24"
    az_sub_pub2   = "us-east-2b"
    subpvt1       = "10.20.3.0/24"
    az_sub_pvt1   = "us-east-2a"
    subpvt2       = "10.20.4.0/24"
    az_sub_pvt2   = "us-east-2b"
    ingress_ports = [22, 80, 443]
    egress_ports  = [0]
  }
}
