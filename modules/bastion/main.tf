# resource "aws_network_interface" "bastion_nic" {
#   subnet_id       = var.public_subnets[0]
#   # security_groups = [aws_security_group.jenkins_sg.id]

#   tags = {
#     Name = "bastion_host_nic"
#   }
# }

resource "aws_instance" "bastion_host" {
  ami           = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  key_name = "ec2"
  subnet_id = var.public_subnet_id[0]
  # network_interface {
  #   network_interface_id = aws_network_interface.bastion_nic.id
  #   device_index         = 0
  # }
  tags = {
    Name = "bastion host"
  }
}