# Install and configure the OMS agent
$PublicSettings = New-Object psobject | Add-Member -PassThru NoteProperty workspaceId "$(omsId)" | ConvertTo-Json
$protectedSettings = New-Object psobject | Add-Member -PassThru NoteProperty workspaceKey "$(omsKey)" | ConvertTo-Json

Set-AzureRmVMExtension -ExtensionName "OMS" -ResourceGroupName "$(ResourceGroup)" -VMName "$(VMName)" `
  -Publisher "Microsoft.EnterpriseCloud.Monitoring" -ExtensionType "MicrosoftMonitoringAgent" `
  -TypeHandlerVersion 1.0 -SettingString $PublicSettings -ProtectedSettingString $protectedSettings `
  -Location "$(location)"