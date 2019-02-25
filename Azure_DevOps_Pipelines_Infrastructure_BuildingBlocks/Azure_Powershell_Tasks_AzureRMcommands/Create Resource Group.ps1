#Note all variables with the syntax "$()" are DevOps variables that need to be predefined

# Create Resource Group
New-AzureRMResourceGroup -Name "$(ResourceGroup)" -Location "$(Location)"