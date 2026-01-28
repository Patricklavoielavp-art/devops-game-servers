<#
    FS25- SETUP COMPLET
    Autheur : Patrick
    Installation complete de FS25
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Chargement du loader YAML
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ROOT\yaml.ps1"

Write-Host "=== Initialisation du serveur FS25 ===" -ForegroundColor Cyan

Import-Module powershell-yaml




$ConfigPath = Join-Path $ROOT "..\..\config.yaml"

echo "$ConfigPath" 

$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

echo "$Config"

# Lecture du YAML
$InstallDir  = $Config.gameservers.fs25.install_dir
$ServiceName = $Config.gameservers.fs25.service_name
$GamePort    = $Config.gameservers.fs25.ports.game"

# 1. Installation
Write-Host "Étape 1/4 : Installation du serveur FS25..."
pwsh.exe -ExecutionPolicy Bypass -File "$ROOT\install.ps1"

# 2. Mise à jour
Write-Host "Étape 2/4 : Mise à jour du serveur FS25..."
pwsh.exe -ExecutionPolicy Bypass -File "$ROOT\update.ps1"

# 3. Création du service Windows (via NSSM)
Write-Host "Étape 3/4 : Création du service Windows..."

$nssm = "C:\nssm\nssm.exe"
if (-not (Test-Path $nssm)) {
    Write-Host "Installation de NSSM..."
    New-Item -ItemType Directory -Force -Path "C:\nssm" | Out-Null
    Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "C:\nssm\nssm.zip"
    Expand-Archive -Path "C:\nssm\nssm.zip" -DestinationPath "C:\nssm" -Force
    Remove-Item "C:\nssm\nssm.zip"
    $nssm = "C:\nssm\nssm-2.24\win64\nssm.exe"
}

$StartScript = Join-Path $ROOT "start_fs25.ps1"

& $nssm install $ServiceName "pwsh.exe" " -ExecutionPolicy Bypass -File `"$StartScript`""
& $nssm set $ServiceName AppDirectory $InstallDir
& $nssm set $ServiceName Start SERVICE_AUTO_START

Write-Host "Service Windows créé : $ServiceName" -ForegroundColor Green

# 4. Démarrage du service
Write-Host "Étape 4/4 : Démarrage du service FS25..."
Start-Service -Name $ServiceName

# 5. Vérification du port
Write-Host "Vérification du port $GamePort..."
Start-Sleep -Seconds 5

$Connection = Test-NetConnection -ComputerName "localhost" -Port $GamePort -WarningAction SilentlyContinue

if ($Connection.TcpTestSucceeded) {
    Write-Host "Le serveur FS25 fonctionne correctement sur le port $GamePort." -ForegroundColor Green
}
else {
    Write-Host "Le serveur FS25 ne répond pas encore sur le port $GamePort." -ForegroundColor Yellow
    Write-Host "Il peut prendre 1 à 2 minutes pour démarrer complètement."
}

Write-Host "Installation complète de FS25 terminée." -ForegroundColor Green
