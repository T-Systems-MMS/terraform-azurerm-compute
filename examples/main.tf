module "compute" {
  source = "registry.terraform.io/T-Systems-MMS/compute/azurerm"
  linux_virtual_machine = {
    service-env-vm = {
      computer_name         = "service-env-vm"
      location              = "westeurope"
      resource_group_name   = "service-env-rg"
      admin_username        = "linux_root"
      size                  = "Standard_E4as_v4"
      network_interface_ids = [module.network.network_interface[service-env-vm].id]
      zone                  = 1
      source_image_reference = {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.6"
        version   = "latest"
      }
      admin_ssh_key = {
        mgmt-vm = {
          public_key = "ssh-rsa SSH-KEY"
          username   = "linux_root"
        }
      }
      tags = {
        service = "service_name"
      }
    }
  }
  managed_disk = {
    disk0 = {
      location             = "westeurope"
      resource_group_name  = "service-env-rg"
      storage_account_type = "Premium_LRS"
      create_option        = "Empty"
      disk_size_gb         = 50
      zone                 = 1
      tags = {
        service = "service_name"
      }
    }
  }
  virtual_machine_data_disk_attachment = {
    service-env-vm = {
      managed_disk_id    = module.compute.managed_disk[disk0].id
      virtual_machine_id = module.compute.linux_virtual_machine[service-env-vm].id
      lun                = 0
      caching            = "None"
    }
  }
}
