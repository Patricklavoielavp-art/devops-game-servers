[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Installing Windows Updates..."

Install-PackageProvider -Name NuGet -Force 
Install-Module PSWindowsUpdate -Force 

Import-Module PSWindowsUpdate
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot