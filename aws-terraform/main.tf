provider "aws" {
  //shared_config_files = "C:/Users/111/.aws/config"
  shared_credentials_file = "C:/Users/111/.aws/credentials"
  alias   = "source"
  profile = "source"
  region = "ap-northeast-1"
}

provider "docker" {
  
}

module "assume_role" {
  source = "./assume_role"
}

module "defaults" {
  source = "./instance"

  security_groups = [{
  from_port   = 22
  name        = "Ethernet"
  protocol    = "tcp"
  to_port     = 22
  cidr_blocks = ["111.243.187.126/32"]
  }, {
  from_port   = 80
  name        = "Port"
  protocol    = "tcp"
  to_port     = 80
  cidr_blocks = ["111.243.187.126/32"]
}, {
  from_port   = 3000
  name        = "Node"
  protocol    = "tcp"
  to_port     = 3000
  cidr_blocks = ["111.243.187.126/32"]
}
]

  ec2 = {
  instance_type     = "t2.micro"
  name              = "terraform"
  os_type           = "linux"
  volume_size       = 20
  volume_type       = "gp2"
  availability_zone = "ap-northeast-1c"
}

  ubuntu_ami = "ami-0b828c1c5ac3f13ee"
  linux_ami = "ami-0329eac6c5240c99d"
  assume_role_arn = module.assume_role.role_arn
  subnet_id = "subnet-02e649598a56e67f3"
  vpc_id = "vpc-0de8ee2b19f190cf5"
}