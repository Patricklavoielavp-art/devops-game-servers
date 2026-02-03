param(
    [Parameter(Mandatory=$true)]
    [string]$InstanceName
)

$ErrorActionPreference = "Stop"

# Base paths
$ROOT = "C:\devops-game-servers"
$InstanceName = $InstanceName.ToLower()
$InstancePath = Join-Path $ROOT "fs25\instances\$InstanceName"

# Créer dossiers de l'instance
foreach ($sub in @("Saved","Mods","logs","Backups")) {
    $subPath = Join-Path $InstancePath $sub
    if (-not (Test-Path $subPath)) { New-Item -ItemType Directory -Force -Path $subPath | Out-Null }
}

# Donner toutes permissions à l'utilisateur courant
icacls $InstancePath /grant "$($env:USERNAME):F" /T | Out-Null

# Chemin vers l'exe FS25
$ExePath = "C:\Program Files (x86)\Steam\steamapps\common\Farming Simulator 25\dedicatedServer.exe"
$ExeDir  = Split-Path $ExePath

# Chemins internes
$SavedDir = Join-Path $InstancePath "Saved"
$LogDir   = Join-Path $InstancePath "logs"
$ServerLog = Join-Path $LogDir "fs25_server.log"

# Nettoyer la DB lock si existante
$DBFiles = Join-Path $SavedDir "dedicated_server\*.db-journal"
if (Test-Path $DBFiles) { Remove-Item $DBFiles -Force }

# Arguments serveur
$Args = "-saveDir `"$SavedDir`" -log"

Write-Host "Lancement de FS25 ($InstanceName)..."
Start-Process -FilePath $ExePath -ArgumentList $Args -WorkingDirectory $ExeDir -WindowStyle Normal
Write-Host "Serveur lancé. Vérifie le log dans : $ServerLog"
