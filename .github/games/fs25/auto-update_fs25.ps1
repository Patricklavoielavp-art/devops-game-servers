<#
    FS25 - AUTO UPDATE SCRIPT
    Autheur : Patrick
    Mise à jour automatique du serveur FS25
#>

$InstallDir = "C:\FS25"
$LogFile = "$InstallDir\auto-update.log"

fonction Log {
    param([string] $Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timestamp] $Message"
}

Log "Début de la mise à jour FS25..."

& "$InstallDir\stop_fs25.ps1"
& "$InstallDir\update.ps1"
& "$InstallDir\start_fs25.ps1"

Log "Mise à jour FS25 terminée."