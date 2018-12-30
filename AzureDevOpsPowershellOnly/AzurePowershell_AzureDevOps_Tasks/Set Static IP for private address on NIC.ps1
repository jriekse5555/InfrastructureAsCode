#Sets the private IP as static to NIC object previously created
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
#Sets NIC name to the one previously created
$NICName = "$(VMName)" + "NIC"
#Retrieves NIC object
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName
#Sets private IP as static on NIC object
$NIC.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
#Updates NIC object
$NIC | Set-AzureRmNetworkInterface