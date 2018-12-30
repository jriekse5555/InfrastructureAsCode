#Sets up variables leveraging pipeline and library Azure DevOps variables
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
$localPass = ConvertTo-SecureString "$(localPass)" -AsPlainText -Force
$NICName = "$(VMName)" + "NIC"
#Retrieves NIC object from previous steps
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName

#Sets up the credential for use creating VM
$Credential = New-Object System.Management.Automation.PSCredential ("$(localUser)", $localPass)

#Defines VM object and adds a series of properties
#Defines VM name and size
$VirtualMachine = New-AzureRmVMConfig -VMName "$(VMName)" -VMSize "$(VMSize)"
#Defines Credential and other options
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName "$(VMName)" -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
#Assign NIC object created earlier
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
#Defines the 2016 server gallery image
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2016-Datacenter' -Version 'latest'
#Defines the OS managed disk with specific name
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -CreateOption 'FromImage' -StorageAccountType 'Standard_LRS'  -Name "$(VMName)-osdisk"
#Adds an additional managed data disk with the default 127GB size using a standard HDD and specific name
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Lun 0 -CreateOption 'Empty' -Name "$(VMName)-datadisk1" -StorageAccountType 'Standard_LRS' -Caching None -DiskSizeinGB 127
#Disables Boot Diagnostics which leverages a separate storage account
$VirtualMachine = Set-AzureRmVMBootDiagnostics -VM $VirtualMachine -Disable

#Creates VM
New-AzureRmVM -ResourceGroupName "$(ResourceGroup)" -Location "$(Location)" -VM $VirtualMachine -Verbose 

