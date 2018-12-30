#Provides an example of running a powershell script on a VM using Set-AzureRmVMCustomScriptExtension
#Sets up the path to the powershell script leveraging DevOps variables
$FilePath = "$(artifactsLocation)" + "/Code/Powershell/test.ps1" + "$(artifactsLocationSasToken)"

#Sets the custom extension with the name of the powershell script (with blob prefix), and a name for the exteionsion. Note that this command can be used repeatably if the extension name is kept the same.
Set-AzureRmVMCustomScriptExtension -FileURI $FilePath -Run "Code\Powershell\test.ps1" -ResourceGroupName "$(ResourceGroup)" -VMName "$(VMName)" -Location "$(Location)" -Name "Custom"