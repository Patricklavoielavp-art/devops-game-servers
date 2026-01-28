<#
    FS25- SETUP COMPLET
    Autheur : Patrick
    Installation complete de FS25
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ">>> FS25 SETUP START <<<" -ForegroundColor Cyan

# -------------------------------------------------------------------
# Paths
# -------------------------------------------------------------------
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigPath = Join-Path $ROOT "..\..\config.yaml"

Write-Host "ROOT        : $ROOT" -ForegroundColor DarkGray
Write-Host "Config YAML : $ConfigPath" -ForegroundColor DarkGray

# -------------------------------------------------------------------
# Vérification du YAML
# -------------------------------------------------------------------
if (-not (Test-Path $ConfigPath)) {
    throw "config.yaml introuvable : $ConfigPath"
}

# -------------------------------------------------------------------
# Chargement du module YAML
# -------------------------------------------------------------------
try {
    Import-Module powershell-yaml -ErrorAction Stop
    Write-Host "Module powershell-yaml chargé" -ForegroundColor Green
}
catch {
    throw "Module powershell-yaml non disponible. Installe-le avec : Install-Module powershell-yaml -Scope AllUsers"
}

# -------------------------------------------------------------------
# Lecture du YAML
# -------------------------------------------------------------------
try {
    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
    Write-Host "Configuration YAML chargée" -ForegroundColor Green
}
catch {
    throw "Erreur de lecture du fichier YAML : $($_.Exception.Message)"
}

# -------------------------------------------------------------------
# Extraction des valeurs
# -------------------------------------------------------------------
try {
    $Fs25Config  = $Config.gameservers.fs25

    $InstallDir  = $Fs25Config.install_dir
    $ServiceName = $Fs25Config.service_name
    $GamePort    = $Fs25Config.ports.game
}
catch {
    throw "Structure YAML invalide. Vérifie gameservers.fs25.*"
}

Write-Host "InstallDir  : $InstallDir"
Write-Host "ServiceName : $ServiceName"
Write-Host "GamePort    : $GamePort"

# -------------------------------------------------------------------
# 1. Installation
# -------------------------------------------------------------------
Write-Host "`n[1/4] Installation FS25..." -ForegroundColor Cyan
pwsh -ExecutionPolicy Bypass -File "$ROOT\install.ps1"

# -------------------------------------------------------------------
# 2. Mise à jour
# -------------------------------------------------------------------
Write-Host "`n[2/4] Mise à jour FS25..." -ForegroundColor Cyan
pwsh -ExecutionPolicy Bypass -File "$ROOT\update.ps1"

# -------------------------------------------------------------------
# 3. Création du service Windows (NSSM)
# -------------------------------------------------------------------
Write-Host "`n[3/4] Création du service Windows..." -ForegroundColor Cyan

$NssmRoot = "C:\nssm"
$NssmExe  = "$NssmRoot\nssm.exe"

if (-not (Test-Path $NssmExe)) {
    Write-Host "NSSM non trouvé, installation en cours..." -ForegroundColor Yellow

    New-Item -ItemType Directory -Force -Path $NssmRoot | Out-Null
    Invoke-WebRequest `
        -Uri "https://nssm.cc/release/nssm-2.24.zip" `
        -OutFile "$NssmRoot\nssm.zip"

    Expand-Archive "$NssmRoot\nssm.zip" $NssmRoot -Force
    Remove-Item "$NssmRoot\nssm.zip"

    $NssmExe = "$NssmRoot\nssm-2.24\win64\nssm.exe"
}

$StartScript = Join-Path $ROOT "start_fs25.ps1"

& $NssmExe install $ServiceName "pwsh.exe" "-ExecutionPolicy Bypass -File `"$StartScript`""
& $NssmExe set $ServiceName AppDirectory $InstallDir
& $NssmExe set $ServiceName Start SERVICE_AUTO_START

Write-Host "Service créé : $ServiceName" -ForegroundColor Green

# -------------------------------------------------------------------
# 4. Démarrage du service
# -------------------------------------------------------------------
Write-Host "`n[4/4] Démarrage du service FS25..." -ForegroundColor Cyan

if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Start-Service -Name $ServiceName
}

# -------------------------------------------------------------------
# Vérification du port
# -------------------------------------------------------------------
Write-Host "`nVérification du port $GamePort..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

$Connection = Test-NetConnection -ComputerName "localhost" -Port $GamePort -WarningAction SilentlyContinue

if ($Connection.TcpTestSucceeded) {
    Write-Host "FS25 opérationnel sur le port $GamePort" -ForegroundColor Green
}
else {
    Write-Host "FS25 ne répond pas encore sur le port $GamePort" -ForegroundColor Yellow
    Write-Host "Le démarrage peut prendre 1 à 2 minutes"
}

Write-Host "`n>>> FS25 SETUP TERMINÉ <<<" -ForegroundColor Green