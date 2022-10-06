resource "aws_instance" "this_ec2" {
  ami           = data.aws_ami.this_ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.this_key_pair.id
  vpc_security_group_ids = [aws_security_group.this_sg.id]
  subnet_id = aws_subnet.this_subnet.id
  user_data = file("docker.sh")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "this_ec2"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "this_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-subnet-pub1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-igw-1"
  }
}

resource "aws_route_table" "this_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-rt-pub1"
  }
}

resource "aws_route" "this_route" {
  route_table_id         = aws_route_table.this_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "this_rta" {
  subnet_id      = aws_subnet.this_subnet.id
  route_table_id = aws_route_table.this_route_table.id
}

resource "aws_security_group" "this_sg" {
  name        = "Allow this sg traffic"
  description = "Allow this_sg inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "this_sg"
  }
}

resource "aws_key_pair" "this_key_pair" {
  key_name   = "thiskey"
  public_key = file("~/.ssh/thiskey.pub")
}