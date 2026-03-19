resource "aws_security_group" "SGJENS" {
  name   = "sg_jenkins"
  vpc_id = var.vpc_id
  tags   = {
    Name = "sg_jens",
    terraform = "true"
  }
}

resource "aws_security_group" "SGAPP" {
  name   = "sg_application"
  vpc_id = var.vpc_id
  tags   = {
    Name = "sg_apps",
    terraform = "true"
  }
}

resource "aws_security_group" "SGSEC" {
  name   = "sg_security"
  vpc_id = var.vpc_id
  tags   = {
    Name = "sg_sec",
    terraform = "true"
  }
}

resource "aws_security_group" "SGMOR" {
  name   = "sg_monitor"
  vpc_id = var.vpc_id
  tags   = {
    Name = "sg_mor",
    terraform = "true"
  }
}

resource "aws_security_group_rule" "INGRESS9000" {
  from_port         = 9000
  protocol          = "tcp"
  security_group_id = aws_security_group.SGSEC.id
  to_port           = 9000
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 9000 for Sonarqube GUI"
}


resource "aws_security_group_rule" "INGRESS8080" {
  from_port         = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.SGJENS.id
  to_port           = 8080
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 8080 for jenkins GUI"
}

resource "aws_security_group_rule" "INGRESS50000" {
  from_port         = 50000
  protocol          = "tcp"
  security_group_id = aws_security_group.SGJENS.id
  to_port           = 50000
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 50000 for jenkins GUI"
}


resource "aws_security_group_rule" "INGRESS5000" {
  from_port         = 5000
  protocol          = "tcp"
  security_group_id = aws_security_group.SGAPP.id
  to_port           = 5000
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 5000 for application"
}

resource "aws_security_group_rule" "INGRESS3306" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.SGAPP.id
  to_port           = 3306
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 3306 for mysql"
}

resource "aws_security_group_rule" "INGRESS3000" {
  from_port         = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.SGMOR.id
  to_port           = 3000
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 3000 for dashboard grafana"
}



resource "aws_security_group_rule" "INGRESS9090" {
  from_port         = 9090
  protocol          = "tcp"
  security_group_id = aws_security_group.SGMOR.id
  to_port           = 9090
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 9090 for grafana"
}

locals {
  target_sg_ids = {
    app = aws_security_group.SGAPP.id,
    jens = aws_security_group.SGJENS.id,
    mor = aws_security_group.SGMOR.id,
    sec = aws_security_group.SGSEC.id
  }
}

resource "aws_security_group_rule" "INGRESS22" {
  for_each = local.target_sg_ids
  from_port         = 22
  protocol          = "tcp"
  security_group_id = each.value
  to_port           = 22
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 22 for SSH"
}

resource "aws_security_group_rule" "INGRESS80" {
  for_each = local.target_sg_ids
  from_port         = 80
  protocol          = "tcp"
  security_group_id = each.value
  to_port           = 80
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 80"
}

resource "aws_security_group_rule" "INGRESS443" {
  for_each = local.target_sg_ids
  from_port         = 443
  protocol          = "tcp"
  security_group_id = each.value
  to_port           = 443
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 443"
}

resource "aws_security_group_rule" "INGRESS9100" {
  for_each = local.target_sg_ids
  from_port         = 9100
  protocol          = "tcp"
  security_group_id = each.value
  to_port           = 9100
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow port 9100 for node exporter"
}


resource "aws_security_group_rule" "ec2_egress_internet" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  for_each = local.target_sg_ids
  security_group_id = each.value
}

