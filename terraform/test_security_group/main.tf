resource "aws_security_group_rule" "ingress" {
    type                     = "ingress"
    from_port                = "9999"
    to_port                  = "9999"
    protocol                 = "tcp"
    cidr_blocks              = ["208.0.0.0/8"]
    security_group_id        = "sg-12ab3456"
#    security_group_id        = "${aws_security_group.this.id}"

}

    
