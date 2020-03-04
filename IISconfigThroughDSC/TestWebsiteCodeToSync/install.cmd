rem Sync website content
rem stop and start may not be needed - included if needed
"C:\Windows\system32\inetsrv\appcmd.exe" stop site "TestWebsite"
"C:\Program Files\IIS\Microsoft Web Deploy V3\MSDeploy.exe" -verb:sync -source:contentPath="c:\Temp\AppExtract" -dest:contentPath="C:\websites\TestWebsite"
"C:\Windows\system32\inetsrv\appcmd.exe" start site "TestWebsite"