<#
    FS25 - BACKUP SCRIPT 
    Author : Patrick
    Description : Sauvegarde compressée des savegames FS25
#>
$config = .\yaml.ps1
$InstallDir = $config.gameservers.fs25.install_dir

$SaveDir = "$InstallDir\server\savegame"
$BackupDir = "$InstallDir\backups"
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$BackupFile = "$BackupDir\fs25_backup_$Date.zip"
$LogFile = "$InstallDir\backup.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timestamp] $Message"
    Write-Output $Message
}

# Create backup directory
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

Write-Log "Backup des sauvegardes FS25..."
Compress-Archive -Path $SaveDir -DestinationPath $BackupFile -Force
Write-Log "Backup terminé : $BackupFile"
