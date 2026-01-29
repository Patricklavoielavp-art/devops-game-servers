<#
    FS25 - SETUP IDEMPOTENT
    Auteur : Patrick
    Description : Installation complète et sûre du serveur FS25
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# =======================
# Sécurité TLS (Windows Server fresh)
# =======================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# =======================
# Paths
# =======================
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT = Resolve-Path "$ROOT\.."
$CONFIG_PATH = Join-Path $REPO_ROOT "config.yaml"
$CACHE = "C:\_cache"
New-Item -ItemType Directory -Force -Path $CACHE | Out-Null

Write-Host "=== Initialisation FS25 ===" -ForegroundColor Cyan
Write-Host "Repo root : $REPO_ROOT"
Write-Host "Config     : $CONFIG_PATH"

if (-not (Test-Path $CONFIG_PATH)) {
    throw "config.yaml introuvable : $CONFIG_PATH"
}

# =======================
# Téléchargement robuste
# =======================
function Get-FileRobust {
    param(
        [string[]]$Urls,
        [string]$OutFile
    )

    if (Test-Path $OutFile) {
        Write-Host "Déjà présent : $OutFile"
        return
    }

    foreach ($url in $Urls) {
        try {
            Write-Host "Téléchargement : $url"
            Invoke-WebRequest -Uri $url -OutFile $OutFile -UseBasicParsing -TimeoutSec 30
            return
        } catch {
            Write-Warning "Échec : $url"
        }
    }

    throw "Impossible de télécharger $OutFile"
}

# =======================
# Module YAML
# =======================
if (-not (Get-Module -ListAvailable powershell-yaml)) {
    Write-Host "Installation powershell-yaml..."
    Install-Module powershell-yaml -Force -Scope AllUsers
}

Import-Module powershell-yaml

$Config = Get-Content $CONFIG_PATH -Raw | ConvertFrom-Yaml

$FS25 = $Config.gameservers.fs25
$InstallDir  = $FS25.install_dir
$ServiceName = $FS25.service_name
$AppID       = $FS25.appid
$User        = $FS25.user

# =======================
# SteamCMD
# =======================
$SteamDir = "C:\steamcmd"
$SteamExe = "$SteamDir\steamcmd.exe"

if (-not (Test-Path $SteamExe)) {
    Write-Host "Installation SteamCMD..."
    New-Item -ItemType Directory -Force -Path $SteamDir | Out-Null

    $zip = "$CACHE\steamcmd.zip"
    Get-FileRobust -OutFile $zip -Urls @(
        "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
    )

    Expand-Archive $zip $SteamDir -Force
}

# =======================
# NSSM
# =======================
$NssmExe = "C:\nssm\nssm.exe"

if (-not (Test-Path $NssmExe)) {
    Write-Host "Installation NSSM..."
    New-Item -ItemType Directory -Force -Path "C:\nssm" | Out-Null

    $zip = "$CACHE\nssm.zip"
    Get-FileRobust -OutFile $zip -Urls @(
        "https://github.com/kirillkovalenko/nssm/releases/download/v2.24/nssm-2.24.zip",
        "https://nssm.cc/release/nssm-2.24.zip"
    )

    Expand-Archive $zip "C:\nssm" -Force
    Copy-Item "C:\nssm\nssm-2.24\win64\nssm.exe" $NssmExe -Force
}

# =======================
# Installation FS25 (si absent)
# =======================
if (-not (Test-Path $InstallDir)) {
    Write-Host "Installation FS25 via SteamCMD..."
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

    & $SteamExe `
        +force_install_dir "$InstallDir" `
        +login anonymous `
        +app_update $AppID validate `
        +quit
}
else {
    Write-Host "FS25 déjà installé → skip"
}

# =======================
# Service Windows (idempotent)
# =======================
$StartScript = Join-Path $ROOT "start_fs25.ps1"

if (-not (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue)) {
    Write-Host "Création du service Windows : $ServiceName"

    & $NssmExe install $ServiceName "pwsh.exe" `
        "-ExecutionPolicy Bypass -File `"$StartScript`""

    & $NssmExe set $ServiceName AppDirectory $InstallDir
    & $NssmExe set $ServiceName Start SERVICE_AUTO_START
}
else {
    Write-Host "Service déjà existant → skip"
}

# =======================
# Démarrage / Restart propre
# =======================
$svc = Get-Service $ServiceName

if ($svc.Status -eq "Running") {
    Write-Host "Redémarrage du service..."
    Restart-Service $ServiceName -Force
}
else {
    Write-Host "Démarrage du service..."
    Start-Service $ServiceName
}

Write-Host "=== FS25 prêt ===" -ForegroundColor Green