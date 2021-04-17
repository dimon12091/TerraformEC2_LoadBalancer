terraform {
  required_version = "> 0.13.0"
}

#(AWS) provider is used to interact with the many resources supported by AWS
provider "aws" {
  region = "us-east-2"
}

#This is a simple Terraform module for calculating subnet addresses under a particular CIDR prefix.
module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"
  base_cidr_block = "10.0.1.0/24"
  networks = [
    { name = "us-east-2a", new_bits = 1 },
    { name = "us-east-2b", new_bits = 1 },
  ]
}

#Provides a VPC resource.
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"


  tags = {
    Name = "main-test"
  }
}

#Provides a resource "aws_subnet"
resource "aws_subnet" "my_subnets" {
  for_each = module.subnet_addrs.network_cidr_blocks

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value
}


#Provides a resource to create a VPC Internet Gateway.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
  depends_on = [aws_vpc.main]
}

#Provides a resource to manage a default route table of a VPC. This resource can manage the default route table of the default or a non-default VPC.
resource "aws_default_route_table" "r" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "default table"
  }
}



#Provides a resource to create an association between a route table and a subnet or a route table and an internet gateway or virtual private gateway.
resource "aws_route_table_association" "associations" {
  for_each = data.aws_subnet_ids.task_subnets.ids
  subnet_id      = each.value
  route_table_id = aws_default_route_table.r.id
  depends_on = [
    aws_subnet.my_subnets
  ]
}


#Provides a resource to create a routing table entry (a route) in a VPC routing table.
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_default_route_table.r.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  depends_on                = [aws_internet_gateway.gw]

}
 
 
 
 #Provides a security group resource. I allow all traffic
resource "aws_security_group" "allow_rdp_http" {
  name        = "allow_all_traffic"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = -1
    to_port     = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  

  tags = {
    Name = "allow_trafic"
  }
}

# provides a set of ids for a vpc_id
#This resource can be useful for getting back a set of subnet ids for a vpc.
data "aws_subnet_ids" "task_subnets" {
  vpc_id = aws_vpc.main.id
}

data "aws_subnet" "task_subnet" {
  for_each = data.aws_subnet_ids.task_subnets.ids
  id       = each.value
}

#Provides a Network Load Balancer resource
resource "aws_lb" "global_test_lb" {
  name               = "network-global-test"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.task_subnets.ids
  enable_cross_zone_load_balancing = true

  depends_on = [
    aws_internet_gateway.gw
  ]
}

#Provides a Load Balancer Listener resource. Network Load Balancers must use the TCP protocol.
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.global_test_lb.arn
  port              = "80"
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.global_test.arn

  }
}

#Provides a Target Group resource for use with Load Balancer resources.
resource "aws_lb_target_group" "global_test" {
  name     = "target-group-lb-global"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
  health_check {
    port     = 80
    protocol = "TCP"
  }
}

#Provides an EC2 instance resource for each AZ
resource "aws_instance" "win" {
  for_each = data.aws_subnet_ids.task_subnets.ids
  ami           = "ami-0db6a09e9ade44bb3"
  instance_type = "t2.micro"
  #You must have key_pair in folder
  key_name      = "key_pair1"
  associate_public_ip_address = true
  vpc_security_group_ids=[aws_security_group.allow_rdp_http.id]
  subnet_id = each.value
  get_password_data = true
  user_data = <<-EOF
              <powershell>
              Enable-NetFirewallRule -All
              Import-Module ServerManager
              Set-NetFirewallRule -Name “WINRM-HTTP-In-TCP-PUBLIC” -RemoteAddress “Any”
              Enable-PSRemoting –force
              </powershell>
              EOF
 
  tags = {
    Name = "Windows_Server"
  }
}


output "instance_info_ips" {
  value = tomap({
    for k, win in aws_instance.win : k => win.public_ip
  })

}

output "instance_info" {
  value = ({
    for k, win in aws_instance.win : k => rsadecrypt(win.password_data, file("bootstrap/key_pair1.pem"))
  })

}

#Provides the ability to register instances and containers with an Network Load Balancer (NLB) target group
resource "aws_lb_target_group_attachment" "global_test_attachment" {
  for_each = tomap({
    for k, win in aws_instance.win : k => win.id
  })
  target_group_arn = aws_lb_target_group.global_test.arn
  target_id        = each.value
  port             = 80
}

