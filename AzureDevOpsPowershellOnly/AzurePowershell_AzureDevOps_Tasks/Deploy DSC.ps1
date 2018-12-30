#Install DSC to VM
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
#Sets DSC location
$DSCPath = "$(artifactsLocation)" + "/Code/DSC/ConfigureStandardServer.zip" + "$(artifactsLocationSasToken)"

#Sets DSC location, configuration file and configuration
$SettingsHT = @{
    "ModulesUrl" = "$DSCPath";
    "ConfigurationFunction" = "ConfigureStandardServer.ps1\Install"
    }

#Used Set-AzureRmVMExtension instead of Set-AzureRmVMDscExtension as Set-AzureRmVMDscExtension was requesting the older parameter -ConfigurationArchive
#Installs DSC extension
#Note DSC extension can be used multiple times if the same Name is used
Set-AzureRmVMExtension -ExtensionName 'DSC' -ResourceGroupName "$(ResourceGroupName)" -VMName "$(VMName)" -Location "$(Location)" -ExtensionType 'DSC' -Publisher 'Microsoft.PowerShell' -TypeHandlerVersion '2.76' -Settings $SettingsHT
