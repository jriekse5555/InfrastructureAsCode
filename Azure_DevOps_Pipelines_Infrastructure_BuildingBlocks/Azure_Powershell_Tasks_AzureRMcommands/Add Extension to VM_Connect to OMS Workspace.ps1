#Sets up variables to be used later with adding the OMS extension to a VM
#Note all variables with the syntax "$()" are DevOps variables that need to be predefined
$PublicSettings = New-Object psobject | Add-Member -PassThru NoteProperty workspaceId "$(omsId)" | ConvertTo-Json
$protectedSettings = New-Object psobject | Add-Member -PassThru NoteProperty workspaceKey "$(omsKey)" | ConvertTo-Json

#Installs the OMS agent to a VM through the OMS extension
Set-AzureRmVMExtension -ExtensionName "OMS" -ResourceGroupName "$(ResourceGroup)" -VMName "$(VMName)" `
  -Publisher "Microsoft.EnterpriseCloud.Monitoring" -ExtensionType "MicrosoftMonitoringAgent" `
  -TypeHandlerVersion 1.0 -SettingString $PublicSettings -ProtectedSettingString $protectedSettings `
  -Location "$(location)"