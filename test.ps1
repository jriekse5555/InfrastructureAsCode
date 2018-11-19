Set-ExecutionPolicy Bypass
Import-Module "sqlps" -DisableNameChecking

#Grant local Administrators access to SQL for this environment
Invoke-Sqlcmd "sp_grantlogin 'BUILTIN\Administrators' "
Invoke-Sqlcmd "ALTER SERVER ROLE sysadmin ADD MEMBER [BUILTIN\Administrators]" 
