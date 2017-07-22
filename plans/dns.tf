# These plans are for managing resources in Azure for codevalet's DNS
#
# Presently not sure if this is the best approach to managing Azure DNS
# resources between production and staging, but we'll give it a try.

resource "azurerm_resource_group" "prod" {
  name     = "codevaletprod"
  location = "East US 2"
}

resource "azurerm_dns_zone" "root" {
  name                = "codevalet.io"
  resource_group_name = "${azurerm_resource_group.prod.name}"
}
