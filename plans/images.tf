#
# Terraform plan for managing some basic resources for Azure images
#

resource "azurerm_resource_group" "images" {
  name     = "azureagents-for-codevalet"
  location = "${var.region}"
}

resource "azurerm_storage_account" "images" {
    name                     = "codevaletvhds"
    resource_group_name      = "${azurerm_resource_group.images.name}"
    location                 = "${var.region}"
    account_tier             = "Standard"
    account_replication_type = "LRS"

}
