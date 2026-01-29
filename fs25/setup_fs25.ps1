<#
    FS25 - SETUP IDEMPOTENT
    Auteur : Patrick
    Description : Installation complète et sûre du serveur FS25
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=== FS25 SETUP (IDEMPOTENT) ===" -ForegroundColor Cyan

# --------------------------------------------------
# Paths & YAML
# --------------------------------------------------
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT  = Split-Path -Parent $SCRIPT_DIR
$ConfigPath = Join-Path $REPO_ROOT "config.yaml"

Import-Module powershell-yaml -ErrorAction Stop

if (-not (Test-Path $ConfigPath)) {
    throw "config.yaml introuvable : $ConfigPath"
}

$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$Fs25   = $Config.gameservers.fs25

$InstallDir  = $Fs25.install_dir
$ServiceName = $Fs25.service_name
$GamePort    = $Fs25.ports.game

# --------------------------------------------------
# Etape 1 - Installation (si absente)
# --------------------------------------------------
if (-not (Test-Path $InstallDir)) {
    Write-Host "Etape 1/4 : Installation FS25..."
    pwsh -ExecutionPolicy Bypass -File (Join-Path $SCRIPT_DIR "install.ps1")
} else {
    Write-Host "Etape 1/4 : FS25 deja installE → SKIP" -ForegroundColor Yellow
}

# --------------------------------------------------
# Etape 2 - Mise à jour (si installE)
# --------------------------------------------------
if (Test-Path $InstallDir) {
    Write-Host "Etape 2/4 : Mise a jour FS25..."
    pwsh -ExecutionPolicy Bypass -File (Join-Path $SCRIPT_DIR "update.ps1")
} else {
    Write-Host "Etape 2/4 : Installation absente → SKIP update" -ForegroundColor Yellow
}

# --------------------------------------------------
# Etape 3 - Service Windows (crEation si absent)
# --------------------------------------------------
Write-Host "Etape 3/4 : Verification du service Windows..."

$nssm = "C:\nssm\nssm.exe"
if (-not (Test-Path $nssm)) {
    Write-Host "Installation de NSSM..."
    New-Item -ItemType Directory -Force -Path "C:\nssm" | Out-Null
    Invoke-WebRequest "https://nssm.cc/release/nssm-2.24.zip" -OutFile "C:\nssm\nssm.zip"
    Expand-Archive "C:\nssm\nssm.zip" "C:\nssm" -Force
    Remove-Item "C:\nssm\nssm.zip"
    $nssm = "C:\nssm\nssm-2.24\win64\nssm.exe"
}

$StartScript = Join-Path $SCRIPT_DIR "start_fs25.ps1"

if (-not (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue)) {
    & $nssm install $ServiceName "pwsh.exe" "-ExecutionPolicy Bypass -File `"$StartScript`""
    & $nssm set $ServiceName AppDirectory $InstallDir
    & $nssm set $ServiceName Start SERVICE_AUTO_START
    Write-Host "Service Windows crEE : $ServiceName" -ForegroundColor Green
} else {
    Write-Host "Service $ServiceName dEjà existant → SKIP crEation" -ForegroundColor Yellow
}

# --------------------------------------------------
# Etape 4 - DEmarrage / Restart intelligent
# --------------------------------------------------
$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($Service.Status -ne "Running") {
    Write-Host "DEmarrage du service Windows..."
    Start-Service $ServiceName
    Write-Host "Service dEmarrE." -ForegroundColor Green
} else {
    Write-Host "Service dEjà en cours d'exEcution → SKIP restart" -ForegroundColor Yellow
}

# --------------------------------------------------
# VErification du port
# --------------------------------------------------
Write-Host "VErification du port $GamePort..."
Start-Sleep 5

if ((Test-NetConnection localhost -Port $GamePort -WarningAction SilentlyContinue).TcpTestSucceeded) {
    Write-Host "FS25 fonctionne sur le port $GamePort" -ForegroundColor Green
} else {
    Write-Host "FS25 ne rEpond pas encore (dEmarrage en cours)" -ForegroundColor Yellow
}

Write-Host "=== FS25 SETUP TERMINE ===" -ForegroundColor Green
