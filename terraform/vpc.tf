###############VPC##################
resource "aws_vpc" "global_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name     = "${var.environment}-${var.product}-global-vpc"
    resource = var.resource
    iac      = var.iac
  }
}
###############Subnets##################
resource "aws_subnet" "global_subnet_a" {
  vpc_id            = aws_vpc.global_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a" # Replace with your desired AZ
  tags = {
    Name     = "${var.environment}-${var.product}-frontend-public-subnet-a"
    resource = var.resource
    iac      = var.iac
  }
}
resource "aws_subnet" "global_subnet_b" {
  vpc_id            = aws_vpc.global_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.region}b" # Replace with your desired AZ
  tags = {
    Name     = "${var.environment}-${var.product}-frontend-public-subnet-b"
    resource = var.resource
    iac      = var.iac
  }
}


###############Rout Tables##################
resource "aws_route_table" "global_rt" {
  vpc_id = aws_vpc.global_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.global_igw.id
  }

  tags = {
    Name     = "${var.environment}-${var.product}-global-rt"
    resource = var.resource
    iac      = var.iac
  }
}

###############Subnets RT Associations##################
resource "aws_route_table_association" "global_subnetA_rt_association" {
  subnet_id      = aws_subnet.global_subnet_a.id
  route_table_id = aws_route_table.global_rt.id
}

resource "aws_route_table_association" "global_subnetB_rt_association" {
  subnet_id      = aws_subnet.global_subnet_b.id
  route_table_id = aws_route_table.global_rt.id
}

###############Security Groups##################
resource "aws_security_group" "global_sg" {
  name        = "${var.environment}-${var.product}-frontend-sg"
  description = "Allow SSH and HTTP from anywhere"
  vpc_id      = aws_vpc.global_vpc.id

  tags = {
    Name     = "${var.environment}-${var.product}-lambda-sg"
    resource = var.resource
    iac      = var.iac
  }
}


resource "aws_security_group_rule" "ingress-global_sg" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.global_sg.id
}

resource "aws_security_group_rule" "egress-global_sg" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.global_sg.id
}

resource "aws_security_group_rule" "egress-global_sg-internet" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.global_sg.id
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.global_vpc.id
  service_name      = "com.amazonaws.us-east-2.s3"   # The service name for S3 in us-east-2
  vpc_endpoint_type = "Gateway"                      # Set to Gateway for S3
  route_table_ids   = [aws_route_table.global_rt.id] # Associate with the provided route tables

  tags = {
    Name = "lambda-to-s3-backup-endpoint"
  }
}

resource "aws_internet_gateway" "global_igw" {
  vpc_id = aws_vpc.global_vpc.id
  tags = {
    Name     = "${var.environment}-${var.product}-backend-igw"
    resource = var.resource
    iac      = var.iac
  }
}