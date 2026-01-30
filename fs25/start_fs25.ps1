# start_fs25.ps1
# FS25 Multi-instance avec Mods optionnels, Map, Session
# Logs rotation, backup, monitoring CPU/RAM
# Author: Patrick
# Windows Server 2022 / PS7

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [string]$InstanceName = "Vanilla"
)

# Charger config
$ROOT = "C:\devops-game-servers"
$ConfigPath = Join-Path $ROOT "config.yaml"
Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

$InstancePath = Join-Path $FS25.install_dir $InstanceName
Write-Host "Instance path : $InstancePath"

$InstanceCfg = $FS25.instances | Where-Object { $_.name -eq $InstanceName }
if (-not $InstanceCfg) { Write-Host "Erreur : instance '$InstanceName' non trouvée" -ForegroundColor Red; exit 1 }

# Variables
$ExePath  = Join-Path $FS25.install_dir "DedicatedServer.exe"
$LogDir   = Join-Path $InstancePath "logs"
$LogFile  = Join-Path $LogDir "fs25.log"
$SavedDir = Join-Path $InstancePath "Saved"
$ModsDir  = Join-Path $InstancePath "Mods"
$BackupDst= Join-Path $InstancePath "Backups"
$RetentionDays = $FS25.backup.retention_days

# Préparer dossiers
foreach ($d in @($LogDir, $SavedDir, $ModsDir, $BackupDst)) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

# Construire arguments du serveur
$Args = "$($InstanceCfg.map)?listen?SessionName=$($InstanceCfg.session_name)?MaxPlayers=$($InstanceCfg.max_players)"

# Ajouter les mods seulement s'ils existent
if ($InstanceCfg.mods -and $InstanceCfg.mods.Count -gt 0) {
    $ModsParam = $InstanceCfg.mods -join ","
    $Args += "?Mods=$ModsParam"
}

$Args += " -log"

# Fonction log
function Log { param([string]$M); $Time=Get-Date -Format "yyyy-MM-dd HH:mm:ss"; "$Time - $M" | Tee-Object -FilePath $LogFile }

# Rotation des logs
if (Test-Path $LogFile) { Move-Item $LogFile (Join-Path $LogDir "fs25_$(Get-Date -Format yyyyMMdd_HHmmss).log") -Force }
New-Item -ItemType File -Force -Path $LogFile | Out-Null

# Lancer FS25
try {
    if (-not (Test-Path $ExePath)) { Log "Erreur : DedicatedServer.exe introuvable"; exit 1 }

    $Process = Start-Process -FilePath $ExePath -ArgumentList $Args -WorkingDirectory $FS25.install_dir -NoNewWindow -PassThru -RedirectStandardOutput $LogFile -RedirectStandardError $LogFile
    Log "FS25 lancé (PID=$($Process.Id))"

    while ($true){
        Start-Sleep -Seconds 60
        if (-not (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) { Log "FS25 arrêté"; exit 1 }
    }
} catch {
    Log "CRASH FS25 : $_"
    exit 1
}
