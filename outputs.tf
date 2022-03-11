output "linux_virtual_machine" {
  description = "azurerm_linux_virtual_machine results"
  value = {
    for linux_virtual_machine in keys(azurerm_linux_virtual_machine.linux_virtual_machine) :
    linux_virtual_machine => {
      id   = azurerm_linux_virtual_machine.linux_virtual_machine[linux_virtual_machine].id
      name = azurerm_linux_virtual_machine.linux_virtual_machine[linux_virtual_machine].name
      zone = azurerm_linux_virtual_machine.linux_virtual_machine[linux_virtual_machine].zone
      private_ip_address = azurerm_linux_virtual_machine.linux_virtual_machine[linux_virtual_machine].private_ip_address
      public_ip_address = azurerm_linux_virtual_machine.linux_virtual_machine[linux_virtual_machine].public_ip_address
      virtual_machine_id = azurerm_linux_virtual_machine.linux_virtual_machine[linux_virtual_machine].virtual_machine_id
    }
  }
}
output "managed_disk" {
  description = "azurerm_managed_disk results"
  value = {
    for managed_disk in keys(azurerm_managed_disk.managed_disk) :
    managed_disk => {
      id   = azurerm_managed_disk.managed_disk[managed_disk].id
      name = azurerm_managed_disk.managed_disk[managed_disk].name
    }
  }
}
