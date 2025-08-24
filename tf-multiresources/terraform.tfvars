ec2_config = [ {
  ami = "ami-0360c520857e3138f" #ubuntu linux
  instance_type = "t2.micro"
} ,{
    ami = "ami-00ca32bbc84273381" #amazon linux
    instance_type = "t2.micro"
}]

ec2_map = {
  "ubuntu" = {
    ami = "ami-0360c520857e3138f" #ubuntu linux
    instance_type = "t2.micro"
  },
  "amazon" = {
    ami = "ami-00ca32bbc84273381" #amazon linux
    instance_type = "t2.micro"
  }
}