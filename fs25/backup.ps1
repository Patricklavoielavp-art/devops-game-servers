<#
    FS25 - BACKUP SCRIPT 
    Author : Patrick
    Description : Sauvegarde compressée des savegames FS25
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Chargement du loader YAML
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ROOT\yaml.ps1"

Write-Host "=== Backup FS25 ===" -ForegroundColor Cyan

Import-Module powershell-yaml

$ConfigPath = Join-Path $ROOT "..\..\config.yaml"
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

# Lecture du YAML
$InstallDir   = $Config.gameservers.fs25.install_dir
$BackupSource = $Config.gameservers.fs25.backup.source
$Retention    = $Config.gameservers.fs25.backup.retention_days
$Webhook      = $Config.gameservers.fs25.monitoring.discord_webhook

# Vérification du dossier source
if (-not (Test-Path $BackupSource)) {
    Write-Host "Le dossier de sauvegarde n'existe pas : $BackupSource" -ForegroundColor Red
    exit 1
}

# Préparation des dossiers
$BackupDir = Join-Path $InstallDir "backups"
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$BackupFile = Join-Path $BackupDir "fs25_backup_$Timestamp.zip"

Write-Host "Compression du dossier savegame..."
Compress-Archive -Path "$BackupSource\*" -DestinationPath $BackupFile -Force

Write-Host "Backup créé : $BackupFile" -ForegroundColor Green

# Rotation automatique
Write-Host "Nettoyage des anciens backups (rétention : $Retention jours)..."
Get-ChildItem -Path $BackupDir -Filter "*.zip" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$Retention) } |
    Remove-Item -Force

Write-Host "Rotation terminée." -ForegroundColor Green

# Notification Discord (optionnelle)
if ($Webhook -and $Webhook -ne "") {
    Write-Host "Envoi de la notification Discord..."
    try {
        Invoke-RestMethod -Uri $Webhook -Method Post -ContentType "application/json" `
            -Body (@{ content = "📦 Backup FS25 complété : `$BackupFile`" } | ConvertTo-Json)
    }
    catch {
        Write-Host "Échec de l'envoi Discord." -ForegroundColor Yellow
    }
}

Write-Host "Backup FS25 terminé avec succès." -ForegroundColor Green