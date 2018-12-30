$DSCPath = "$(artifactsLocation)" + "/Code/DSC/ConfigureStandardServer.zip" + "$(artifactsLocationSasToken)"

$SettingsHT = @{
    "ModulesUrl" = "$DSCPath";
    "ConfigurationFunction" = "ConfigureStandardServer.ps1\Install"
    }

#Used Set-AzureRmVMExtension instead of Set-AzureRmVMDscExtension as Set-AzureRmVMDscExtension was requesting the older parameter -ConfigurationArchive
Set-AzureRmVMExtension -ExtensionName 'DSC' -ResourceGroupName "$(ResourceGroupName)" -VMName "$(VMName)" -Location "$(Location)" -ExtensionType 'DSC' -Publisher 'Microsoft.PowerShell' -TypeHandlerVersion '2.76' -Settings $SettingsHT
