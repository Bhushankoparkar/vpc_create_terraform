variable "vpc_cidr" {
  type = string
}

variable "tag" {
# type = string
  type = map(string)
}

variable "public_cidr" {
  type = list(string)
}

variable "private_cidr" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "env" {
  type = string
}

variable "owner" {
  type = string
}