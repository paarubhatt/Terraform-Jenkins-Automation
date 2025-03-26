provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "eks" {
  ami           = "ami-084568db4383264d4" # us-east-1
  instance_type = "t2.micro"
  tags = {
      Name = "eks-instance"
  }
}
