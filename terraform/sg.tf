resource "aws_security_group" "kxc-fargate-sg" {
    name = "kxc-fargate-sg"
    vpc_id = aws_vpc.kxc-vpc.id

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "kxc-fargate-sg"
  }
}

resource "aws_security_group" "kxc-db-sg" {
    name = "kxc-db-sg"
    vpc_id = aws_vpc.kxc-vpc.id

    ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      security_groups = [aws_security_group.kxc-fargate-sg.id, aws_security_group.alb-sg.id]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "kxc-db-sg"
  }
}

resource "aws_security_group" "alb-sg" {
  name = "alb-sg"
  vpc_id = aws_vpc.kxc-vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-sg"
  }
}