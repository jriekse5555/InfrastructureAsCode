rem Configure IIS website
rem Use Case: Azure DevOps connections via deployment agents are not available and IIS configuration must be done via the Azure extensions. 
rem Use Case continued: under the hood of Azure DevOps Services IIS web app manage task commands are issued via the appcmd.exe executable that's installed in IIS via specific parameters
rem Use Case continued: the commands below show an example config

rem Create apppool
rem APPPOOL object "TestAppPool" added
"C:\Windows\system32\inetsrv\appcmd.exe" add apppool /name:"TestAppPool"
rem APPPOOL object "TestAppPool" changed
"C:\Windows\system32\inetsrv\appcmd.exe" set apppool /apppool.name:"TestAppPool" -managedRuntimeVersion:v4.0 -managedPipelineMode:Integrated -processModel.identityType:NetworkService

rem Create root directory for website
md "c:\websites\TestWebsite"

rem Create website
"C:\Windows\system32\inetsrv\appcmd.exe" add site /site.name:"TestWebsite" -applicationDefaults.applicationPool:"TestAppPool" /physicalPath:"c:\websites\TestWebsite" /bindings:http://*:80
"C:\Windows\system32\inetsrv\appcmd.exe" set config "TestWebsite" /section:anonymousAuthentication /enabled:false /commit:apphost
"C:\Windows\system32\inetsrv\appcmd.exe" set config "TestWebsite" /section:basicAuthentication /enabled:false /commit:apphost
"C:\Windows\system32\inetsrv\appcmd.exe" set config "TestWebsite" /section:windowsAuthentication /enabled:true /commit:apphost

rem add website virtual directory
"C:\Windows\system32\inetsrv\appcmd.exe" add app /site.name:"TestWebsite" /path:"/testvirtualpath" /physicalPath:"c:\websites\TestWebsite"

