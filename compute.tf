resource "aws_security_group" "kubernetes" {
  name        = "rbac-group"
  description = "An rbac security group"
  vpc_id      = "vpc-08887a581a5885997" # Replace with your VPC ID

  # Inbound rules
  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #use this ports to run applications
  ingress {
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #ssl or https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #kubernetes api
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #jenkins mail notif
  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #mongo db
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # deploy application
  ingress {
    from_port   = 30000
    to_port     = 32768
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubernetes-security-group"
  }
}


resource "aws_instance" "my_instance" {
  ami                    = "ami-0522ab6e1ddcc7055"
  instance_type          = "t2.medium"
  user_data              = file("kubernetes.sh")
  key_name               = "EC2_FIRST"
  count                  = 5
  vpc_security_group_ids = [aws_security_group.kubernetes.id]

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp3"
  }
  tags = {
    Name = "kubernetesClusterrbac-${count.index}"
  }
}