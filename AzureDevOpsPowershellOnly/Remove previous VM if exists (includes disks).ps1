Remove-AzureRmVM -ResourceGroupName "$(ResourceGroup)" -Name "$(VMName)" -Force

Remove-AzureRmDisk -ResourceGroupName "$(ResourceGroup)" -DiskName "$(VMName)-osdisk" -Force
Remove-AzureRmDisk -ResourceGroupName "$(ResourceGroup)" -DiskName "$(VMName)-datadisk1" -Force