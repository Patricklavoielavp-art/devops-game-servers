<#
.SYNOPSIS
    Crée les dossiers FS25, services NSSM et firewall pour chaque instance
#>

$ErrorActionPreference = "Stop"

$ROOT = "C:\devops-game-servers"
$Fs25Root = Join-Path $ROOT "fs25"
$NssmPath = "C:\nssm\nssm.exe"

# YAML / config
Import-Module powershell-yaml
$Config = Get-Content "$ROOT\config.yaml" -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

# Créer dossier fs25 si absent
if (-not (Test-Path $Fs25Root)) { New-Item -ItemType Directory -Force -Path $Fs25Root | Out-Null }

foreach ($instance in $FS25.instances) {
    $InstanceName = $instance.name.ToLower()
    $InstancePath = Join-Path $Fs25Root $InstanceName

    # Créer dossiers instance
    foreach ($d in @("Saved","Mods","logs","Backups")) {
        $Path = Join-Path $InstancePath $d
        if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
    }

    # NSSM service
    $ServiceName = $instance.service_name
    $StartScript = Join-Path $ROOT "fs25\start_fs25.ps1"

    # Supprimer ancien service si existant
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Write-Host "Suppression service existant $ServiceName..."
        Stop-Service $ServiceName -Force -ErrorAction SilentlyContinue
        & $NssmPath remove $ServiceName confirm
    }

    # Installer le service
    Write-Host "Création service NSSM $ServiceName..."
    & $NssmPath install $ServiceName `
        "C:\Program Files\PowerShell\7\pwsh.exe" `
        "-ExecutionPolicy Bypass -File `"$StartScript`" -InstanceName `"$InstanceName`""

    & $NssmPath set $ServiceName AppDirectory $Fs25Root
    & $NssmPath set $ServiceName Start SERVICE_AUTO_START

    # Firewall
    New-NetFirewallRule -DisplayName "$ServiceName Game Port" `
        -Direction Inbound -Protocol UDP -LocalPort $instance.port `
        -Action Allow -Profile Any -ErrorAction SilentlyContinue

    # Démarrer service
    Start-Service $ServiceName
    Write-Host "Service $ServiceName démarré"
}
