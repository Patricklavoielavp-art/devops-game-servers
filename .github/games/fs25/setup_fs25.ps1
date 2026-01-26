<#
    FS25- SETUP COMPLET
    Autheur : Patrick
    Installation complete de FS25
#>

Write-Host "===== FS25 - Setup complet ======"

$BaseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ServiceScript = "$BaseDir\Service\fs25-service-setup.ps1"
$InstallScript = "$BaseDir\install.ps1"
$UpdateScript = "$BaseDir\update.ps1"
$BackupScript = "$BaseDir\backup.ps1"
$StartScript = "$BaseDir\start_fs25.ps1"

Write-Host "[1/5] Exécution du script d'installation..."
powershell -ExecutionPolicy Bypass -File $InstallScript

Write-Host "[2/5] Installation du service Windows..."
powershell -ExecutionPolicy Bypass -File $ServiceScript

Write-Host "[3/5] Permissions..."
Get-ChildItem $BaseDir -Recurse -Filter *.ps1 | ForEach-Object {
    Unblock-File $_.FullName
}

Write-Host "[4/5] Démarrage du service FS25..."
Start-Service FS25

Write-Host "[5/5] Vérification du statut..."
Get-Service FS25

Write-Host "=== Installation FS25 terminée ==="
