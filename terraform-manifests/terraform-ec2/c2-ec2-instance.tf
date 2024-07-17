resource "aws_instance" "ec2-demo" {
  ami           = "ami-0649bea3443ede307"
  instance_type = "t2.micro"
  user_data = file("${path.module}/webserver.sh")

  tags = {
    Name = "my-demo-ec2"
  }
}
