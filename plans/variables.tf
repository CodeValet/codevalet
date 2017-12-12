#
# Variables for plugging in various environment specific settings
#

variable "env" {
  type    = "string"
  default = "dev"
}

variable "dnsprefix" {
    type    = "string"
    default = ""
}

variable "region" {
  type    = "string"
  default = "West US"
}

#
# Variables which should be kept secret
# and provided by a --var-file
#######################################
variable "subscription_id" {
    type    = "string"
    default = "invalid-subscription"
}
variable "client_id" {
    type    = "string"
    default = "invalid-client"
}
variable "client_secret" {
    type    = "string"
    default = "invalid-client-secret"
}
variable "tenant_id" {
    type    = "string"
    default = "invalid-tenant-id"
}
#######################################
