terraform {}

#Number List
variable "num_list" {
    type = list(number)
    default = [1, 2, 3, 4, 5]
}

#Object list of person
variable "person_list" {
    type = list(object({
        fname = string
        lname = string
    }))
    default = [
        {
            fname = "Alice"
            lname = "Smith"
        },
        {
            fname = "Sham"
            lname = "Paul"
        }
    ]
}

#Map 
variable "map_list" {
  type = map(number)
    default = {
        "one" = 1
        "two" = 2
        "three" = 3
    }
}

#Calculations
locals {
  mul=2*8
  add=2+2
  sub=2-2
  div=2/2
  eq=2!=3

  #double the list
  double_list = [for num in var.num_list : num * 2]
  #odd numbers only
  oddnums=[for num in var.num_list: num if num %2!=0]

  #To get only fname from person list
  fname_list=[for person in var.person_list: person.fname]

  #work with map
  #here we are using data from map and storing in list 
  map_info=[for key, value in var.map_list : {key = key, value = value*5}]
  #here we are directly working with the map doubling to see difference
  map_directly = {for key, value in var.map_list : key => value * 2}

}
output "output" {
  value = {
    multiplication = local.mul
    addition = local.add
    subtraction = local.sub
    division = local.div
    equals = local.eq

    doubledvalues=local.double_list
    oddnums=local.oddnums
    firstnames=local.fname_list
    mapinfo=local.map_info
    mapdirectly=local.map_directly
  }
}