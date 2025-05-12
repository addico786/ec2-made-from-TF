variable "instance_type" {
    default = "t3.micro"
    type = string
}

variable "ami" {
    default = "ami-0c1ac8a41498c1a9c"
    type = string
}

variable "volume_size" {
    default = 8
    type = number
  
}

variable "volume_type" {
    default = "gp3"
  
}

variable "env" {
    default = "test"
  
}