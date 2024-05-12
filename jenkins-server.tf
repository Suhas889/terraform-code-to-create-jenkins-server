data "aws_ami" "latest-ubuntu-linux-image" {
  most_recent = true
  owners      = ["AWS"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-20.08-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.latest-ubuntu-linux-image.id
  instance_type               = var.instance_type
  key_name                    = "suhas-key"
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("jenkins-server-script.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}
