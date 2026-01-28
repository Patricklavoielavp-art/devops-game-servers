<#
    FS25 - UPDATE SCRIPT
    Author : Patrick
    Description : Met à jour le serveur FS25 via SteamCMD
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "==== Mise à jour FS25 ====" -ForegroundColor Cyan

# -----------------------------
# Paths & YAML
# -----------------------------
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT  = Split-Path -Parent $SCRIPT_DIR
$ConfigPath = Join-Path $REPO_ROOT "config.yaml"

if (-not (Test-Path $ConfigPath)) {
    throw "config.yaml introuvable : $ConfigPath"
}

Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$Fs25 = $Config.gameservers.fs25

# -----------------------------
# Variables
# -----------------------------
$InstallDir  = $Fs25.install_dir  ?? (throw "install_dir manquant")
$User        = $Fs25.user          ?? (throw "user manquant")
$AppID       = $Fs25.appid         ?? (throw "appid manquant")
$ServiceName = $Fs25.service_name  ?? (throw "service_name manquant")

Write-Host "InstallDir  : $InstallDir"
Write-Host "AppID       : $AppID"
Write-Host "ServiceName : $ServiceName"

# -----------------------------
# Vérification SteamCMD
# -----------------------------
$SteamCmd = "C:\steamcmd\steamcmd.exe"
if(-not (Test-Path $SteamCmd)) {
    Write-Host "SteamCMD n'est pas installé. Exécute d'abord install.ps1" -ForegroundColor Red
    exit 1
}

# -----------------------------
# Mise à jour via SteamCMD
# -----------------------------
Write-Host "Mise à jour du serveur FS25 via SteamCMD ..."

$steamArgs = @(
    "+force_install_dir", "$InstallDir"
    "+login", "anonymous"
    "+app_update", "$AppID", "validate"
    "+quit"
)

& $SteamCmd @steamArgs

Write-Host "Mise à jour FS25 terminée." -ForegroundColor Green

# -----------------------------
# Redémarrage service Windows
# -----------------------------
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Redémarrage du service Windows : $ServiceName"
    Restart-Service -Name $ServiceName -Force
    Write-Host "Mise à jour + redémarrage complètés." -ForegroundColor Green
} else {
    Write-Host "Service $ServiceName introuvable. Redémarrage ignoré." -ForegroundColor Yellow
}