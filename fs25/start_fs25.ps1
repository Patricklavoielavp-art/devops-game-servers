# start_fs25.ps1
# FS25 Multi-instance avec Mods, Map, Session
# Logs rotation, backup, monitoring CPU/RAM
# Author: Patrick
# Windows Server 2022 / PS7

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$InstancePath
)

# Charger config
$ROOT = "C:\devops-game-servers"
$ConfigPath = Join-Path $ROOT "config.yaml"
Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

$InstanceName = Split-Path $InstancePath -Leaf
$InstanceCfg = $FS25.instances | Where-Object { $_.name -eq $InstanceName }
if (-not $InstanceCfg) { Write-Host "Erreur : instance '$InstanceName' non trouvée" -ForegroundColor Red; exit 1 }

# Variables
$ExePath  = Join-Path $FS25.install_dir "FS25Server.exe"
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
if ($InstanceCfg.mods.Count -gt 0) {
    $ModsParam = $InstanceCfg.mods -join ","
    $Args += "?Mods=$ModsParam"
}
$Args += " -log"

# Fonction log
function Log { param([string]$M); $Time=Get-Date -Format "yyyy-MM-dd HH:mm:ss"; "$Time - $M" | Tee-Object -FilePath $LogFile }

# Fonction Discord
function Send-Discord { param([string]$M)
    if (-not $FS25.monitoring.enabled) { return }
    if ([string]::IsNullOrWhiteSpace($FS25.monitoring.discord_webhook)) { return }
    try { Invoke-RestMethod -Uri $FS25.monitoring.discord_webhook -Method Post -ContentType "application/json" -Body (@{ content = "🖥️ **FS25 [$InstanceName]**`n$M" } | ConvertTo-Json) } catch {}
}

# Monitor CPU/RAM
function Monitor-Ressources {
    try {
        $CPU = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
        $RAM = (Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples[0].CookedValue
        if ($CPU -gt $FS25.monitoring.cpu_alert) { Send-Discord "⚠️ CPU élevé : $([int]$CPU)%" }
        if ($RAM -gt $FS25.monitoring.ram_alert) { Send-Discord "⚠️ RAM élevé : $([int]$RAM)%" }
    } catch {}
}

# Rotation des logs
if (Test-Path $LogFile) { Move-Item $LogFile (Join-Path $LogDir "fs25_$(Get-Date -Format yyyyMMdd_HHmmss).log") -Force }
New-Item -ItemType File -Force -Path $LogFile | Out-Null

# Backup
function Run-Backup {
    try {
        $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $ZipPath = Join-Path $BackupDst "FS25_$Stamp.zip"
        Compress-Archive -Path "$SavedDir\*" -DestinationPath $ZipPath -CompressionLevel Optimal
        # Supprimer anciens backups
        Get-ChildItem $BackupDst -Filter "FS25_*.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } | Remove-Item -Force
        Send-Discord "💾 Backup OK : FS25_$Stamp.zip"
    } catch { Log "Erreur backup : $_"; Send-Discord "❌ Backup échoué : $_" }
}

# Job backup périodique
Start-Job -ScriptBlock { param($F) while ($true){ & $F; Start-Sleep -Seconds 3600 } } -ArgumentList ${function:Run-Backup} | Out-Null

# Lancer FS25
try {
    Run-Backup
    $Process = Start-Process -FilePath $ExePath -ArgumentList $Args -WorkingDirectory $FS25.install_dir -NoNewWindow -PassThru -RedirectStandardOutput $LogFile -RedirectStandardError $LogFile
    Log "FS25 lancé (PID=$($Process.Id))"
    Send-Discord "✅ Serveur FS25 [$InstanceName] démarré"

    while ($true){
        Monitor-Ressources
        Start-Sleep -Seconds 60
        if (-not (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) { Log "FS25 arrêté"; exit 1 }
    }
} catch {
    Log "CRASH FS25 : $_"
    Send-Discord "💥 CRASH FS25 [$InstanceName]"
    exit 1
}
