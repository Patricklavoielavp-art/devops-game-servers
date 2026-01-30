<#
.SYNOPSIS
    Lancer un serveur FS25 pour une instance donnée.

.PARAMETER InstanceName
    Nom de l'instance à lancer (obligatoire).

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$InstanceName
)

$ErrorActionPreference = "Stop"

# Base paths
$ROOT = "C:\devops-game-servers"

# Toujours en minuscules pour tolérer la casse
$InstanceName = $InstanceName.ToLower()

# Instance path
$InstancePath = Join-Path $ROOT "fs25\$InstanceName"
if (-not (Test-Path $InstancePath)) {
    Write-Host "Création du dossier de l'instance : $InstancePath"
    New-Item -ItemType Directory -Force -Path $InstancePath | Out-Null
}

# Créer les sous-dossiers nécessaires
foreach ($sub in @("Saved","Mods","logs","Backups")) {
    $subPath = Join-Path $InstancePath $sub
    if (-not (Test-Path $subPath)) {
        Write-Host "Création du dossier : $subPath"
        New-Item -ItemType Directory -Force -Path $subPath | Out-Null
    }
}

Write-Host "Instance path : $InstancePath"

# Charger config YAML
Import-Module powershell-yaml -ErrorAction Stop
$ConfigPath = Join-Path $ROOT "config.yaml"
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

# Récupérer configuration de l'instance
$InstanceCfg = $FS25.instances | Where-Object { $_.name.ToLower() -eq $InstanceName }
if (-not $InstanceCfg) { throw "Instance '$InstanceName' not found in config" }

# Variables
$ExePath  = Join-Path $FS25.install_dir "DedicatedServer.exe"
$LogDir   = Join-Path $InstancePath "logs"
$ServerLog = Join-Path $LogDir "fs25_server.log"
$WrapperLog = Join-Path $LogDir "fs25_wrapper.log"
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
if ($InstanceCfg.mods.Count -gt 0 -and $InstanceCfg.mods[0] -ne $null) {
    $ModsParam = $InstanceCfg.mods -join ","
    $Args += "?Mods=$ModsParam"
}
$Args += " -log"

# Fonction log wrapper
function Log { param([string]$M)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $M" | Out-File -Append -FilePath $WrapperLog -Encoding UTF8
}

# Backup fonctionnel
function Run-Backup {
    try {
        $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $ZipPath = Join-Path $BackupDst "FS25_$Stamp.zip"
        Compress-Archive -Path "$SavedDir\*" -DestinationPath $ZipPath -CompressionLevel Optimal
        # Supprimer anciens backups
        Get-ChildItem $BackupDst -Filter "FS25_*.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } | Remove-Item -Force
        Log "Backup OK : FS25_$Stamp.zip"
    } catch { Log "Erreur backup : $_" }
}

# Rotation logs wrapper
if (Test-Path $WrapperLog) { Move-Item $WrapperLog (Join-Path $LogDir "fs25_wrapper_$(Get-Date -Format yyyyMMdd_HHmmss).log") -Force }
New-Item -ItemType File -Force -Path $WrapperLog | Out-Null

# Lancer le serveur
if (-not (Test-Path $ExePath)) { Log "Erreur : DedicatedServer.exe introuvable"; exit 1 }

$Process = Start-Process -FilePath $ExePath `
    -ArgumentList $Args `
    -WorkingDirectory $FS25.install_dir `
    -NoNewWindow -PassThru `
    -RedirectStandardOutput $ServerLog 

Log "FS25 lancé (PID=$($Process.Id))"

# Monitor boucle simple
while ($true){
    Start-Sleep -Seconds 60
    if (-not (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) { Log "FS25 arrêté"; exit 1 }
}
