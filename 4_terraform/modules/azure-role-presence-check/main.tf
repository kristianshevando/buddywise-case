resource "null_resource" "azure_custom_role_presence_check" {
  triggers = {
    always_run = "false"
  }
  provisioner "local-exec" {
    command = <<EOT
        try {
	        Start-Sleep -Seconds 700
          [array]$azure_iam_role_id = az role definition list --custom-role-only true --name ${var.azurerm_custom_role_name} --resource-group ${var.azurerm_resource_group_name} --subscription ${var.azurerm_subscription_id} --query "[].id"
          $timer = [Diagnostics.Stopwatch]::StartNew()
          while ($azure_iam_role_id.count -eq 0) {
            Start-Sleep -seconds 15
            [array]$azure_iam_role_id = az role definition list --custom-role-only true --name ${var.azurerm_custom_role_name} --resource-group ${var.azurerm_resource_group_name} --subscription ${var.azurerm_subscription_id} --query "[].id"
            if ([math]::Round($timer.Elapsed.TotalSeconds,0) -ge 600) {
              Write-Error -Message "The Azure custom role with name ${var.azurerm_custom_role_name} did not create properly. Further investigation is required."
            }
          }
        }
        catch [system.exception] {
          Write-Host $_
          exit 1
        }
      EOT
    interpreter = ["pwsh", "-Command"]
  }
}