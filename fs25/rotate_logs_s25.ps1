# rotate_logs_fs25.ps1
# Rotation automatique des logs FS25
# Autheur : Patrick 

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# -----------------------------------------------
# Charger Config
# -----------------------------------------------
$ROOT = "C:\devops-game-servers"
$ConfigPath = Join-Path $ROOT "config.yaml"
Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

$LogFile = Join-Path $FS25.logs.dir $FS25.logs.file 
$LogDir = $FS25.logs.dir 
$RetentionDays = $FS25.backup.retention_days

# -----------------------------------------------
# Vérifier si Log existe 
# -----------------------------------------------
if (-not (Test-Path $LogFile)) { return }

# -----------------------------------------------
# Archiver Log actuel
# -----------------------------------------------
$Date = Get-Date -Format "yyyyMMdd_HHmmss"
$Archive = Join-Path $LogDir "fs25_$Date.log"
Move-Item -Path $LogDir -Destination $Archive -Force

# -----------------------------------------------
# Créer nouveaux Log Vide
# -----------------------------------------------
New-Item -ItemType File -Force -Path $LogFile | Out-Null

# -----------------------------------------------
# Supprimer anciens Logs 
# -----------------------------------------------
$OldLogs = Get-ChildItem $LogDir -Filter "fs25_*.log" |
    Where-Object { $_.LastWriteItem -lt (Get-Date).AddDays(-$RetentionDays) }

foreach ($l in $OldLogs) {
    Write-Host "Suppression des anciens log : $($l.FullName)"
    Remove-Item -Force $l.FullName
}

Write-Host "Rotation des logs FS25 terminée ✅"
