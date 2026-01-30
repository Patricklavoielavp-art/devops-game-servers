# setup_fs25.ps1
# Setup FS25 Dedicated Server multi-instance (NSSM + Firewall)
# Author: Patrick
# PS7 compatible, Windows Server 2022

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Charger config
$ROOT = "C:\devops-game-servers"
$ConfigPath = Join-Path $ROOT "config.yaml"

Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

$InstancesDir = Join-Path $ROOT "fs25\instances"

# Vérifier NSSM
$NssmPath = "C:\nssm\nssm.exe"
if (-not (Test-Path $NssmPath)) {
    Write-Host "Installation NSSM..."
    New-Item -ItemType Directory -Force -Path "C:\nssm" | Out-Null
    $zip = "C:\nssm\nssm.zip"
    Invoke-WebRequest "https://nssm.cc/release/nssm-2.24.zip" -OutFile $zip
    Expand-Archive $zip "C:\nssm" -Force
    Copy-Item "C:\nssm\win64\nssm.exe" $NssmPath -Force
    Remove-Item $zip
}

# Créer dossier Instances
if (-not (Test-Path $InstancesDir)) { New-Item -ItemType Directory -Force -Path $InstancesDir | Out-Null }

# Créer services pour chaque instance
foreach ($instance in $FS25.instances) {

    $InstancePath = Join-Path $InstancesDir $instance.name

    # Créer dossiers instance
    foreach ($d in @("Saved","Mods","logs","Backups")) {
        $Path = Join-Path $InstancePath $d
        if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
    }

    $ServiceName = $instance.service_name
    $StartScript = Join-Path $ROOT "fs25\start_fs25.ps1"

    # Supprimer service existant
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Write-Host "Suppression service existant $ServiceName..."
        Stop-Service $ServiceName -Force -ErrorAction SilentlyContinue
        & $NssmPath remove $ServiceName confirm
    }

    # Créer service NSSM
    Write-Host "Création service NSSM $ServiceName..."
    & $NssmPath install $ServiceName "powershell.exe" "-ExecutionPolicy Bypass -File `"$StartScript`" -InstancePath `"$InstancePath`""
    & $NssmPath set $ServiceName AppDirectory $FS25.install_dir
    & $NssmPath set $ServiceName Start SERVICE_AUTO_START
    #& $NssmPath set $ServiceName ObjectName $FS25.user

    Write-Host "Tests de push"

    # Firewall pour le port de l’instance
    Write-Host "Configuration Firewall port $($instance.port)..."
    New-NetFirewallRule -DisplayName "$ServiceName Game Port" `
        -Direction Inbound -Protocol UDP -LocalPort $instance.port `
        -Action Allow -Profile Any -ErrorAction SilentlyContinue

    # Démarrer le service
    Start-Service $ServiceName
    Write-Host "Service $ServiceName démarré avec succès"
}

Write-Host "Setup FS25 multi-instance terminé ✅"
