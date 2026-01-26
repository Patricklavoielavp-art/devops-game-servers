<#
    FS25 - UPDATE SCRIPT
    Author : Patrick
    Description : Met à jour le serveur FS25 via SteamCMD
#>
$config = .\yaml.ps1
$InstallDir = $config.gameservers.fs25.install_dir
$SteamCmdExe = "$InstallDir\steamcmd\steamcmd.exe"
$ServerDir = "$InstallDir\server"
$AppID = 2345690
$LogFile = "$InstallDir\update.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timestamp] $Message"
    Write-Output $Message
}

Write-Log "Mise à jour du serveur FS25 ..."
& $SteamCmdExe +login anonymous +force_install_dir "$ServerDir" +app_update $AppID +quit
Write-Log "Mise à jour terminée."