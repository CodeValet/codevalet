# This Terraform plan is responsible for the Code Valet control plane
#
# As described (loosely) in the README, the control plane is where the bits
# which are actually servicing codevalet.io would be running. THese would be
# considered "trusted" resources and not those running user-generated code.

resource "azurerm_resource_group" "controlplane" {
    name     = "codevalet"
    location = "${var.region}"
}

resource "azurerm_container_registry" "registry" {
    name                = "codevalet"
    resource_group_name = "${azurerm_resource_group.controlplane.name}"
    location            = "${azurerm_resource_group.controlplane.location}"
    admin_enabled       = true
    sku                 = "Standard"
}

resource "azurerm_storage_account" "storage" {
    name                     = "codevaletstorage"
    resource_group_name      = "${azurerm_resource_group.controlplane.name}"
    location                 = "${azurerm_resource_group.controlplane.location}"
    account_tier             = "Standard"
    account_replication_type = "GRS"
}
