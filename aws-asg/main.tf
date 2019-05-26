terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Subnet1"
  }
}

resource "aws_launch_configuration" "web_conf" {
  name_prefix   = "webserver-"
  image_id      = "ami-07a0c6e669965bb7c"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name = "jchen-lab"
  user_data = templatefile("init.tpl", {})
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3-terraform-test"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  launch_configuration      = "${aws_launch_configuration.web_conf.name}"
  vpc_zone_identifier       = ["${aws_subnet.public_subnet_1.id}"]

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }
}