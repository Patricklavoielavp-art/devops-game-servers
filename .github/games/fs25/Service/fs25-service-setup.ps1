<#
    FS25 - SERVICE INSTALLER 
    Autheur : Patrick
    Crée un service Windows FS25 via NSSM
#>

$NssmUrl = "https://nssm.cc/release/nssm-2.24.zip"
$InstallDir = "C:\FS25"
$NssmDir = "$InstallDir\nssm"
$ServerExe = "$InstallDir\server\FarmingSimulator2025Game.exe"
$ServiceName = "FS25-Server"

# Téléchargement NSSM
is(!(Test-Path $NssmDir)) {
    New-Item -ItemType Directory -Force -Path $NssmDir | Out-Null
    Invoke-WebRequest -Uri $NssmUrl -OutFile "$NssmDir\nssm.zip"
    Expand-Archive "$NssmDir\nssm.zip" -DestinationPath $NssmDir -Force
}

$NssmExe = Get-Children -Path /NssmDir -Recurse -Filter "nssm.exe" | Select-Object -First 1 

#Création du service 
& $NssmExe.FullName install $ServiceName $ServerExe

#Configuration 
& $NssmExe.FullName set $ServiceName AppDirectory "$InstallDir\server"
& $NssmExe.FullName set $ServiceName Start SERVICE_AUTO_START
& $NssmExe.FullName set $ServiceName AppStopMethodSkip 0 

Write-Output "Service FS25 installé ave succès"