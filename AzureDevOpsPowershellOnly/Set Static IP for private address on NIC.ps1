$NICName = "$(VMName)" + "NIC"
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName
$NIC.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$NIC | Set-AzureRmNetworkInterface