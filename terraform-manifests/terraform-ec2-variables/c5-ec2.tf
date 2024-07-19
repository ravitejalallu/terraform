resource "aws_instance" "ec2-demo" {
  ami           = data.aws_ami.amzLinux2.id
  instance_type = var.instance_type
  user_data = file("${path.module}/lampstack.sh")
  key_name = var.instance_key_pair
  vpc_security_group_ids = [ aws_security_group.public_sg.id ]


  tags = {
    Name = "my-demo-ec2"
  }
}