Configuration Install
{
    param(
        [Parameter(HelpMessage='The URI to access the installer. Should be fully qualified, including any SAS tokens.')]
        [string]$InstallerUri
        )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'

    Node localhost
    {      
        
        Script 'Install' {  
            GetScript  = {
            }
            TestScript = { 
                #Sets variables from parameter
                $BlobUrl = $using:InstallerUri
                #For the purpose of checking a unique registry key to verify script ran sets a variable with the key
                #Does string manipulation on the InstallerURI parameter to remove SAS token from the end and also removes backslashes which cause an issue with creating the registry key
                $TestRegKey = ($BlobUrl.split('?')[0]).replace('/','')
                #Combines last variable into a full registry key path for the check
                $TestRegKeyFullPath = 'HKLM:\Software\Custom\' + $TestRegKey
                #Leverages Test-Path to Determine DSC has been previously applied
                Test-Path -Path $TestRegKeyFullPath
            }
            SetScript  = {
                #Sets variables from paramter
                $BlobUrl = $using:InstallerUri
                #For the purpose of checking a unique registry key to verify script ran sets a variable with the key
                #Does string manipulation on the InstallerURI parameter to remove SAS token from the end and also removes backslashes which cause an issue with creating the registry key
                #$TestRegKey = ($BlobUrl.split('?')[0]).replace('/','')

                #Set Temp Location to Store Zip
                $LocalInstall = [io.path]::combine($env:Temp, 'package.zip')

                #Copy .zip on storage account to .zip in temporary local location
                Invoke-WebRequest -URI $BlobUrl -OutFile $LocalInstall -Verbose

                #Set variables for delete existing and copy new
                $DestinationPath = 'c:\Temp\AppExtract'
                $DeletionPathString = $DestinationPath + '\*'
                
                #Delete directory ahead of copy
                if ( Test-Path -Path $DestinationPath -PathType Container ) {
                    Remove-Item $DeletionPathString
                }
                
                #Extract local .zip to destination path
                Expand-Archive -LiteralPath $LocalInstall -DestinationPath $DestinationPath -Force

                #Check turned off to allow running multiple times
                #Sets registry key from unique value to determine DSC has been applied
                #New-Item -Path 'HKLM:\Software\Custom' -Name $TestRegKey -Force
            }
        }   
    }
}
