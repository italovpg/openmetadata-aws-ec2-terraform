#Create and bootstrap webserver
resource "aws_instance" "webserver" {
  ami                         = data.aws_ami.amazon_linux_3.id
  instance_type               = "t2.xlarge"
  key_name                    = aws_key_pair.webserver-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_ec2.id]
  subnet_id                   = aws_subnet.subnet.id
  user_data = <<-EOF
              #!/bin/sh
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
              sudo dnf install libxcrypt-compat -y
              sudo chmod +x /usr/local/bin/docker-compose
              sudo yum install wget -y
              wget https://github.com/open-metadata/OpenMetadata/releases/download/1.2.0-release/docker-compose.yml
              docker-compose -f ./docker-compose.yml up
              EOF
  tags = {
    Name = "webserver"
  }
}
