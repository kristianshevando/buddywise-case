SUBSCRIPTION_ID   = "<placeholder>"
SPN_CLIENT_ID     = "<placeholder>"
SPN_CLIENT_SECRET = "<placeholder>"
TENANT_ID         = "<placeholder>"

INFRASTRUCTURE_NAME           = "bdws"
SUFFIX                        = "mgmt"
PREFIX                        = "prd"
AUTOMATED_DESTROY             = false
TERRAFORM_CODE_PACKAGE_NUMBER = "1.0.0:somecommithash"
LOCATION                      = "westeurope"
infrastructure_code_version   = "1.0.0"
# !!! All parameters above must be set on deployment agent site as env variables 

public_ip_sku_bastion_host               = "Standard"
public_ip_allocation_method_bastion_host = "Static"
azure_vnet_address_space                 = ["10.0.13.0/24"]
azure_subnet_additional_bitmask          = 4
azure_bastion_host_enabled               = false
azure_dns_relay_enabled	                 = false

azure_mgmt_components                          = [
    {
      "count_of_instances"                     = 1
      "instance_type"                          = "vm"
      "instance_name"                          = "mgmt-vm"
      "subnet_index"                           = "5"
      "source_image_id"                        = "<placeholder>"
      "vm_size"                                = "Standard_B2s"
      "os_type"                                = "windows"
      "osDisk_deleteOption"                    = "Delete"
      "private_ip_address_allocation"          = "Dynamic"
      "azure_vm_username"                      = "mgmt-admin"
      "azure_managed_service_identity_enabled" = true
      "azure_vm_auto_shutdown_utc_time"        = "auto"   ### If empty process of auto shutdown is disabled, if auto VM will be turn off after process of provision. To set exact time use the following format (UTC): "1100"
    },
    {
      "count_of_instances"                     = 1
      "instance_type"                          = "vm"
      "instance_name"                          = "deploy-agents"
      "subnet_index"                           = "9"
      "source_image_id"                        = "<placeholder>"
      "vm_size"                                = "Standard_B2s"
      "os_type"                                = "windows"
      "osDisk_deleteOption"                    = "Delete"
      "private_ip_address_allocation"          = "Dynamic"
      "azure_vm_username"                    = "mgmt-admin"
      "azure_managed_service_identity_enabled" = true
    },
    {
      "count_of_instances" = 0
      "instance_type"      = "undefined"
      "instance_name"      = "AzureBastionSubnet"
      "azure_nsg_rules"    = [
        {
          "name"                       = "allowhttpsinbound"
          "priority"                   = "110"
          "direction"                  = "Inbound"
          "destination_port_ranges"    = ["443"]
          "source_address_prefix"      = "Internet"
          "protocol"                   = "Tcp"
          "destination_address_prefix" = "*"
        },
        {
          "name"                       = "allowgatewaymanagerinbound"
          "priority"                   = "111"
          "direction"                  = "Inbound"
          "destination_port_ranges"    = ["443"]
          "source_address_prefix"      = "GatewayManager"
          "protocol"                   = "Tcp"
          "destination_address_prefix" = "*"
        },
        {
          "name"                       = "allowazureloadbalancerinbound"
          "priority"                   = "112"
          "direction"                  = "Inbound"
          "destination_port_ranges"    = ["443"]
          "source_address_prefix"      = "AzureLoadBalancer"
          "protocol"                   = "Tcp"
          "destination_address_prefix" = "*"
        },
        {
          "name"                       = "allowbastionhostcommunication"
          "priority"                   = "113"
          "direction"                  = "Inbound"
          "destination_port_ranges"    = ["8080", "5701"]
          "source_address_prefix"      = "VirtualNetwork"
          "protocol"                   = "*"
          "destination_address_prefix" = "VirtualNetwork"
        },
        {
          "name"                       = "allowsshrdpoutbound"
          "priority"                   = "110"
          "direction"                  = "Outbound"
          "destination_port_ranges"    = ["22","3389"]
          "source_address_prefix"      = "*"
          "protocol"                   = "*"
          "destination_address_prefix" = "VirtualNetwork"
        },
        {
          "name"                       = "allowazurecloudoutbound"
          "priority"                   = "111"
          "direction"                  = "Outbound"
          "destination_port_ranges"    = ["443"]
          "source_address_prefix"      = "*"
          "protocol"                   = "Tcp"
          "destination_address_prefix" = "AzureCloud"
        },
        {
          "name"                       = "allowbastioncommunication"
          "priority"                   = "112"
          "direction"                  = "Outbound"
          "destination_port_ranges"    = ["8080", "5701"]
          "source_address_prefix"      = "VirtualNetwork"
          "protocol"                   = "*"
          "destination_address_prefix" = "VirtualNetwork"
        },
        {
          "name"                       = "allowgetsessioninformation"
          "priority"                   = "113"
          "direction"                  = "Outbound"
          "destination_port_ranges"    = ["80"]
          "source_address_prefix"      = "*"
          "protocol"                   = "*"
          "destination_address_prefix" = "Internet"
        }
      ]
    },
    {
      "count_of_instances" = 0
      "instance_type"      = "undefined"
      "instance_name"      = "private-link"
    }
  ]

azure_private_dns_zones = [
  {
    "resource_name" = "sqlServer"
    "zone_name"     = "privatelink.database.windows.net"
  },
  {
    "resource_name" = "blob"
    "zone_name"     = "privatelink.blob.core.windows.net"
  },
  {
      "resource_name" = "file"
      "zone_name"     = "privatelink.file.core.windows.net"
  },
  {
    "resource_name" = "Vault"
    "zone_name"     = "privatelink.vaultcore.azure.net"
  },
  {
    "resource_name" = "registry"
    "zone_name"     = "privatelink.azurecr.io"
  }
]