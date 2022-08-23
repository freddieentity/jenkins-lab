# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

data "aws_availability_zones" "aaz" {
}

resource "aws_subnet" "public" {
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 0 + 1)
  availability_zone       = data.aws_availability_zones.aaz.names[0]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
}

resource "aws_instance" "jenkins" {
  ami           = "ami-08d4ac5b634553e16"
  instance_type = "t3.medium"
  user_data = file("${path.module}/scripts/jenkins_setup.sh")
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name = var.key_name

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Jenkins UI and SSH allowed"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Jenkins UI"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins"
  }
}