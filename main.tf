provider "aws" {

  region = "eu-north-1"

}

resource "aws_security_group" "ec2_sg" {

  name = "ec2-cw-sg"

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



resource "aws_instance" "monitor_ec2" {

  ami                         = "ami-0453f2bc6c82c9bb6" 

  instance_type               = var.instance_type

  key_name                    = var.key_name

  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  associate_public_ip_address = true

  tags = {

    Name = "cloudwatch-monitor-ec2"

  }

}



resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {

  alarm_name          = "ec2-cpu-utilization-alarm"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 1

  metric_name         = "CPUUtilization"

  namespace           = "AWS/EC2"

  period              = 60

  statistic           = "Average"

  threshold           = 10

  alarm_description   = "Alarm when EC2 CPU exceeds 10%"

  dimensions = {

    InstanceId = aws_instance.monitor_ec2.id

  }

}
