resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraformVpc"
  }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "InternetGateway"
  }
}
#---------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.public.id
}
#---------------
resource "aws_instance" "server" {
  ami                    = data.aws_ami.latest_free_ami.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.publicsubnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data = file("instructions.sh")
}
resource "aws_security_group" "my_security_group" {
  name        = "Dynamic-my-security-group"
  description = "My Security Group"
  vpc_id      = aws_vpc.myvpc.id
  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraformVpc"
  }
}