# Create VPC, internet gateway, and subnets for each environment

resource "aws_vpc" "myvpc" {
  for_each = var.environments

  cidr_block       = each.value.cidr_vpc
  instance_tenancy = "default"
  tags             = each.value.tags
  
}

resource "aws_internet_gateway" "tigw" {
  for_each = var.environments

  vpc_id = aws_vpc.myvpc[each.key].id
  tags   = each.value.tags
}

resource "aws_subnet" "pubsub1" {
  for_each = var.environments

  vpc_id            = aws_vpc.myvpc[each.key].id
  cidr_block        = each.value.subpub1
  availability_zone = each.value.az_sub_pub1
  tags              = each.value.tags
}

resource "aws_subnet" "pubsub2" {
  for_each = var.environments

  vpc_id            = aws_vpc.myvpc[each.key].id
  cidr_block        = each.value.subpub2
  availability_zone = each.value.az_sub_pub2
  tags              = each.value.tags
}

resource "aws_subnet" "pvtsub1" {
  for_each = var.environments

  vpc_id            = aws_vpc.myvpc[each.key].id
  cidr_block        = each.value.subpvt1
  availability_zone = each.value.az_sub_pvt1
  tags              = each.value.tags
}

resource "aws_subnet" "pvtsub2" {
  for_each = var.environments

  vpc_id            = aws_vpc.myvpc[each.key].id
  cidr_block        = each.value.subpvt2
  availability_zone = each.value.az_sub_pvt2
  tags              = each.value.tags
}
resource "aws_route_table" "pubrt1" {
  for_each = var.environments

  vpc_id = aws_vpc.myvpc[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tigw[each.key].id
  }

  tags = each.value.tags
}

resource "aws_route_table" "pubrt2" {
  for_each = var.environments

  vpc_id = aws_vpc.myvpc[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tigw[each.key].id
  }

  tags = each.value.tags
}

resource "aws_route_table" "pvtrt1" {
  for_each = var.environments

  vpc_id = aws_vpc.myvpc[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pvtnat1[each.key].id
  }

  tags = each.value.tags
}

resource "aws_route_table" "pvtrt2" {
  for_each = var.environments

  vpc_id = aws_vpc.myvpc[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pvtnat1[each.key].id
  }

  tags = each.value.tags
}

# Create EIPs
resource "aws_eip" "eip1" {
  for_each = var.environments

  vpc = true
}

resource "aws_eip" "eip2" {
  for_each = var.environments

  vpc = true
}

# Create NAT Gateways
resource "aws_nat_gateway" "pvtnat1" {
  for_each = var.environments

  allocation_id = aws_eip.eip1[each.key].id
  subnet_id     = aws_subnet.pubsub1[each.key].id

  tags = each.value.tags
}

resource "aws_nat_gateway" "pvtnat2" {
  for_each = var.environments

  allocation_id = aws_eip.eip2[each.key].id
  subnet_id     = aws_subnet.pubsub2[each.key].id

  tags = each.value.tags
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "pubasc1" {
  for_each = var.environments

  subnet_id      = aws_subnet.pubsub1[each.key].id
  route_table_id = aws_route_table.pubrt1[each.key].id
}

resource "aws_route_table_association" "pubasc2" {
  for_each = var.environments

  subnet_id      = aws_subnet.pubsub2[each.key].id
  route_table_id = aws_route_table.pubrt2[each.key].id
}

resource "aws_route_table_association" "pvtasc1" {
  for_each = var.environments

  subnet_id      = aws_subnet.pvtsub1[each.key].id
  route_table_id = aws_route_table.pvtrt1[each.key].id
}

resource "aws_route_table_association" "pvtasc2" {
  for_each = var.environments

  subnet_id      = aws_subnet.pvtsub2[each.key].id
  route_table_id = aws_route_table.pvtrt2[each.key].id
}

# Create Security Groups
resource "aws_security_group" "pub-seg" {
  for_each = var.environments

  name        = "pub-seg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.myvpc[each.key].id

  dynamic "ingress" {
    for_each = each.value.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = each.value.tags
}

resource "aws_security_group" "pvt-seg" {
  for_each = var.environments

  name        = "pvt-seg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.myvpc[each.key].id

  ingress {
    description     = "Allow inbound traffic from public subnet"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.pub-seg[each.key].id]
  }

  dynamic "ingress" {
    for_each = each.value.ingress_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.pub-seg[each.key].id]
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_ports
    content {
      from_port       = egress.value
      to_port         = egress.value
      protocol        = "-1"
      security_groups = [aws_security_group.pub-seg[each.key].id]
    }
  }

  tags = each.value.tags
}