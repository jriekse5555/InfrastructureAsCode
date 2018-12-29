#Set-AzureRmVMDscExtension -ResourceGroupName "$(ResourceGroupName)" -VMName "$(VMName)" -ArchiveBlobName "<DSC.zip>" -ArchiveStorageAccountName "<StorageAccountName>" -ArchiveContainerName "<Container>" -ArchiveResourceGroupName "<ResourceGroup>" -ConfigurationName "<Config>" -Version "2.76" -Location "$(Location)" -Force

$SettingsHT = @{
    "ModulesUrl" = "<URLwithSAS>";
    "ConfigurationFunction" = "<PSName>.ps1\<Config>"
    }

Set-AzureRmVMExtension -ExtensionName 'DSC' -ResourceGroupName "$(ResourceGroupName)" -VMName "$(VMName)" -Location "$(Location)" -ExtensionType 'DSC' -Publisher 'Microsoft.PowerShell' -TypeHandlerVersion '2.76' -Settings $SettingsHT
