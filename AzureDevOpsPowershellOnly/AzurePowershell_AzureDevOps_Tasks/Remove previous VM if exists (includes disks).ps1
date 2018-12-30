#Removes previous VM to allow running the creation script again
#Note all variables with the syntax "$()" are DevOps variables that need to predefined
Remove-AzureRmVM -ResourceGroupName "$(ResourceGroup)" -Name "$(VMName)" -Force

#After VM is removed, the disks are removed using a specific naming convention that was used in the creation
Remove-AzureRmDisk -ResourceGroupName "$(ResourceGroup)" -DiskName "$(VMName)-osdisk" -Force
Remove-AzureRmDisk -ResourceGroupName "$(ResourceGroup)" -DiskName "$(VMName)-datadisk1" -Force

#Note removing the NIC is not necessary if future NIC creation uses -Force to overwrite