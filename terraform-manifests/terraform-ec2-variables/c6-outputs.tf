output "instamce_public_ip" {
  description = "Ec2 instance public Ip"
  value = aws_instance.ec2-demo.public_ip
}


output "instamce_public_dns" {
  description = "Ec2 instance public dns"
  value = aws_instance.ec2-demo.public_dns
}