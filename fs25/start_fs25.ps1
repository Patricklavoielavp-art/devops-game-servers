# start_fs25.ps1
# Lance le serveur FS25 (SYSTEM-ready)
# Author: Patrick
# Date: 2026-01-29

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# -----------------------------
# Configuration des chemins
# -----------------------------
$ROOT = "C:\devops-game-servers"
$FS25Dir = "C:\FS25"               # Le dossier d'installation FS25
$SteamCmd = "C:\steamcmd\steamcmd.exe"
$LogFile = Join-Path $FS25Dir "logs\fs25_start.log"

# -----------------------------
# Fonction de log
# -----------------------------
function Log {
    param([string]$Message)
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Text = "$Time - $Message"
    Write-Host $Text
    Add-Content -Path $LogFile -Value $Text
}

# -----------------------------
# Vérifications préalables
# -----------------------------
if (-not (Test-Path $FS25Dir)) {
    Log "Erreur: dossier FS25 introuvable: $FS25Dir"
    exit 1
}

if (-not (Test-Path $SteamCmd)) {
    Log "Erreur: SteamCMD introuvable: $SteamCmd"
    exit 1
}

if (-not (Test-Path $LogFile)) {
    New-Item -ItemType File -Force -Path $LogFile | Out-Null
}

# -----------------------------
# Lancement du serveur
# -----------------------------
try {
    Log "Demarrage serveur FS25..."
    $ExePath = Join-Path $FS25Dir "ShooterGame\Binaries\Win64\ShooterGameServer.exe"
    if (-not (Test-Path $ExePath)) {
        Log "Erreur: executable FS25 introuvable: $ExePath"
        exit 1
    }

    # Commande de lancement (modifie selon ta config YAML si necessaire)
    $Args = "TheIsland?listen?SessionName=FS25Server?MaxPlayers=10 -log"
    
    Start-Process -FilePath $ExePath -ArgumentList $Args -WorkingDirectory $FS25Dir -NoNewWindow -PassThru | Out-Null
    Log "Serveur FS25 demarre avec succes."
}
catch {
    Log "Erreur lors du demarrage du serveur: $_"
    exit 1
}
