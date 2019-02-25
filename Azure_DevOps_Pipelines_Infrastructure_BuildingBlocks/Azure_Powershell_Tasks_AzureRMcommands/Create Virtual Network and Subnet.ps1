#Note all variables with the syntax "$()" are DevOps variables that need to be predefined

# Create Virtual Network
$virtualNetwork = New-AzureRMVirtualNetwork `
  -ResourceGroupName "$(ResourceGroup)" `
  -Location "$(Location)" `
  -Name "$(Network)" `
  -AddressPrefix 11.0.0.0/16

#Create Subnet
Add-AzureRMVirtualNetworkSubnetConfig `
  -Name "Subnet1" `
  -AddressPrefix 11.0.0.0/24 `
  -VirtualNetwork $virtualNetwork

#Associate subnet with virtual network
$virtualNetwork | Set-AzureRMVirtualNetwork