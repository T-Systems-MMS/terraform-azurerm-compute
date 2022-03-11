variable "linux_virtual_machine" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "managed_disk" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "virtual_machine_data_disk_attachment" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    linux_virtual_machine = {
      name                            = ""
      computer_name = ""
      admin_password = ""
      license_type = null
      allow_extension_operations = false
      availability_set_id = null
      custom_data = null
      dedicated_host_id = null
      disable_password_authentication = true
      encryption_at_host_enabled      = false
      eviction_policy                 = null
      extensions_time_budget          = "PT1H30M"
      patch_mode                      = null
      max_bid_price                   = "-1"
      platform_fault_domain           = null
      priority                        = "Regular"
      provision_vm_agent              = "true"
      proximity_placement_group_id    = null
      secure_boot_enabled             = null
      source_image_id                 = null
      user_data = null
      vtpm_enabled = null
      virtual_machine_scale_set_id = null
      zone = 1
      admin_ssh_key                   = {}
      os_disk = {
        name = ""
        caching = "None"
        disk_encryption_set_id = null
        disk_size_gb = null
        write_accelerator_enabled = false
        disk_encryption_set_id = null
        diff_disk_settings = {}
      }
      additional_capabilities         = {}
      boot_diagnostics                = {}
      identity                        = {}
      plan                            = {}
      secret                          = {}
      source_image_reference          = {}
      tags                            = {}
    }
    managed_disk = {
      name = ""
      disk_encryption_set_id = null
      hyper_v_generation = null
      image_reference_id = null
      logical_sector_size = null
      os_type = null
      source_resource_id = null
      source_uri = null
      storage_account_id  = null
      tier = null
      max_shares = null
      trusted_launch_enabled = false
      on_demand_bursting_enabled = false
      network_access_policy = null
      public_network_access_enabled = false
      encryption_settings = {}
    }
    virtual_machine_data_disk_attachment = {
      create_option = null
      write_accelerator_enabled = null
    }
  }

  # compare and merge custom and default values
  linux_virtual_machine_values = {
    for linux_virtual_machine in keys(var.linux_virtual_machine) :
    linux_virtual_machine => merge(local.default.linux_virtual_machine, var.linux_virtual_machine[linux_virtual_machine])
  }
  managed_disk_values = {
    for managed_disk in keys(var.managed_disk) :
    managed_disk => merge(local.default.managed_disk, var.managed_disk[managed_disk])
  }
  # merge all custom and default values
  linux_virtual_machine = {
    for linux_virtual_machine in keys(var.linux_virtual_machine) :
    linux_virtual_machine => merge(
      local.linux_virtual_machine_values[linux_virtual_machine],
      {
        for config in ["os_disk", "source_image_reference"] :
        config => merge(local.default.linux_virtual_machine[config], local.linux_virtual_machine_values[linux_virtual_machine][config])
      },
      {
        for config in ["admin_ssh_key"] :
        config => {
          for key in keys(local.linux_virtual_machine_values[linux_virtual_machine][config]) :
          key => merge(local.default.linux_virtual_machine[config], local.linux_virtual_machine_values[linux_virtual_machine][config][key])
        }
      },
    )
  }
  managed_disk = {
    for managed_disk in keys(var.managed_disk) :
    managed_disk => merge(
      local.managed_disk_values[managed_disk],
      {
        for config in ["encryption_settings"] :
        config => merge(local.default.managed_disk[config], local.managed_disk_values[managed_disk][config])
      }
    )
  }
  virtual_machine_data_disk_attachment = {
    for virtual_machine_data_disk_attachment in keys(var.virtual_machine_data_disk_attachment) :
    virtual_machine_data_disk_attachment => merge(local.default.virtual_machine_data_disk_attachment, var.virtual_machine_data_disk_attachment[virtual_machine_data_disk_attachment])
  }
}
