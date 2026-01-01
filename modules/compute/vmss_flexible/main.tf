resource "azurerm_orchestrated_virtual_machine_scale_set" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name  = var.sku_name
  instances = var.instances

  platform_fault_domain_count = var.platform_fault_domain_count

  os_profile {
    custom_data = base64encode(var.custom_data)

    linux_configuration {
      admin_username                  = var.admin_username
      disable_password_authentication = true

      admin_ssh_key {
        username   = var.admin_username
        public_key = var.ssh_public_key
      }
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name      = "ipconfig"
      primary   = true
      subnet_id = var.subnet_id

      load_balancer_backend_address_pool_ids = [var.backend_pool_id]
    }
  }

  tags = var.tags
}
