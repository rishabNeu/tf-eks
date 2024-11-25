variable "public_subnets_cidr" {
  type        = list(string)
  description = "list of public subnets cidr"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "list of private subnets cidr"
}

variable "env" {
  type = string
  description = "env that is using the tf code"
}