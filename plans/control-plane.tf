# This Terraform plan is responsible for the Code Valet control plane
#
# As described (loosely) in the README, the control plane is where the bits
# which are actually servicing codevalet.io would be running. THese would be
# considered "trusted" resources and not those running user-generated code.

resource "azurerm_resource_group" "controlplane" {
  name     = "${var.prefix}-controlplane"
  location = "${var.region}"
}

resource "azurerm_container_service" "controlplane" {
  name                   = "${var.prefix}-controlplane"
  location               = "${azurerm_resource_group.controlplane.location}"
  resource_group_name    = "${azurerm_resource_group.controlplane.name}"
  orchestration_platform = "Kubernetes"

  master_profile {
    count      = 1
    dns_prefix = "${var.k8s_master_name}"
  }

  linux_profile {
    admin_username = "tyler"
    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAueiy12T5bvFhsc9YjfLc3aVIxgySd3gDxQWy/bletIoZL8omKmzocBYJ7F58U1asoyfWsy2ToTOY8jJp1eToXmbD6L5+xvHba0A7djYh9aQRrFam7doKQ0zp0ZSUF6+R1v0OM4nnWqK4n2ECIYd+Bdzrp+xA5+XlW3ZSNzlnW2BeWznzmgRMcp6wI+zQ9GMHWviR1cxpml5Z6wrxTZ0aX91btvnNPqoOGva976B6e6403FOEkkIFTk6CC1TFKwc/VjbqxYBg4kU0JhiTP+iEZibcQrYjWdYUgAotYbFVe5/DneHMLNsMPdeihba4PUwt62rXyNegenuCRmCntLcaFQ== tyler@kiwi"
    }
  }

  agent_pool_profile {
    name       = "k8s-agents"
    count      = "${var.k8s_agents}"
    dns_prefix = "${var.prefix}-k8s-agent"
    vm_size    = "Standard_DS2_v2"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  diagnostics_profile {
    enabled = false
  }
}
