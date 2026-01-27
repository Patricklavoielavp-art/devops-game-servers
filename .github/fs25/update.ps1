<#
    FS25 - UPDATE SCRIPT
    Author : Patrick
    Description : Met à jour le serveur FS25 via SteamCMD
#>

# Chargement du loader YAML 
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ROOT\yaml.ps1"

Write-Host "==== Mise à jour FS25 ====" -ForegroundColor Cyan

# Lecture du YAML 
$InstallDir = Get-YamlValue ".gameservers.fs25.install_dir"
$User = Get-YamlValue ".gameservers.fs25.user"
$AppID = Get-YamlValue ".gamservers.fs25.appid"
$ServiceName = Get-YamlValue ".gameservers.fs25.service_name"

# Vérification SteamCMD
$SteamCmd = "C:\steamcmd\steamcmd.exe"
if(-not (Test-Path $SteamCmd)) {
    Write-Host "SteamCMD n'est pas installé.Exécute d'abord install.ps1" -ForegroundColor Red
    exit 1
}

# Mise à jour via SteamCMD 
Write-Host "Mise à jour du serveur FS25 via SteamCMD ..."
& $SteamCmd +login anonymous +force_install_dir "$InstallDir" +app_update "$AppID" validate +quit

Write-Host "Mise à jour FS25 terminée." -ForegroundColor Green

# Redémarrage automatique du service Windows
Write-Host "Redémarrage du service Windows : $ServiceName"
Restart-Service -Name $ServiceName -Force

Write-Host "Mise à jour + redémarrage complètés." -ForegroundColor Green