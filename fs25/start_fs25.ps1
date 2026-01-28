<#
    FS25 - START SCRIPT
    Autheur : Patrick
    Démarre le serveur FS25 en mode standalone ou via service 
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Chargement du loader YAML
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ROOT\yaml.ps1"

Write-Host "=== Démarrage du serveur FS25 ===" -ForegroundColor Cyan

# Lecture du YAML
$InstallDir = Get-YamlValue ".gameservers.fs25.install_dir"
$GamePort   = Get-YamlValue ".gameservers.fs25.ports.game"

# Vérification du dossier d'installation
if (-not (Test-Path $InstallDir)) {
    Write-Host "Le dossier FS25 n'existe pas : $InstallDir" -ForegroundColor Red
    exit 1
}

# Exécutable du serveur FS25
$ExePath = Join-Path $InstallDir "FarmingSimulator2025Game.exe"

if (-not (Test-Path $ExePath)) {
    Write-Host "Executable introuvable : $ExePath" -ForegroundColor Red
    exit 1
}

Write-Host "Lancement du serveur FS25..."

# Construction de la commande
$Args = @(
    "-server"
    "-port=$GamePort"
)

Write-Host "Commande exécutée : $ExePath $($Args -join ' ')"

# Exécution (remplace le processus courant → parfait pour un service Windows)
Start-Process -FilePath $ExePath -ArgumentList $Args -WorkingDirectory $InstallDir -NoNewWindow