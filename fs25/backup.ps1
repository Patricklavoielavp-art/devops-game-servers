# backup.ps1
# Backup automatique FS25
# Autheur : Patrick

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --------------------------------------------------------
# Charger Config
# --------------------------------------------------------
$ROOT = "C:\devops-game-servers"
$ConfigPath = Join-Path $ROOT "config.yaml"
Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25 

$BackupSource = $FS25.backup.source 
$RetentionDays = $FS25.backup.retention_days 
$BackupRoot = Join-Path $BackupSource "Backups"

# --------------------------------------------------------
# Créer dossier backup si inexistant
# --------------------------------------------------------
New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null

# --------------------------------------------------------
# Créer backup horodaté
# --------------------------------------------------------
$Date = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupDest = Join-Path $BackupRoot "FS25_$Date"
Write-Host "Création du backup : $BackupDest"
Copy-Item -Path $BackupSource\* -Destination  $BackupDest -Recurse -Force

# --------------------------------------------------------
# Supprimer les backups trop vieux
# --------------------------------------------------------
$OldBackups = Get-ChildItem $BackupRoot - Directory | 
    Where-Object { $_.LastWriteItem -lt (Get-Date),AddDays(-$RetentionDays) }

foreach ($b in  $OldBackups) {
    Write-Host "Suppression ancien backup : $($b.FullName)"
    Remove-Item -Recurse -Force $b.FullName  
}


Write-Host "Backup FS25 terminé ✅"
