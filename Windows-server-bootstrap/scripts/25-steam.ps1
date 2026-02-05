# scripts/25-steam.ps1
$SteamInstaller = "$env:TEMP\SteamSetup.exe"
Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" -OutFile $SteamInstaller
Start-Process -FilePath $SteamInstaller -ArgumentList "/S" -Wait
Write-Host "✅ Steam Desktop installed"
