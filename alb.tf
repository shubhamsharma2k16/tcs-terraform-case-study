resource "aws_lb_target_group" "case_study_tg" {
  name        = "tcs-tf-case-study-tg"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"
  port        = var.http_port
  protocol    = "HTTP"
  tags        = var.mandatory_tags
}

resource "aws_lb_target_group_attachment" "case_study_tg_attchment" {
  for_each = {
    for k, v in aws_instance.servers :
    k => v
  }
  target_group_arn = aws_lb_target_group.case_study_tg.arn
  target_id        = each.value.id
  depends_on       = [aws_instance.servers]
}

resource "aws_lb" "case_study_alb" {
  name               = "tcs-tf-case-study-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = slice(data.aws_subnets.example.ids, 0, 2)
  depends_on         = [aws_lb_target_group_attachment.case_study_tg_attchment]
  tags               = var.mandatory_tags
  
}