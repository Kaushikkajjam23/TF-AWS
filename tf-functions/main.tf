terraform {}

locals {
  value="Hello, World!"
}
variable "string_list" {
    type=list(string)
    default=["server1","server2","server3","server1"]
}
output "output" {
  value = lower(local.value)
}

output "output_upper" {
  value = upper(local.value)
}
output "starts-ends" {
  #value=startswith(local.value,"Hello")
  #value=split(" ",local.value)
  #value = max(1,2,3,4,5)
  #value = min(1,2,3,4,5)
  #value=abs(-123)
  #value = length(local.value)
  #value = length(var.string_list)
  #value = join(":",var.string_list)
  #value = reverse(var.string_list)
  #value=contains(var.string_list,"server1")
  #value = distinct(var.string_list)
  value=toset(var.string_list)
}
