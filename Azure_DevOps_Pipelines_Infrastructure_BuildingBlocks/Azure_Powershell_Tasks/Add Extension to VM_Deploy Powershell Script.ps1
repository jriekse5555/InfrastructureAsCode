#Provides an example of running a powershell script on a VM using Set-AzureRmVMCustomScriptExtension
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
#Sets up the path to the powershell script leveraging DevOps variables
#Sets script location existing on a private container on a storage accounts with a SAS token
#Note that if the .ps1 file is not of the root of the container the blob prefix would be in the path such as: "/BlobPrefix/test.ps1"
$FilePath = "$(artifactsLocation)" + "/test.ps1" + "$(artifactsLocationSasToken)"

#Sets the custom extension with the name of the powershell script (with blob prefix), and a name for the exteionsion. Note that this command can be used repeatably if the extension name is kept the same.
#Note that if the .ps1 file is not of the root of the container the blob prefix would be in the path such as: "BlobPrefix\test.ps1"
Set-AzureRmVMCustomScriptExtension -FileURI $FilePath -Run "test.ps1" -ResourceGroupName "$(ResourceGroup)" -VMName "$(VMName)" -Location "$(Location)" -Name "Custom"