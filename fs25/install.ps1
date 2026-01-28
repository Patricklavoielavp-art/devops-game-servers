# FS25/install.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Chargement du loader YAML
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ROOT\yaml.ps1"

Write-Host "=== Installation FS25 ===" -ForegroundColor Cyan

Import-Module powershell-yaml

$ConfigPath = Join-Path $ROOT "..\..\config.yaml"
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

# Lecture du YAML
$InstallDir = $Config.gameservers.fs25.install_dir
$User = $Config.gameservers.fs25.user
$AppID = $Config.gameservers.fs25.appid
$BackupDir = $Config.gameservers.fs25.backup.source

# Vérification SteamCMD
$SteamCmd = "C:\steamcmd\steamcmd.exe"
if (-not (Test-Path $SteamCmd)) {
    Write-Host "Installation de SteamCMD..."
    New-Item -ItemType Directory -Force -Path "C:\steamcmd" | Out-Null
    Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile "C:\steamcmd\steamcmd.zip"
    Expand-Archive -Path "C:\steamcmd\steamcmd.zip" -DestinationPath "C:\steamcmd" -Force
    Remove-Item "C:\steamcmd\steamcmd.zip"
}

# Création de l'utilisateur si nécessaire
if (-not (Get-LocalUser -Name $User -ErrorAction SilentlyContinue)) {
    Write-Host "Création de l'utilisateur $User..."
    New-LocalUser -Name $User -NoPassword
}

# Création des dossiers
Write-Host "Création des dossiers..."
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

# Installation FS25 via SteamCMD
Write-Host "Téléchargement du serveur FS25 via SteamCMD..."
& $SteamCmd +login anonymous +force_install_dir "$InstallDir" +app_update $AppID validate +quit

Write-Host "Installation FS25 terminée." -ForegroundColor Green