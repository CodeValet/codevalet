#
# Terraform plan for managing some of the resources for the webapp
#

resource "azurerm_public_ip" "webapp" {
  name                         = "webapp"
  location                     = "${var.region}"
  resource_group_name          = "${azurerm_resource_group.controlplane.name}"
  public_ip_address_allocation = "static"
}


resource "kubernetes_service" "webapp" {
  depends_on = [
    "azurerm_container_service.controlplane",
  ]

  metadata {
    name = "webapp"
  }
  spec {
    load_balancer_ip = "${azurerm_public_ip.webapp.ip_address}"

    type = "LoadBalancer"
    selector {
      name = "webapp"
    }
    session_affinity = "ClientIP"
    port {
      target_port = 9292
      port = 80
    }
  }
}
