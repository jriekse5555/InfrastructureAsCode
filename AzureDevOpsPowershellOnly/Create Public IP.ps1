$PublicIPName = "Public-" + "$(VMName)"
$PublicIP = New-AzureRmPublicIpAddress -Name $PublicIPName -ResourceGroupName "$(ResourceGroup)" -AllocationMethod Dynamic -Location "$(Location)" -Force

$NICName = "$(VMName)" + "NIC"
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName
$nic.IpConfigurations[0].PublicIpAddress = $PublicIP
#$NIC | Set-AzureRmNetworkInterfaceIpConfig -Name "ipconfig1" -PublicIpAddress $PublicIP
$NIC | Set-AzureRmNetworkInterface