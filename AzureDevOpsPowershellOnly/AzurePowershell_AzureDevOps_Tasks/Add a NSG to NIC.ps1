$nsg = Get-AzureRmNetworkSecurityGroup -ResourceGroupName "$(ResourceGroup)" -Name "$(NSG)"

$NICName = "$(VMName)" + "NIC"
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName
$NIC.NetworkSecurityGroup = $nsg
$NIC | Set-AzureRmNetworkInterface
