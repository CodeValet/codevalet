# This Terraform plan is responsible for the Code Valet control plane
#
# As described (loosely) in the README, the control plane is where the bits
# which are actually servicing codevalet.io would be running. THese would be
# considered "trusted" resources and not those running user-generated code.

resource "azurerm_resource_group" "controlplane" {
  name     = "codevalet"
  location = "${var.region}"
}
