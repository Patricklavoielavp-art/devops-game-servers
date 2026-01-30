param(
    [string]$InstanceName = "Vanilla"
)

# ================================
# FS25 Multi-instance Starter Script
# Vanilla ou Modded
# Backup, Logs, Monitoring CPU/RAM
# Compatible PS5.1 et PS7
# Author: Patrick
# ================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Configuration ---
$ROOT = "C:\devops-game-servers"
$ConfigPath = Join-Path $ROOT "config.yaml"

Import-Module powershell-yaml -ErrorAction Stop

$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

# --- Instance Paths ---
$InstancePath = Join-Path $FS25.install_dir $InstanceName
Write-Host "Instance path : $InstancePath"

$InstanceCfg = $FS25.instances | Where-Object { $_.name -eq $InstanceName }
if (-not $InstanceCfg) {
    Write-Host "Erreur : instance '$InstanceName' non trouvée" -ForegroundColor Red
    exit 1
}

$ExePath  = Join-Path $FS25.install_dir "DedicatedServer.exe"
$LogDir   = Join-Path $InstancePath "logs"
$LogFile  = Join-Path $LogDir "fs25.log"
$SavedDir = Join-Path $InstancePath "Saved"
$ModsDir  = Join-Path $InstancePath "Mods"
$BackupDst= Join-Path $InstancePath "Backups"
$RetentionDays = $FS25.backup.retention_days

$ServerLog = Join-Path $LogDir "fs25_server.log"
$WrapperLog = Join-Path $LogDir "fs25_wrapper.log"

# --- Préparer dossiers ---
foreach ($d in @($LogDir, $SavedDir, $ModsDir, $BackupDst)) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

# --- Copier mods si existants ---
if ($InstanceCfg.mods -and $InstanceCfg.mods.Count -gt 0) {
    foreach ($mod in $InstanceCfg.mods) {
        $SrcMod = Join-Path $FS25.install_dir "Mods\$mod"
        $DstMod = Join-Path $ModsDir $mod
        if (-not (Test-Path $DstMod) -and (Test-Path $SrcMod)) {
            Write-Host "Copie du mod $mod..."
            Copy-Item $SrcMod -Recurse -Force -Destination $DstMod
        }
    }
}

# --- Construire arguments ---
$Args = "$($InstanceCfg.map)?listen?SessionName=$($InstanceCfg.session_name)?MaxPlayers=$($InstanceCfg.max_players)"

# Ajouter mods seulement s'ils existent
if ($InstanceCfg.mods -and $InstanceCfg.mods.Count -gt 0) {
    $ModsParam = $InstanceCfg.mods -join ","
    $Args += "?Mods=$ModsParam"
}

$Args += " -log"

# --- Fonction log ---
function Log {
    param([string]$M)
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Time - $M" | Out-File -FilePath $WrapperLog -Append -Encoding utf8
}


# --- Backup ---
function Run-Backup {
    try {
        $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $ZipPath = Join-Path $BackupDst "FS25_$Stamp.zip"
        Compress-Archive -Path "$SavedDir\*" -DestinationPath $ZipPath -CompressionLevel Optimal
        Get-ChildItem $BackupDst -Filter "FS25_*.zip" |
            Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } |
            Remove-Item -Force
        Log "Backup OK : FS25_$Stamp.zip"
    } catch { Log "Erreur backup : $_" }
}

# --- Monitor CPU/RAM ---
function Monitor-Ressources {
    try {
        $CPU = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
        $RAM = (Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples[0].CookedValue
        if ($CPU -gt $FS25.monitoring.cpu_alert) { Log "⚠️ CPU élevé : $([int]$CPU)%" }
        if ($RAM -gt $FS25.monitoring.ram_alert) { Log "⚠️ RAM élevé : $([int]$RAM)%" }
    } catch {}
}

# --- Job backup périodique ---
Start-Job -ScriptBlock { param($F) while ($true){ & $F; Start-Sleep -Seconds 3600 } } -ArgumentList ${function:Run-Backup} | Out-Null

# --- Lancer FS25 ---
try {
    if (-not (Test-Path $ExePath)) { Log "Erreur : DedicatedServer.exe introuvable"; exit 1 }

    # Rediriger stderr vers stdout pour éviter l'erreur précédente
    $ArgsWithRedir = "$Args 2>&1"
    $Process = Start-Process -FilePath $ExePath -ArgumentList $ArgsWithRedir -WorkingDirectory $FS25.install_dir -NoNewWindow -PassThru -RedirectStandardOutput $ServerLog -RedirectStandardOError $ServerLog
    Log "FS25 lancé (PID=$($Process.Id))"

    while ($true) {
        Monitor-Ressources
        Start-Sleep -Seconds 60
        if (-not (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) {
            Log "FS25 arrêté"
            exit 1
        }
    }
} catch {
    Log "CRASH FS25 : $_"
    exit 1
}
