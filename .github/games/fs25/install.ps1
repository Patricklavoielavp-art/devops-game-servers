<#
    FS25 - INSTALL SCRIPT 
    Author : Patrick
    Description : Installe SteamCMD + FS25 Dedicated Server
#>

# ===========================================================
# CONFIGURATION
# ===========================================================
$config = .\yaml.ps1
$InstallDir = $config.gameservers.fs25.install_dir

$SteamCmdDir = "$InstallDir/steamcmd"
$ServerDir = "$InstallDir/server"
$SteamCMDExe = "$SteamCmdDir/steamcmd.exe"
$AppID = 2345690  # FS25 Dedicated Server ID
$LogFile = "$InstallDir/install.log"

#============================================================
# LOG FUNCTION 
#============================================================
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timestamp] $Message"
    Write-Output $Message
}

#============================================================
# CREATE DIRECTORIES
#============================================================
Write-Log "Création des dossiers ..."
New-Item -ItemType Diectory -Force -Path $InstallDir, $SteamCmdDir , $ServerDir | Out-Null

#============================================================
# DOWNLOAD STEAMCMD
#============================================================
if (!(Test-Path $SteamCMDExe)){
    Write-Log "Téléchargement de SteamCMD ..."
    Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile "$SteamCmdDir\steamcmd.zip"
    Expand-Archive "$SteamCmdDir/steamcmd.zip" -DestinationPath $SteamCmdDir -Force
    Remove-Item "$SteamCmdDir/steamcmd.zip"
} else {
    Write-Log "SteamCMD déjà installé."
}

#============================================================
# INSTALL FS25 SERVER
#============================================================
Write-Log "Installation du serveur FS25 ..."
& $SteamCmdExe +login anonymous +force_install_dir "$ServerDir" +app_update $AppID validate +quit

Write-Log "Installation terminée."