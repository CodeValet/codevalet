#
# Terraform plan for managing some basic resources for Azure images
#

resource "azurerm_resource_group" "images" {
  name     = "${var.prefix}-codevalet-images"
  location = "${var.region}"
}

resource "azurerm_storage_account" "images" {
  name                = "codevaletvhds"
  resource_group_name = "${azurerm_resource_group.images.name}"

  location     = "${var.region}"
  account_type = "Standard_LRS"

}
