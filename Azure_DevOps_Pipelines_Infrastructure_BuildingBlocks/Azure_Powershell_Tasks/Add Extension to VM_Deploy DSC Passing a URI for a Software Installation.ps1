#Install DSC to VM
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
#Sets DSC location existing on a private container on a storage accounts with a SAS token
#Note that if the .zip file is not of the root of the container the blob prefix would be in the path such as: "/BlobPrefix/test.zip"

#The addition to this script is an additional parameter to pass in the location to install software
#Create $InstallerURI parameter to source installation media. Note any blob prefixes should be added such as such as: "/BlobPrefix/instal.exe". This example uses a SAS token suffix
$InstallerURI = "$(DeploySoftwareStorageAcctLocation)" + "/install.exe" + "$(DeploySoftwareStorageAcctSASToken)"

#Note all variables with the syntax "$()" are DevOps variables that need to predefined
#Sets DSC location existing on a private container on a storage accounts with a SAS token
#Note that if the .zip file is not of the root of the container the blob prefix would be in the path such as: "/BlobPrefix/test.zip"
$DSCPath = "$(DeployStorageAcctLocation)" + "/test.zip" + "$(DeployStorageAcctSASToken)"

#Sets DSC location, configuration file and configuration
$Settings = @{
    "ModulesUrl" = "$DSCPath";
    "ConfigurationFunction" = "test.ps1\Install"
 }

$ProtectedSettings = @{
     "Properties" = @{"InstallerURI" = $InstallerURI}
}

#Used Set-AzureRmVMExtension instead of Set-AzureRmVMDscExtension as Set-AzureRmVMDscExtension was requesting the older parameter -ConfigurationArchive
#Installs DSC extension
#Note DSC extension can be used multiple times if the same Name is used
Set-AzureRmVMExtension -ExtensionName 'Microsoft.Powershell.DSC' -ResourceGroupName "$(ResourceGroup)" -VMName "$(VMName)" -Location "$(Location)" -ExtensionType 'DSC' -Publisher 'Microsoft.PowerShell' -TypeHandlerVersion '2.76' -Settings $Settings -ProtectedSettings $ProtectedSettings
