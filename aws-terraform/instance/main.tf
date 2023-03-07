provider "aws" {
  region  = "ap-northeast-1"
  profile = "source"
  
  assume_role {
    role_arn     = var.assume_role_arn
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "id-rsa-public"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1+ZbpnVVtvD4dXUhZeShIE3plR7PZd9OjKk5arN60BRvlJ8Qbvo0jJH/wl2YA4sjTowkuVpwBIFt7PBJhI2TKmPoR4FCBcE4rucuLQ7d/JofsNh7xlUg8iJ6q3PEXyn+9c2lYZPbvXEwS33w75zYIxLYK+bUtqxxW+SCkWHGPsLTPCvZy33WYG2kjoquNdYZKCH23njEGp1IeSb+dpCK3CetDEJ6Pcm8/eSCkouGONYi7V8x+RqoVXlc2fkxBQF8hpl2qjly/v38YWXUTFNI4ygneWzjt/Hd7o5ZvyzRJrTNqz9vd1sG7ozEEBfYMBPephO6dr9PU6iY7ARCSMLHndz8hiuQusvI9riPLV/84YF0AMQAu2McOhxiImejXfvRITiBOZWW+lgqc9cNytAqQLke3jroyFdq0d5dt1fYsPzdz/xHfWif8piGIEKtkxy7mNK5ehf09xThd8SGv/roS1uoAxjvzXpbX6emYyI8k/3/KGPUvC8M096V68EBJDP0="
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "subnet" {
  tags = {
    Subnet = "1"
  }
}

resource "aws_instance" "instance" {
  for_each                    = toset(data.aws_subnets.subnets.ids)
  ami                         = var.ec2.os_type == "linux" ? var.linux_ami : var.ubuntu_ami
  availability_zone           = var.ec2.availability_zone
  instance_type               = var.ec2.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = each.value
  key_name                    = aws_key_pair.deployer.id
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.ec2.volume_size
    volume_type           = var.ec2.volume_type
  }
  user_data = file("templates/${var.ec2.os_type}.sh")
}

resource "aws_security_group" "sg" {
  description = "test sg for terraform"
  vpc_id      = var.vpc_id
  //ingress {
    //description = "Laptop Outbount IP"
    //from_port   = 22
    //to_port     = 22
    //protocol    = "tcp"
    //cidr_blocks = ["172.31.0.0/20"]
  //}
  dynamic "ingress" {
    for_each = var.security_groups
    content {
      description = ingress.value["name"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}