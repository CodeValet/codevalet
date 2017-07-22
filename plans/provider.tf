# Configure the terraform Azure provider

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "prefix" {
    type    = "string"
    default = "codevaletdev"
}

variable "env" {
    type    = "string"
    default = "dev"
}

variable "k8s_agents" {
    type    = "string"
    default = "1"
}

provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}
