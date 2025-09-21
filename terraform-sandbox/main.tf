provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "sandbox" {
  ami           = "ami-0c02fb55956c7d316" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]
  key_name      = "keypair1" 

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 80:3000 kiss14/sandbox-app:latest
              EOF

  tags = {
    Name = "sandbox-app"
  }
}

resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = "vpc-065200cfc26c9e948"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP"
    from_port   = 5000
    to_port     = 5000
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

