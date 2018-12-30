#Retrieves previously created NSG
$nsg = Get-AzureRmNetworkSecurityGroup -ResourceGroupName "$(ResourceGroup)" -Name "$(NSG)"

#Sets up variable for NIC Name
$NICName = "$(VMName)" + "NIC"
#Retrieves previously created NIC
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "$(ResourceGroup)" -Name $NICName
#Assigns the NSG to the NIC
$NIC.NetworkSecurityGroup = $nsg
#Updates the NIC now that the NSG is assigned
$NIC | Set-AzureRmNetworkInterface
