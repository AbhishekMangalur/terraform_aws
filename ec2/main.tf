resource "aws_security_group" "nginx_sg" {
  name   = "nginx-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public EC2 (NGINX)
resource "aws_instance" "public_vm" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"

  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = { Name = "Public-Nginx-VM" }
}

# Private EC2
resource "aws_instance" "private_vm" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"

  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = { Name = "Private-VM" }
}