<#
    FS25 - SETUP IDEMPOTENT
    Auteur : Patrick
    Description : Installation complète et sûre du serveur FS25
#>

# FS25/setup_fs25.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ===============================
# TLS safety
# ===============================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ===============================
# Generic downloader
# ===============================
function Download-Tool {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Destination
    )

    if (Test-Path $Destination) {
        Write-Host "$Name already present"
        return
    }

    Write-Host "Downloading $Name..."

    try {
        Start-BitsTransfer -Source $Url -Destination $Destination -ErrorAction Stop
        return
    }
    catch {
        Write-Warning "BITS failed, fallback to Invoke-WebRequest"
    }

    Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing -TimeoutSec 60
}

# ===============================
# Paths
# ===============================
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT = Resolve-Path "$ROOT\.."
$CONFIG_PATH = Join-Path $REPO_ROOT "config.yaml"

Write-Host "=== FS25 SETUP ===" -ForegroundColor Cyan
Write-Host "Repo root : $REPO_ROOT"
Write-Host "Config    : $CONFIG_PATH"

if (-not (Test-Path $CONFIG_PATH)) {
    throw "config.yaml not found"
}

# ===============================
# YAML module
# ===============================
if (-not (Get-Module -ListAvailable powershell-yaml)) {
    Write-Host "Installing powershell-yaml module..."
    Install-Module powershell-yaml -Force -Scope AllUsers
}
Import-Module powershell-yaml

$Config = Get-Content $CONFIG_PATH -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

$InstallDir  = $FS25.install_dir
$ServiceName = $FS25.service_name
$AppID       = $FS25.appid

# ===============================
# SteamCMD
# ===============================
$SteamDir = "C:\steamcmd"
$SteamExe = "$SteamDir\steamcmd.exe"
$Cache    = "C:\_cache"

New-Item -ItemType Directory -Force -Path $SteamDir, $Cache | Out-Null

if (-not (Test-Path $SteamExe)) {
    Write-Host "Installing SteamCMD..."

    $SteamZip = "$Cache\steamcmd.zip"
    Download-Tool `
        -Name "SteamCMD" `
        -Url "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" `
        -Destination $SteamZip

    Expand-Archive $SteamZip $SteamDir -Force
}

# ===============================
# NSSM
# ===============================
$NssmDir = "C:\nssm"
$NssmExe = "$NssmDir\nssm.exe"
New-Item -ItemType Directory -Force -Path $NssmDir | Out-Null

if (-not (Test-Path $NssmExe)) {

    Write-Host "Installing NSSM..."

    $NssmZip = "$Cache\nssm.zip"

    Download-Tool `
        -Name "NSSM" `
        -Url "https://github.com/kirillkovalenko/nssm/releases/download/2.24/nssm-2.24.zip" `
        -Destination $NssmZip

    Expand-Archive $NssmZip $Cache -Force
    Copy-Item "$Cache\nssm-2.24\win64\nssm.exe" $NssmExe -Force
}

if (-not (Test-Path $NssmExe)) {
    throw "NSSM install failed"
}

# ===============================
# FS25 install (idempotent)
# ===============================
if (-not (Test-Path $InstallDir)) {

    Write-Host "Installing FS25..."

    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

    & $SteamExe `
        +force_install_dir "$InstallDir" `
        +login anonymous `
        +app_update $AppID validate `
        +quit
}
else {
    Write-Host "FS25 already installed"
}

# ===============================
# Windows service
# ===============================
$StartScript = Join-Path $ROOT "start_fs25.ps1"

if (-not (Get-Service $ServiceName -ErrorAction SilentlyContinue)) {

    Write-Host "Creating Windows service : $ServiceName"

    & $NssmExe install $ServiceName "pwsh.exe" `
        "-ExecutionPolicy Bypass -File `"$StartScript`""

    & $NssmExe set $ServiceName AppDirectory $InstallDir
    & $NssmExe set $ServiceName Start SERVICE_AUTO_START
}
else {
    Write-Host "Service already exists"
}

# ===============================
# Start / Restart service
# ===============================
$svc = Get-Service $ServiceName

if ($svc.Status -eq "Running") {
    Write-Host "Restarting service..."
    Restart-Service $ServiceName -Force
}
else {
    Write-Host "Starting service..."
    Start-Service $ServiceName
}

Write-Host "=== FS25 READY ===" -ForegroundColor Green
