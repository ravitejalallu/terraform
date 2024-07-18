resource "aws_security_group" "public_sg" {
  name = "Public Security Group"
  description = "Public internet access"

  tags = {
    Name        = "Security Group for Public Subnet"
    Teraform = "true"
  }
}

# rule for allowing all outgoing traffic
resource "aws_security_group_rule" "public_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public_sg.id

}

# rule for allowing ssh traffic for public sg
resource "aws_security_group_rule" "public_ssh_in" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public_sg.id
}

# rule for allowing http traffic for public sg
resource "aws_security_group_rule" "public_http_in" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public_sg.id
}

# rule for allowing https traffic for public sg
resource "aws_security_group_rule" "public_https_in" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public_sg.id
}