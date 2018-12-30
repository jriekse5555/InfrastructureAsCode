$localPass = ConvertTo-SecureString "$(localPass)" -AsPlainText -Force
$NICName = "$(VMName)" + "NIC"
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName

$Credential = New-Object System.Management.Automation.PSCredential ("$(localUser)", $localPass)

$VirtualMachine = New-AzureRmVMConfig -VMName "$(VMName)" -VMSize "$(VMSize)"
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName "$(VMName)" -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2016-Datacenter' -Version 'latest'
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -CreateOption 'FromImage' -StorageAccountType 'Standard_LRS'  -Name "$(VMName)-osdisk"
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Lun 0 -CreateOption 'Empty' -Name "$(VMName)-datadisk1" -StorageAccountType 'Standard_LRS' -Caching None -DiskSizeinGB 127
$VirtualMachine = Set-AzureRmVMBootDiagnostics -VM $VirtualMachine -Disable

New-AzureRmVM -ResourceGroupName "$(ResourceGroup)" -Location "$(Location)" -VM $VirtualMachine -Verbose 

