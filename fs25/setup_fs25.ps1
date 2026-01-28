<#
    FS25 - SETUP COMPLET
    Auteur : Patrick
    Installation complète de FS25
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ">>> FS25 SETUP START <<<" -ForegroundColor Cyan

# --------------------------------------------------
# Détermination des chemins
# --------------------------------------------------

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT  = Split-Path -Parent $SCRIPT_DIR

Write-Host "Script dir : $SCRIPT_DIR" -ForegroundColor DarkGray
Write-Host "Repo root  : $REPO_ROOT"  -ForegroundColor DarkGray

# --------------------------------------------------
# Chargement YAML
# --------------------------------------------------

Import-Module powershell-yaml -ErrorAction Stop

$ConfigPath = Join-Path $REPO_ROOT "config.yaml"

if (-not (Test-Path $ConfigPath)) {
    throw "config.yaml introuvable : $ConfigPath"
}

$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

Write-Host "Configuration YAML chargée" -ForegroundColor Green

# --------------------------------------------------
# Extraction config FS25 (SAFE)
# --------------------------------------------------

if (-not $Config.gameservers) {
    throw "Clé 'gameservers' absente du YAML"
}

if (-not $Config.gameservers.fs25) {
    throw "Clé 'gameservers.fs25' absente du YAML"
}

$Fs25 = $Config.gameservers.fs25

$InstallDir  = $Fs25.install_dir  ?? (throw "install_dir manquant")
$ServiceName = $Fs25.service_name ?? (throw "service_name manquant")
$GamePort    = $Fs25.ports.game   ?? (throw "ports.game manquant")

Write-Host "FS25 install_dir  : $InstallDir"
Write-Host "FS25 service_name : $ServiceName"
Write-Host "FS25 port         : $GamePort"

# --------------------------------------------------
# Étape 1 - Installation
# --------------------------------------------------

Write-Host "Étape 1/4 : Installation FS25..."
pwsh -ExecutionPolicy Bypass -File (Join-Path $SCRIPT_DIR "install.ps1")

# --------------------------------------------------
# Étape 2 - Update
# --------------------------------------------------

Write-Host "Étape 2/4 : Mise à jour FS25..."
pwsh -ExecutionPolicy Bypass -File (Join-Path $SCRIPT_DIR "update.ps1")

# --------------------------------------------------
# Étape 3 - Service Windows (NSSM)
# --------------------------------------------------

Write-Host "Étape 3/4 : Création du service Windows..."

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

& $nssm install $ServiceName "pwsh.exe" "-ExecutionPolicy Bypass -File `"$StartScript`""
& $nssm set $ServiceName AppDirectory $InstallDir
& $nssm set $ServiceName Start SERVICE_AUTO_START

Write-Host "Service Windows créé : $ServiceName" -ForegroundColor Green

# --------------------------------------------------
# Étape 4 - Démarrage
# --------------------------------------------------

Write-Host "Étape 4/4 : Démarrage du service FS25..."
Start-Service $ServiceName

# --------------------------------------------------
# Vérification du port
# --------------------------------------------------

Write-Host "Vérification du port $GamePort..."
Start-Sleep 5

if ((Test-NetConnection localhost -Port $GamePort -WarningAction SilentlyContinue).TcpTestSucceeded) {
    Write-Host "FS25 fonctionne sur le port $GamePort" -ForegroundColor Green
} else {
    Write-Host "FS25 ne répond pas encore sur le port $GamePort" -ForegroundColor Yellow
}

Write-Host ">>> INSTALLATION FS25 TERMINÉE <<<" -ForegroundColor Green
