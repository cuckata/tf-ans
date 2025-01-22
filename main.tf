#provider config

provider "aws" {
  region = "eu-central-1"
}

#create vpc
resource "aws_vpc" "main" {
    cidr_block              = "10.0.0.0/16"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    tags = {
        Name = "main-vpc"
    }
}

#create subnet
resource "aws_subnet" "public" {
    vpc_id                      = aws_vpc.main.id
    cidr_block                  = "10.0.1.0/24"
    map_public_ip_on_launch     = true
    availability_zone           = "eu-central-1b"
    tags = {
        Name = "public-subnet"
    }
}

#create gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main_igw"
    }
}

#create route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "public-route-table"
    }
}

#add route to gateway
resource "aws_route" "internet_access" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

#associate route table with subnet
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

#create security group
resource "aws_security_group" "web_sg" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "web-sg"
    }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.5.142.99/32"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  ami = "ami-07eef52105e8a2059"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name = "MyTfKey"

  tags = {
    Name = "Ec2TF${random_string.random.result}"
  }
}

output "instance" {
  value = aws_instance.web.tags.Name
}

output "public_ip" {
    value = aws_instance.web.public_ip
}

output "private_ip" {
    value = aws_instance.web.private_ip
}