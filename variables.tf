data "aws_ami" "latest_free_ami" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-202*-kernel-6.1-x86_64"]
  }
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}