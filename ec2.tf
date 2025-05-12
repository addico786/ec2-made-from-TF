resource "aws_key_pair" "practice" {
  key_name = "practice-1"  
  public_key = file("practice-1.pub")
}


resource "aws_default_vpc" "default" {   
}


resource "aws_security_group" "practice_security" {
    name = "practice"
    vpc_id = aws_default_vpc.default.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "open SSH"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "HTTP open"

    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "everywhere "

    }

    tags = {
        Name = "practice-security-group"
    }

  
}



resource "aws_instance" "just-for-practice" {
    for_each =tomap({
        practice-instance1 = "t3.micro"
        practice-instance2 = "t3.micro"
    })
    key_name = aws_key_pair.practice.key_name
    security_groups = [ aws_security_group.practice_security.name ]
    instance_type = var.env == "prd" ? each.value : var.instance_type
    ami = var.ami


    root_block_device {
      volume_size = var.env == "prd" ? 15 : var.volume_size
      volume_type = var.volume_type
    }

    tags = {
        Name = each.key
    }
  
}