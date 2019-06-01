param (
    [Parameter(Mandatory=$true)][string]$JsonOutput,
    [Parameter(Mandatory=$true)][string]$Name
    )

#region Convert from json
$TempValue = $JsonOutput | convertfrom-json

Write-Output -InputObject ($TempValue."$Name".Value)

$Final = ($TempValue."$Name".Value)

$String = '##vso[task.setvariable variable=' + "$Name" + ']' + $Final

Write-Host $String

#endregion
