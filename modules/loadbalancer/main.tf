resource "aws_security_group" "load-balancer" {
  name        = "${var.name}-${var.env}-lb-sg"
  description = "${var.name}-${var.env}-lb-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = var.allow_lb_sg_cidr
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = var.allow_lb_sg_cidr
  }

  tags = {
    Name = "${var.name}-${var.env}-lb-sg"
  }
}


# this creates 2 LB private and public
#LB properties starts here
#creating application internal load balancer for each application component
#creates multiple internal lb based asg variable true or false for backend components
resource "aws_lb" "lb" {
  #this lb should be created when asg is created
  # count = var.asg ? 1 : 0  #if var.asg is false then 0(create) else 1(dont create) 0-false 1-true
  name               = "${var.name}-${var.env}"
  internal           = var.internal
  load_balancer_type = "application"
  #security_groups    = [aws_security_group.lb.*.id[count.index]]
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = var.subnet_ids

  #   #enable_deletion_protection = true
  #
  # #   access_logs {
  # #     bucket  = aws_s3_bucket.lb_logs.id
  # #     prefix  = "test-lb"
  # #     enabled = true
  # #   }
  #
  tags = {
    Environment = "${var.name}-${var.env}-alb-sg"
  }
}