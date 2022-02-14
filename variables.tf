variable "region" {
  description = "The AWS region"
  type        = string
}

variable "namespace" {
  description = "Namespace"
  type        = string
}

variable "env" {
  description = "Environment describing app stage (e.g. dev, test, staging, prod, global, mgmt)"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
