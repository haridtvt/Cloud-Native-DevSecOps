resource "aws_key_pair" "KEY" {
  key_name = "DevSecOps"
  public_key = var.public_key
}

resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = "t3.small"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_jens_id]
  tags = {
    Name = "Jenkins_Server",
    terraform = "true"
  }
}

resource "aws_eip_association" "eip_assoc_jens" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = var.eip_jens_id
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = "t3.small"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_app_id]
  tags = {
    Name = "App_Server",
    terraform = "true"
  }
}

resource "aws_eip_association" "eip_assoc_app" {
  instance_id   = aws_instance.app_server.id
  allocation_id = var.eip_app_id
}

resource "aws_instance" "security_server" {
  ami           = var.ami_id
  instance_type = "t3.large"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_sec_id]
  tags = {
    Name = "Security_Server",
    terraform = "true"
  }
}

resource "aws_eip_association" "eip_assoc_sec" {
  instance_id   = aws_instance.security_server.id
  allocation_id = var.eip_sec_id
}

resource "aws_instance" "monitor_server" {
  ami           = var.ami_id
  instance_type = "t3.small"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_mor_id]
  tags = {
    Name = "Monitor_Server",
    terraform = "true"
  }
}

resource "aws_eip_association" "eip_assoc_mor" {
  instance_id   = aws_instance.monitor_server.id
  allocation_id = var.eip_mor_id
}