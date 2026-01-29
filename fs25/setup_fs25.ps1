<#
    FS25 - SETUP IDÉMPOTENT
    Auteur : Patrick
    Description : Installation complète et sûre du serveur FS25
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=== FS25 SETUP (IDÉMPOTENT) ===" -ForegroundColor Cyan

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
# Étape 1 - Installation (si absente)
# --------------------------------------------------
if (-not (Test-Path $InstallDir)) {
    Write-Host "Étape 1/4 : Installation FS25..."
    pwsh -ExecutionPolicy Bypass -File (Join-Path $SCRIPT_DIR "install.ps1")
} else {
    Write-Host "Étape 1/4 : FS25 déjà installé → SKIP" -ForegroundColor Yellow
}

# --------------------------------------------------
# Étape 2 - Mise à jour (si installé)
# --------------------------------------------------
if (Test-Path $InstallDir) {
    Write-Host "Étape 2/4 : Mise à jour FS25..."
    pwsh -ExecutionPolicy Bypass -File (Join-Path $SCRIPT_DIR "update.ps1")
} else {
    Write-Host "Étape 2/4 : Installation absente → SKIP update" -ForegroundColor Yellow
}

# --------------------------------------------------
# Étape 3 - Service Windows (création si absent)
# --------------------------------------------------
Write-Host "Étape 3/4 : Vérification du service Windows..."

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
    Write-Host "Service Windows créé : $ServiceName" -ForegroundColor Green
} else {
    Write-Host "Service $ServiceName déjà existant → SKIP création" -ForegroundColor Yellow
}

# --------------------------------------------------
# Étape 4 - Démarrage / Restart intelligent
# --------------------------------------------------
$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($Service.Status -ne "Running") {
    Write-Host "Démarrage du service Windows..."
    Start-Service $ServiceName
    Write-Host "Service démarré." -ForegroundColor Green
} else {
    Write-Host "Service déjà en cours d'exécution → SKIP restart" -ForegroundColor Yellow
}

# --------------------------------------------------
# Vérification du port
# --------------------------------------------------
Write-Host "Vérification du port $GamePort..."
Start-Sleep 5

if ((Test-NetConnection localhost -Port $GamePort -WarningAction SilentlyContinue).TcpTestSucceeded) {
    Write-Host "FS25 fonctionne sur le port $GamePort" -ForegroundColor Green
} else {
    Write-Host "FS25 ne répond pas encore (démarrage en cours)" -ForegroundColor Yellow
}

Write-Host "=== FS25 SETUP TERMINÉ ===" -ForegroundColor Green
