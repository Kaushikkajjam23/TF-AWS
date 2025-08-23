variable "aws_instance_type" {
  description = "What type of instance do you want to create?"
  type        = string
  default     = "t2.micro"  # Added default value
  validation {
    condition     = var.aws_instance_type == "t2.micro" || var.aws_instance_type == "t3.micro"
    error_message = "Only t2.micro and t3.micro are allowed."
  }
}
variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}
variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp2"  # Fixed: Changed from "value" to "gp2"
}
variable "ec2_config" {
  description = "EC2 configuration object"
  type = object({
    v_size = number
    v_type = string
  })
  default = {
    v_size = 20
    v_type = "gp2"
  }
}

variable "additional_tags" {
  type=map(string) #excepted key=value format
  default = {
    "name" = "value"
  }
}