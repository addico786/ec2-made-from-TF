# key pair (login)
resource "aws_key_pair" "my_key" {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

# VPC & security group
resource "aws_default_vpc" "default" {

  
}

resource "aws_security_group" "my_security_group" {
    name = "terraform-sg"
    description = "this will add a tf generated security group"
    vpc_id = aws_default_vpc.default.id # interpolation

    #inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "SSH open"
    }
    
    ingress  {
        from_port = 80 
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "node-app"
    }

    #outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "all access open outbound"
    }


    tags = {
      Name = "automate-sg"
    }
  
}

# ec2 instance

resource "aws_instance" "new_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [ aws_security_group.my_security_group.name ]
    instance_type = "t3.micro"
    ami = "ami-0dd574ef87b79ac6c"

    root_block_device {
      volume_size = 8
      volume_type = "gp3"

    }
  
    tags = {
      Name = "tf-made-IAC"
    }
}
