$FilePath = "$(artifactsLocation)" + "/Code/Powershell/test.ps1" + "$(artifactsLocationSasToken)"

Set-AzureRmVMCustomScriptExtension -FileURI $FilePath -Run "Code\Powershell\test.ps1" -ResourceGroupName "$(ResourceGroup)" -VMName "$(VMName)"   -Location "$(Location)" -Name "Custom"