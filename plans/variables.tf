#
# Variables for plugging in various environment specific settings
#


variable "env" {
  type    = "string"
  default = "dev"
}

variable "region" {
  type    = "string"
  default = "West US"
}

#
# Variables which should be kept secret
# and provided by a --var-file
#######################################
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
#######################################
