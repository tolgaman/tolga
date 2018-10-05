resource "aws_vpc" "vpcT1" {
  cidr_block = "10.10.0.0/16"
  tags {
    Name = "VPCT1"
  } 
}

resource "aws_subnet" "subnetT1" {
   vpc_id       = "${aws_vpc.vpcT1.id}"
   cidr_block   = "10.10.1.0/24"
   availability_zone = "us-east-1a"
   map_public_ip_on_launch = "true"
   tags {
     Name = "SubnetT1"
   }
}

resource "aws_subnet" "subnetT2" {
   vpc_id       = "${aws_vpc.vpcT1.id}"
   cidr_block   = "10.10.2.0/24"
   availability_zone = "us-east-1c"
   map_public_ip_on_launch = "true"
   tags {
     Name = "SubnetT2"
   }
}



resource "aws_internet_gateway" "igwT1" {
   vpc_id = "${aws_vpc.vpcT1.id}"
   tags {
     Name = "internet-gateway-T1"
   }
}

resource "aws_route_table" "RouteTableT1" {
vpc_id = "${aws_vpc.vpcT1.id}"
route {
cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.igwT1.id}"
}
tags {
  Name = "aws_route_T1"
}
}

resource "aws_route_table_association"  "association-subnet" {
subnet_id = "${aws_subnet.subnetT1.id}"
route_table_id = "${aws_route_table.RouteTableT1.id}"
}


resource "aws_security_group" "secgrpT1" {
name = "secgrpT1"
vpc_id = "${aws_vpc.vpcT1.id}"
ingress {
from_port = 8000
to_port = 8000
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_security_group_rule" "ssh" {
security_group_id = "${aws_security_group.secgrpT1.id}"
type = "ingress"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["208.176.44.26/32"]
}

resource "aws_security_group_rule" "egress2all" {
security_group_id = "${aws_security_group.secgrpT1.id}"
type = "egress"
from_port = 0
to_port = 65535
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


output "vpc-id" {
value = "${aws_vpc.vpcT1.id}"
}

resource "aws_instance" "cloudmapper1" {
ami = "ami-04681a1dbd79675a5"
instance_type = "t3.medium"
vpc_security_group_ids = ["${aws_security_group.secgrpT1.id}"]
subnet_id = "${aws_subnet.subnetT1.id}"
key_name = "test-key-pair"

user_data = <<EOF
#!/bin/bash
sudo echo hello > /root/hello
sudo /bin/yum clean all
sudo /bin/yum update -y 
EOF

tags {
 Name = "cloudmapperT1"
}
}

output "public_ip" {
value = "${aws_instance.cloudmapper1.public_ip}"
}

