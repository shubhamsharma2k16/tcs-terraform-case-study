resource "aws_security_group" "ec2_sg" {
  name = "tcs-terraform-case-study-sg"
  tags = var.mandatory_tags
}

resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_http" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
  cidr_ipv4         = var.public_cidr
}

resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_https" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = var.https_port
  ip_protocol       = "tcp"
  to_port           = var.https_port
  cidr_ipv4         = var.public_cidr
}
resource "aws_vpc_security_group_egress_rule" "ec2_sg_egress_http" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.public_cidr
  ip_protocol       = "-1"
}


resource "aws_instance" "servers" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.example.ids[count.index]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("userdata/${count.index}.sh")
  tags                   = merge(var.mandatory_tags, { Name = "tcs-terraform-case-study-server-${var.instance_name[count.index]}" })
}