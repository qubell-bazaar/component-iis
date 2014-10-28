param (
 [string[]]$iis_modules=('Web-Asp-Net45','Web-Net-Ext45','Web-Common-Http','Web-ISAPI-Ext','Web-ISAPI-Filter','Web-Http-Logging','Web-Request-Monitor','Web-Basic-Auth','Web-Windows-Auth','Web-Filtering','Web-Performance','Web-Mgmt-Console'),
 [string]$appPoolName="mypool",
 [string]$siteName="mysite",
 [string]$appName="myapp",
 [string]$sitePath="c:\www"
)
Import-Module ServerManager 

#Add-WindowsFeature -Name Web-Common-Http,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Http-Logging,Web-Request-Monitor,Web-Basic-Auth,Web-Windows-Auth,Web-Filtering,Web-Performance,Web-Mgmt-Console -IncludeAllSubFeature
Add-WindowsFeature -Name $iis_modules -IncludeAllSubFeature

New-Item -Path $sitePath -type directory -Force -ErrorAction SilentlyContinue

$Command = "icacls $sitePath /grant BUILTIN\IIS_IUSRS:(OI)(CI)(RX) BUILTIN\Users:(OI)(CI)(RX)"
cmd.exe /c $Command

#[System.Reflection.Assembly]::LoadFrom( "C:\windows\system32\inetsrv\Microsoft.Web.Administration.dll" )
Import-Module WebAdministration

iex 'C:\Windows\System32\inetsrv\appcmd set config /section:urlCompression /doDynamicCompression:False'
Stop-Website -Name "Default Web Site"
Remove-Website -Name "Default Web Site"

Write-Host "Creating application pool ($appPoolName)...`r`n"
$appPool = New-WebAppPool -Name $appPoolName
Write-Host "Setting app pool identity...`r`n"
Set-ItemProperty IIS:\AppPools\$appPoolName -Name managedRuntimeVersion -Value v4.0
Set-ItemProperty IIS:\AppPools\$appPoolName -Name ProcessModel.IdentityType -value 2
Set-ItemProperty IIS:\AppPools\$appPoolName -Name processModel.idleTimeout -Value "00:00:00"
Set-ItemProperty IIS:\AppPools\$appPoolName -Name processModel.shutdownTimeLimit -Value "00:03:00"
Set-ItemProperty IIS:\AppPools\$appPoolName -Name processModel.maxProcesses -Value 0
Set-ItemProperty IIS:\AppPools\$appPoolName -Name recycling.periodicRestart.privateMemory 1600000
Set-ItemProperty IIS:\AppPools\$appPoolName -Name failure.rapidFailProtectionMaxCrashes -Value 30
Set-ItemProperty IIS:\AppPools\$appPoolName -Name enable32BitAppOnWin64 -Value $false
Write-Host "Finished configuring app pool ($appPoolName) `r`n"

Write-Host "Creating site ($siteName)...`r`n"
$site = New-WebSite -Name $siteName -ApplicationPool $appPoolName -PhysicalPath $sitePath -Force

Write-Host "Creating application ($appName)...`r`n"
$site = New-WebApplication -Name $appName -ApplicationPool $appPoolName -PhysicalPath $sitePath -Site $siteName -Force

#Create a test index.html for IIS
$text = "Hello! <br> IIS server greetings you."
$text > $sitePath\index.html
