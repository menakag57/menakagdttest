variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "aws_profile" {
  description = "The AWS profile to use."
  type        = string
}
variable "aws_alias" {
  description = "The alias for the AWS provider."
  type        = string
}


variable "environments" {
  description = "A map of environments with their configurations"
  type = map(object({
    aws_region = string
    # aws_profile   = string
    cidr_vpc      = string
    tags          = map(string)
    subpub1       = string
    az_sub_pub1   = string
    subpub2       = string
    az_sub_pub2   = string
    subpvt1       = string
    az_sub_pvt1   = string
    subpvt2       = string
    az_sub_pvt2   = string
    ingress_ports = list(number)
    egress_ports  = list(number)
  }))
}
