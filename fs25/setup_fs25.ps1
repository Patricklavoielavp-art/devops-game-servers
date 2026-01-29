<#
    setup_fs25.ps1
    Installation et configuration automatique du serveur FS25
    - Telechargement des prerequis (SteamCMD, NSSM)
    - Creation de l'utilisateur
    - Creation et lancement du service Windows FS25
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ------------------------------
# ROOT et config
# ------------------------------
$ROOT = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ConfigPath = Join-Path $ROOT "config.yaml"

if (-not (Test-Path $ConfigPath)) {
    Write-Host "Config YAML introuvable: $ConfigPath" -ForegroundColor Red
    exit 1
}

# Chargement YAML
. "$ROOT\fs25\yaml.ps1"
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

$InstallDir = $Config.gameservers.fs25.install_dir
$User = $Config.gameservers.fs25.user
$AppID = $Config.gameservers.fs25.appid
$ServiceName = $Config.gameservers.fs25.service_name
$BackupDir = $Config.gameservers.fs25.backup.source

# ------------------------------
# SteamCMD
# ------------------------------
$SteamCmdPath = "C:\steamcmd\steamcmd.exe"
if (-not (Test-Path $SteamCmdPath)) {
    Write-Host "Installation de SteamCMD..."
    New-Item -ItemType Directory -Force -Path "C:\steamcmd" | Out-Null
    Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile "C:\steamcmd\steamcmd.zip"
    Expand-Archive -Path "C:\steamcmd\steamcmd.zip" -DestinationPath "C:\steamcmd" -Force
    Remove-Item "C:\steamcmd\steamcmd.zip"
    Write-Host "SteamCMD installe avec succes."
}

# ------------------------------
# NSSM
# ------------------------------
$NssmPath = "C:\nssm\nssm.exe"
if (-not (Test-Path $NssmPath)) {
    Write-Host "Installation de NSSM..."
    New-Item -ItemType Directory -Force -Path "C:\nssm" | Out-Null
    Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "C:\nssm\nssm.zip"
    Expand-Archive -Path "C:\nssm\nssm.zip" -DestinationPath "C:\nssm" -Force
    Remove-Item "C:\nssm\nssm.zip"
    Write-Host "NSSM installe avec succes."
}

# ------------------------------
# Creation de l'utilisateur
# ------------------------------
if (-not (Get-LocalUser -Name $User -ErrorAction SilentlyContinue)) {
    Write-Host "Creation de l'utilisateur $User..."
    New-LocalUser -Name $User -NoPassword
    Write-Host "Utilisateur $User cree."
}

# ------------------------------
# Creation des dossiers
# ------------------------------
Write-Host "Creation des dossiers..."
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
Write-Host "Dossiers crees."

# ------------------------------
# Installation FS25 via SteamCMD
# ------------------------------
if (-not (Test-Path (Join-Path $InstallDir "ShooterGame"))) {
    Write-Host "Installation du serveur FS25..."
    & $SteamCmdPath +force_install_dir "$InstallDir" +login anonymous +app_update $AppID validate +quit
    Write-Host "Installation FS25 terminee."
} else {
    Write-Host "FS25 deja installe, installation ignoree."
}

# ------------------------------
# Creation du service Windows FS25
# ------------------------------
$ServiceExists = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($ServiceExists) {
    Write-Host "Service $ServiceName existe deja. Arret et suppression..."
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    & "$NssmPath" remove $ServiceName confirm
    Write-Host "Service supprime."
}

Write-Host "Creation du service $ServiceName..."
& "$NssmPath" install $ServiceName "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-ExecutionPolicy Bypass -File `"$InstallDir\start_fs25.ps1`""
Write-Host "Service cree."

# ------------------------------
# Demarrage du service
# ------------------------------
try {
    Start-Service -Name $ServiceName
    Write-Host "Service $ServiceName demarre avec succes." -ForegroundColor Green
} catch {
    Write-Host "Erreur: impossible de demarrer le service $ServiceName." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
