resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_host_name
  location            = var.location
  resource_group_name = var.azure_resource_group_name
  
  tags = var.common_tags  

  ip_configuration {
    name                 = "default"
    subnet_id            = var.azure_subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
}