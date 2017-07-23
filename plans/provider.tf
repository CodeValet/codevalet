# Configure the terraform Azure provider

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "prefix" {
  type    = "string"
  default = "codevaletdev"
}

variable "dnsprefix" {
  type    = "string"
  default = ""
}

variable "env" {
  type    = "string"
  default = "dev"
}

variable "region" {
  type    = "string"
  default = "East US 2"
}

variable "k8s_master_name" {
  type    = "string"
  # Cannot contain interpolations? wompwomp
  default = "codevaletdev-k8s-master"
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

provider "kubernetes" {
  config_context_auth_info = "${var.k8s_master_name}-admin"
  config_context_cluster   = "${var.k8s_master_name}"
}
