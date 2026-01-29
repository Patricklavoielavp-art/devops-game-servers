<#
    FS25 - SETUP COMPLET AUTOMATIQUE
    Author : Patrick
    Description : Installation complète et setup automatique du serveur FS25
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Définition des chemins ---
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigPath = Join-Path $ROOT "..\..\config.yaml"

# --- Vérification YAML ---
if (-not (Test-Path $ConfigPath)) {
    Write-Host "Config YAML introuvable à $ConfigPath" -ForegroundColor Red
    exit 1
}

# --- Chargement du YAML ---
Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

$InstallDir  = $Config.gameservers.fs25.install_dir
$BackupDir   = $Config.gameservers.fs25.backup.source
$User        = $Config.gameservers.fs25.user
$AppID       = $Config.gameservers.fs25.appid
$ServiceName = $Config.gameservers.fs25.service_name
$GamePort    = $Config.gameservers.fs25.ports.game

# --- Vérification SteamCMD ---
$SteamCmdDir = "C:\steamcmd"
$SteamCmd = Join-Path $SteamCmdDir "steamcmd.exe"
if (-not (Test-Path $SteamCmd)) {
    Write-Host "Téléchargement et extraction de SteamCMD..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $SteamCmdDir | Out-Null
    Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" `
                      -OutFile "$SteamCmdDir\steamcmd.zip"
    Expand-Archive -Path "$SteamCmdDir\steamcmd.zip" -DestinationPath $SteamCmdDir -Force
    Remove-Item "$SteamCmdDir\steamcmd.zip"
}

# --- Vérification NSSM ---
$NssmDir = "C:\nssm"
$NssmExe = Join-Path $NssmDir "nssm.exe"
if (-not (Test-Path $NssmExe)) {
    Write-Host "Téléchargement et extraction de NSSM..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $NssmDir | Out-Null
    Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "$NssmDir\nssm.zip"
    Expand-Archive -Path "$NssmDir\nssm.zip" -DestinationPath $NssmDir -Force
    Remove-Item "$NssmDir\nssm.zip"
    # NSSM est extrait dans nssm-2.24\win64
    $NssmExe = Join-Path $NssmDir "nssm-2.24\win64\nssm.exe"
}

# --- Création utilisateur ---
if (-not (Get-LocalUser -Name $User -ErrorAction SilentlyContinue)) {
    Write-Host "Création de l'utilisateur $User..." -ForegroundColor Cyan
    New-LocalUser -Name $User -NoPassword
}

# --- Création des dossiers ---
Write-Host "Création des dossiers..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

# --- Installation / mise à jour FS25 via SteamCMD ---
Write-Host "Installation / mise à jour du serveur FS25..." -ForegroundColor Cyan
$steamArgs = @(
    "+force_install_dir", "$InstallDir",
    "+login", "anonymous",
    "+app_update", "$AppID", "validate",
    "+quit"
)
& $SteamCmd @steamArgs

# --- Service Windows ---
$ServiceExists = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($ServiceExists) {
    Write-Host "Service $ServiceName déjà existant, arrêt et suppression..." -ForegroundColor Yellow
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    & $NssmExe remove $ServiceName confirm
}

Write-Host "Création du service Windows $ServiceName..." -ForegroundColor Cyan
$StartScript = Join-Path $ROOT "start_fs25.ps1"
& $NssmExe install $ServiceName "powershell.exe" "-ExecutionPolicy Bypass -File `"$StartScript`""
& $NssmExe set $ServiceName AppDirectory $InstallDir
& $NssmExe set $ServiceName Start SERVICE_AUTO_START

# --- Démarrage du service ---
Write-Host "Démarrage du service $ServiceName..." -ForegroundColor Cyan
Start-Service -Name $ServiceName

# --- Vérification du port ---
Write-Host "Vérification du port $GamePort..." -ForegroundColor Cyan
Start-Sleep -Seconds 5
$Connection = Test-NetConnection -ComputerName "localhost" -Port $GamePort -WarningAction SilentlyContinue
if ($Connection.TcpTestSucceeded) {
    Write-Host "Le serveur FS25 fonctionne sur le port $GamePort." -ForegroundColor Green
} else {
    Write-Host "Le serveur FS25 ne répond pas encore sur le port $GamePort. Attendez 1-2 minutes." -ForegroundColor Yellow
}

Write-Host "Setup FS25 terminé." -ForegroundColor Green
