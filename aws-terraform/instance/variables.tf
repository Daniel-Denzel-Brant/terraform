variable "security_groups" {
  description = "The attribute of security_groups information"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "ec2" {
  description = "The attribute of EC2 information"
  type = object({
    name              = string
    os_type           = string
    instance_type     = string
    volume_size       = number
    volume_type       = string
    availability_zone = string
  })
}

variable "ubuntu_ami" {
  description = "ubuntu ami"
  type        = string
  //default     = "ami-04ff9e9b51c1f62ca"
}
variable "linux_ami" {
  description = "linux ami"
  type        = string
  //default     = "ami-0c802847a7dd848c0"
}

variable "assume_role_arn" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}
