# setup_fs25.ps1
# Setup et lancement FS25 Server automatique
# Author: Patrick
# PS7 compatible, Windows Server 2022

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- ROOT = dossier racine du repo ---
$ScriptPath = $MyInvocation.MyCommand.Path
$ROOT = Split-Path -Parent (Split-Path -Parent $ScriptPath)
Write-Host "ROOT defini sur $ROOT"

# --- Chemins absolus ---
$Fs25Dir      = Join-Path $ROOT "fs25"
$ConfigPath   = Join-Path $ROOT "config.yaml"
$StartScript  = Join-Path $Fs25Dir "start_fs25.ps1"
$SteamCmdPath = "C:\steamcmd\steamcmd.exe"
$NssmPath     = "C:\nssm\nssm.exe"

# --- Verification config.yaml ---
if (-not (Test-Path $ConfigPath)) {
    Write-Host "Erreur: config.yaml introuvable a $ConfigPath" -ForegroundColor Red
    exit 1
}

# --- Charger YAML ---
Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

$InstallDir = $Config.gameservers.fs25.install_dir
$ServiceName = $Config.gameservers.fs25.service_name
$AppID      = $Config.gameservers.fs25.appid
$User       = $Config.gameservers.fs25.user
$BackupDir  = $Config.gameservers.fs25.backup.source

# --- Steam login depuis YAML ---
$SteamUser  = $Config.gameservers.fs25.steam.username
$SteamPass  = $Config.gameservers.fs25.steam.password
$SteamGuard = $Config.gameservers.fs25.steam.steam_guard_code

Write-Host "FS25 install dir: $InstallDir"
Write-Host "Service name: $ServiceName"

# --- Verification SteamCMD ---
if (-not (Test-Path $SteamCmdPath)) {
    Write-Host "SteamCMD non present, telechargement..."
    New-Item -ItemType Directory -Force -Path "C:\steamcmd" | Out-Null
    Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile "C:\steamcmd\steamcmd.zip"
    Expand-Archive -Path "C:\steamcmd\steamcmd.zip" -DestinationPath "C:\steamcmd" -Force
    Remove-Item "C:\steamcmd\steamcmd.zip"
    Write-Host "SteamCMD installe."
}

# --- Verification NSSM ---
if (-not (Test-Path $NssmPath)) {
    Write-Host "NSSM non present, telechargement..."
    New-Item -ItemType Directory -Force -Path "C:\nssm" | Out-Null
    $nssmZip = "C:\nssm\nssm.zip"
    Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile $nssmZip
    Expand-Archive -Path $nssmZip -DestinationPath "C:\nssm" -Force
    Remove-Item $nssmZip
    # On prend l'exe correct (win64)
    Copy-Item "C:\nssm\win64\nssm.exe" $NssmPath -Force
    Write-Host "NSSM installe."
}

# --- Creation des dossiers ---
Write-Host "Creation des dossiers..."
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
Write-Host "Dossiers crees."

# --- Installation FS25 si manquant ---
if (-not (Test-Path (Join-Path $InstallDir "ShooterGame"))) {
    Write-Host "FS25 non installe, lancement installation via SteamCMD..."

    # --- Construire commande SteamCMD ---
    $loginCmd = "$SteamUser $SteamPass"
    if ($SteamGuard -ne "") { $loginCmd += " $SteamGuard" }

    $steamScript = @"
login $loginCmd
force_install_dir $InstallDir
app_update $AppID validate
quit
"@

    $TempFile = "$env:TEMP\fs25_steamcmd.txt"
    $steamScript | Set-Content $TempFile -Force

    Start-Process -FilePath $SteamCmdPath -ArgumentList "+runscript `"$TempFile`"" -Wait
    Remove-Item $TempFile

    Write-Host "FS25 installe."
} else {
    Write-Host "FS25 deja installe, installation ignoree."
}

# --- Creation / recreation service FS25 ---
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Service $ServiceName existe deja, suppression..."
    Stop-Service $ServiceName -Force -ErrorAction SilentlyContinue
    & $NssmPath remove $ServiceName confirm
    Write-Host "Service supprime."
}

Write-Host "Creation service $ServiceName..."
& $NssmPath install $ServiceName $StartScript
Write-Host "Service cree."

# --- Demarrage service ---
try {
    Write-Host "Demarrage service $ServiceName..."
    Start-Service -Name $ServiceName
    Write-Host "Service demarre avec succes."
} catch {
    Write-Host "Erreur: impossible de demarrer le service $ServiceName." -ForegroundColor Red
    Write-Host $_
}

Write-Host "Setup FS25 termine."
