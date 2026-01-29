<#
    FS25 - SETUP IDEMPOTENT
    Auteur : Patrick
    Description : Installation complète et sûre du serveur FS25
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "VERSION SETUP_FS25 2026-01-XX"

# ---------- LOGGING (OBLIGATOIRE EN SYSTEM) ----------
$LogDir = "C:\fs25\logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$LogFile = Join-Path $LogDir "setup_fs25.log"

Start-Transcript -Path $LogFile -Append
whoami

Write-Host "=== FS25 SETUP START ===" -ForegroundColor Cyan

# ---------- ROOT / CONFIG ----------
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigPath = Join-Path $ROOT "..\config.yaml"

if (-not (Test-Path $ConfigPath)) {
    throw "config.yaml introuvable : $ConfigPath"
}

Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml

$InstallDir  = $Config.gameservers.fs25.install_dir
$ServiceName = $Config.gameservers.fs25.service_name
$AppID       = $Config.gameservers.fs25.appid

# ---------- OUTILS ----------
$SteamCmdDir = "C:\steamcmd"
$SteamCmdExe = "$SteamCmdDir\steamcmd.exe"

$NssmDir = "C:\nssm"
$NssmExe = "$NssmDir\nssm.exe"

# ---------- FONCTIONS ----------
function Download-File {
    param ($Url, $Dest)

    try {
        Start-BitsTransfer -Source $Url -Destination $Dest -ErrorAction Stop
    } catch {
        Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
    }
}

# ---------- STEAMCMD ----------
if (-not (Test-Path $SteamCmdExe)) {
    Write-Host "Installation SteamCMD..."
    New-Item -ItemType Directory -Force -Path $SteamCmdDir | Out-Null

    $zip = "$SteamCmdDir\steamcmd.zip"
    Download-File "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" $zip

    Expand-Archive $zip $SteamCmdDir -Force
    Remove-Item $zip
} else {
    Write-Host "SteamCMD deja installe"
}

# ---------- NSSM ----------
if (-not (Test-Path $NssmExe)) {
    Write-Host "Installation NSSM..."

    New-Item -ItemType Directory -Force -Path $NssmDir | Out-Null
    $zip = "$NssmDir\nssm.zip"

    Download-File "https://nssm.cc/release/nssm-2.24.zip" $zip
    Expand-Archive $zip $NssmDir -Force

    Copy-Item "$NssmDir\nssm-2.24\win64\nssm.exe" $NssmExe -Force
    Remove-Item $zip
} else {
    Write-Host "NSSM deja installe"
}

# ---------- INSTALL FS25 ----------
if (-not (Test-Path $InstallDir)) {
    Write-Host "FS25 absent -> installation"
    pwsh.exe -ExecutionPolicy Bypass -File "$ROOT\install.ps1"
} else {
    Write-Host "FS25 deja installe"
}

# ---------- UPDATE FS25 ----------
Write-Host "Mise a jour FS25"
pwsh.exe -ExecutionPolicy Bypass -File "$ROOT\update.ps1"

# ---------- SERVICE WINDOWS ----------
$ExistingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($ExistingService) {
    Write-Host "Service existant -> suppression"
    Stop-Service $ServiceName -Force -ErrorAction SilentlyContinue
    & $NssmExe remove $ServiceName confirm
}

Write-Host "Creation du service Windows"
$StartScript = Join-Path $ROOT "start_fs25.ps1"

& $NssmExe install $ServiceName "pwsh.exe" "-ExecutionPolicy Bypass -File `"$StartScript`""
& $NssmExe set $ServiceName AppDirectory $InstallDir
& $NssmExe set $ServiceName Start SERVICE_AUTO_START

# logs service
& $NssmExe set $ServiceName AppStdout "C:\fs25\logs\fs25_stdout.log"
& $NssmExe set $ServiceName AppStderr "C:\fs25\logs\fs25_stderr.log"
& $NssmExe set $ServiceName AppRotateFiles 1

# ---------- START SERVICE ----------
Write-Host "Demarrage du service FS25"
Start-Service $ServiceName

Start-Sleep 5
Get-Service $ServiceName

Write-Host "=== FS25 SETUP TERMINE ===" -ForegroundColor Green
Stop-Transcript
