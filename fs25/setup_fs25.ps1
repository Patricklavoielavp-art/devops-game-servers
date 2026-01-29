<#
    FS25 - SETUP IDEMPOTENT
    Auteur : Patrick
    Description : Installation complète et sûre du serveur FS25
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=== FS25 Setup starting ==="

# -------------------------------
# Resolve ROOT
# -------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir   = Resolve-Path "$ScriptDir\.."
$ConfigFile = "$RootDir\config.yaml"

if (-not (Test-Path $ConfigFile)) {
    throw "config.yaml not found at $ConfigFile"
}

# -------------------------------
# Load YAML
# -------------------------------
if (-not (Get-Module -ListAvailable powershell-yaml)) {
    Install-Module powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

$Config = ConvertFrom-Yaml (Get-Content $ConfigFile -Raw)

# -------------------------------
# Variables
# -------------------------------
$GameName   = "FS25"
$Service    = "FS25"
$AppID      = $Config.fs25.app_id
$InstallDir = $Config.fs25.install_dir
$SteamDir   = "C:\steamcmd"
$SteamExe   = "$SteamDir\steamcmd.exe"
$NssmDir    = "C:\nssm"
$NssmExe    = "$NssmDir\nssm.exe"
$Cache      = "C:\_cache"
$LogDir     = "$InstallDir\logs"

New-Item -ItemType Directory -Force -Path $SteamDir, $NssmDir, $Cache, $InstallDir, $LogDir | Out-Null

# ===============================
# Ensure NSSM
# ===============================
function Ensure-NSSM {

    if (-not (Test-Path $NssmExe)) {
        Write-Host "Installing NSSM..."
        $Zip = "$Cache\nssm.zip"
        $Url = "http://nssm.cc/release/nssm-2.24.zip"

        try { Start-BitsTransfer $Url $Zip }
        catch { Invoke-WebRequest $Url -OutFile $Zip -UseBasicParsing }

        Expand-Archive $Zip $Cache -Force
        Copy-Item "$Cache\nssm-2.24\win64\nssm.exe" $NssmExe -Force
    }

    Set-Alias nssm $NssmExe -Scope Global
    & $NssmExe version | Out-Null
}

Ensure-NSSM

# ===============================
# Ensure SteamCMD
# ===============================
function Ensure-SteamCMD {

    if (-not (Test-Path $SteamExe)) {
        Write-Host "Installing SteamCMD..."
        $Zip = "$Cache\steamcmd.zip"
        $Url = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"

        try { Start-BitsTransfer $Url $Zip }
        catch { Invoke-WebRequest $Url -OutFile $Zip -UseBasicParsing }

        Expand-Archive $Zip $SteamDir -Force
    }
}

Ensure-SteamCMD

# ===============================
# Install or Update FS25
# ===============================
$SteamArgs = @(
    "+force_install_dir", "$InstallDir"
    "+login", "anonymous"
    "+app_update", "$AppID", "validate"
    "+quit"
)

Write-Host "Installing / Updating FS25..."
& $SteamExe $SteamArgs

# ===============================
# Service management
# ===============================
function Service-Exists {
    Get-Service -Name $Service -ErrorAction SilentlyContinue
}

function Remove-ServiceSafe {
    if (Service-Exists) {
        Write-Host "Removing existing service..."
        nssm stop $Service | Out-Null
        nssm remove $Service confirm | Out-Null
    }
}

function Create-Service {
    Write-Host "Creating service..."
    nssm install $Service "$InstallDir\FarmingSimulator2025DedicatedServer.exe"
    nssm set $Service AppDirectory $InstallDir
    nssm set $Service AppStdout "$LogDir\stdout.log"
    nssm set $Service AppStderr "$LogDir\stderr.log"
    nssm set $Service Start SERVICE_AUTO_START
}

Remove-ServiceSafe
Create-Service

# ===============================
# Start service
# ===============================
Write-Host "Starting service..."
Start-Service $Service

Write-Host "=== FS25 Setup complete ==="
