# Creates variable for NIC name using DevOps variable for VMName with 'NIC' suffix
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
$NICName = "$(VMName)" + "NIC"
# Creates variable for the Azure subnet object using several DevOps variables
$SubnetObject = "/subscriptions/" + "$(SubscriptionID)" + "/resourceGroups/" + "$(NetworkRG)" + "/providers/Microsoft.Network/virtualNetworks/" + "$(Network)" + "/subnets/" + "$(Subnet)"

# Creates NIC using previous variables and DevOps variables
$NIC = New-AzureRmNetworkInterface -Name $NICName -ResourceGroupName "$(ResourceGroup)" -Location "$(Location)" -SubnetId $SubnetObject -Force
