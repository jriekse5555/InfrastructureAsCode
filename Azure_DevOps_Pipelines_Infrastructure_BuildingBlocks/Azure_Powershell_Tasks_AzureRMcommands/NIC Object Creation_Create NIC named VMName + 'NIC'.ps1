#Note all variables with the syntax "$()" are DevOps variables that need to be predefined

# Creates variable for NIC name using DevOps variable for VMName with 'NIC' suffix
$NICName = "$(VMName)" + "NIC"

# Gets Subnet ID for NIC creation
$vnet = Get-AzureRMVirtualNetwork -Name "$(Network)" -ResourceGroupName "$(ResourceGroup)"
$SubnetObject = $vnet.Subnets[0].Id 

# Creates NIC using previous variables and DevOps variables
$NIC = New-AzureRmNetworkInterface -Name $NICName -ResourceGroupName "$(ResourceGroup)" -Location "$(Location)" -SubnetId $SubnetObject -Force

#Backup method to generate SubnetObject variable
# Creates variable for the Azure subnet object using several DevOps variables
#$SubnetObject = "/subscriptions/" + "$(SubscriptionID)" + "/resourceGroups/" + "$(NetworkRG)" + "/providers/Microsoft.Network/virtualNetworks/" + "$(Network)" + "/subnets/" + "$(Subnet)"

