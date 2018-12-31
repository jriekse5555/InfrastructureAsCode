#Install DSC to VM
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
#Sets DSC location existing on a private container on a storage accounts with a SAS token
#Note that if the .zip file is not of the root of the container the blob prefix would be in the path such as: "/BlobPrefix/test.zip"
$DSCPath = "$(artifactsLocation)" + "/test.zip" + "$(artifactsLocationSasToken)"

#Sets DSC location, configuration file and configuration
$SettingsHT = @{
    "ModulesUrl" = "$DSCPath";
    "ConfigurationFunction" = "test.ps1\Install"
    }

#Used Set-AzureRmVMExtension instead of Set-AzureRmVMDscExtension as Set-AzureRmVMDscExtension was requesting the older parameter -ConfigurationArchive
#Installs DSC extension
#Note DSC extension can be used multiple times if the same Name is used
Set-AzureRmVMExtension -ExtensionName 'DSC' -ResourceGroupName "$(ResourceGroupName)" -VMName "$(VMName)" -Location "$(Location)" -ExtensionType 'DSC' -Publisher 'Microsoft.PowerShell' -TypeHandlerVersion '2.76' -Settings $SettingsHT
