variable "region" {
    description = "The AWS region to deploy resources in"
    type = string
    default     = "us-east-1"
}
variable "ec2_config" {
  type = list(object({
    ami = string
    instance_type = string 
  }))
}

variable "ec2_map" {
    #key = value (object{ami,instance_type})
    type = map(object({
        ami = string
        instance_type = string 
    }))
  
}