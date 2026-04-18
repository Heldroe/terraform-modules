variable "name" {
  type = string

  description = "SSM parameter name."
}

variable "value" {
  type    = string
  default = "undefined"

  description = "Value of the parameter."
}

variable "type" {
  type = string

  default = "String"

  description = "SSM parameter type."
}
