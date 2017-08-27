#
# Terraform plan for the in-bound nginx proxy
#

resource "azurerm_dns_a_record" "nginx" {
  name                = "@"
  zone_name           = "${azurerm_dns_zone.root.name}"
  resource_group_name = "${azurerm_resource_group.controlplane.name}"
  ttl                 = "300"
  records             = ["${azurerm_public_ip.nginx.ip_address}"]
}

resource "azurerm_public_ip" "nginx" {
  name                         = "nginx"
  location                     = "${var.region}"
  resource_group_name          = "${azurerm_resource_group.controlplane.name}"
  public_ip_address_allocation = "static"
}

resource "kubernetes_service" "nginx" {
  depends_on = [
    "azurerm_container_service.controlplane",
  ]

  metadata {
    name = "nginx"
  }
  spec {
    load_balancer_ip = "${azurerm_public_ip.nginx.ip_address}"

    type = "LoadBalancer"
    selector {
      name = "nginx"
    }
    session_affinity = "ClientIP"
    port {
      name = "http"
      target_port = 8000
      port = 80
    }
    port {
      name = "http-tls"
      target_port = 8443
      port = 443
    }
  }
}
