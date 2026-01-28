<#
    FS25 - SETUP COMPLET
    Auteur : Patrick
    Installation de FS25
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=== Installation FS25 ===" -ForegroundColor Cyan

# -----------------------------
# Paths
# -----------------------------
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT  = Split-Path -Parent $SCRIPT_DIR
$ConfigPath = Join-Path $REPO_ROOT "config.yaml"

if (-not (Test-Path $ConfigPath)) {
    throw "config.yaml introuvable : $ConfigPath"
}

# -----------------------------
# Module YAML
# -----------------------------
Import-Module powershell-yaml -ErrorAction Stop

# -----------------------------
# Lecture du YAML
# -----------------------------
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

$Fs25 = $Config.gameservers.fs25

$InstallDir  = $Fs25.install_dir  ?? (throw "install_dir manquant")
$User        = $Fs25.user          ?? (throw "user manquant")
$AppID       = $Fs25.appid         ?? (throw "appid manquant")
$BackupDir   = $Fs25.backup.source ?? (throw "backup.source manquant")

Write-Host "InstallDir : $InstallDir"
Write-Host "User       : $User"
Write-Host "AppID      : $AppID"
Write-Host "BackupDir  : $BackupDir"

# -----------------------------
# Vérification SteamCMD
# -----------------------------
$SteamCmd = "C:\steamcmd\steamcmd.exe"
if (-not (Test-Path $SteamCmd)) {
    Write-Host "Installation de SteamCMD..."
    New-Item -ItemType Directory -Force -Path "C:\steamcmd" | Out-Null
    Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile "C:\steamcmd\steamcmd.zip"
    Expand-Archive -Path "C:\steamcmd\steamcmd.zip" -DestinationPath "C:\steamcmd" -Force
    Remove-Item "C:\steamcmd\steamcmd.zip"
}

# -----------------------------
# Création de l'utilisateur si nécessaire
# -----------------------------
if (-not (Get-LocalUser -Name $User -ErrorAction SilentlyContinue)) {
    Write-Host "Création de l'utilisateur $User..."
    try {
        New-LocalUser -Name $User -NoPassword
    } catch {
        Write-Host "Impossible de créer l'utilisateur. Vérifie les droits Admin." -ForegroundColor Red
    }
}

# -----------------------------
# Création des dossiers
# -----------------------------
Write-Host "Création des dossiers..."
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

# -----------------------------
# Installation FS25 via SteamCMD
# -----------------------------
Write-Host "Téléchargement du serveur FS25 via SteamCMD..."

$steamArgs = @(
    "+force_install_dir", "$InstallDir"
    "+login", "anonymous"
    "+app_update", "$AppID", "validate"
    "+quit"
)

& $SteamCmd @steamArgs

Write-Host "Installation FS25 terminée." -ForegroundColor Green