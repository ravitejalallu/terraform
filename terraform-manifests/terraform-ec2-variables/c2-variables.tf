variable "aws_region" {
    description = "Region in which aws resource need to be created"
    type = string
    default = "us-east-2"
  
}

variable "instance_type" {
    description = "decribes EC2 instance type"
    type = string
    default = "t2.micro"  
}

variable "instance_key_pair" {
  description = "AWS EC2 key pair that should get attached to the EC2 instamce"
  type = string
  default = "mytestkeypair"
}