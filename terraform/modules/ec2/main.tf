resource "aws_key_pair" "KEY" {
  key_name = "DevSecOps"
  public_key = var.public_key
}

resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_jens_id]
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
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
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_app_id]
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = {
    Name = "App_Server",
    terraform = "true"
  }
}

resource "aws_eip_association" "eip_assoc_app" {
  instance_id   = aws_instance.app_server.id
  allocation_id = var.eip_app_id
}

resource "aws_iam_role" "security_vm_role" {
  name = "security-vm-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.security_vm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "security_vm_profile" {
  name = "security-vm-instance-profile"
  role = aws_iam_role.security_vm_role.name
}

resource "aws_instance" "security_server" {
  ami           = var.ami_id
  instance_type = "t3.large"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_sec_id]
  iam_instance_profile = aws_iam_instance_profile.security_vm_profile.name
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
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
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.KEY.key_name
  vpc_security_group_ids = [var.sg_mor_id]
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = {
    Name = "Monitor_Server",
    terraform = "true"
  }
}

resource "aws_eip_association" "eip_assoc_mor" {
  instance_id   = aws_instance.monitor_server.id
  allocation_id = var.eip_mor_id
}