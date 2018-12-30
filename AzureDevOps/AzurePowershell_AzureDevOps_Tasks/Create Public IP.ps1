#Adds a public IP to a NIC
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
#Sets up Public IP object name
$PublicIPName = "Public-" + "$(VMName)"
#Creates Public IP object
$PublicIP = New-AzureRmPublicIpAddress -Name $PublicIPName -ResourceGroupName "$(ResourceGroup)" -AllocationMethod Dynamic -Location "$(Location)" -Force

#Sets NIC Name that was created previously
$NICName = "$(VMName)" + "NIC"
#Retrieves NIC object from name
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName
#Assign public IP object to NIC
$nic.IpConfigurations[0].PublicIpAddress = $PublicIP
#Updates NIC object
$NIC | Set-AzureRmNetworkInterface