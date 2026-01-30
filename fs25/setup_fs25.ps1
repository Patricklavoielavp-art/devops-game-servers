# ================================
# setup_fs25.ps1
# Création des instances FS25 Vanilla/Modded
# Crée dossiers, services NSSM et firewall
# Author: Patrick
# ================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Chemins et outils ---
$ROOT = "C:\devops-game-servers"
$ConfigPath = Join-Path $ROOT "config.yaml"
$NssmPath = "C:\nssm\nssm.exe"  # <-- mettre le chemin correct vers NSSM


# --- Charger config YAML ---
Import-Module powershell-yaml -ErrorAction Stop
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Yaml
$FS25 = $Config.gameservers.fs25

$InstancesDir = $FS25.install_dir

# --- Créer services pour chaque instance ---
foreach ($instance in $FS25.instances) {

    $InstancePath = Join-Path $FS25.install_dir $instance.name
    Write-Host "Création de l'instance : $InstancePath"

    # --- Créer dossiers de l'instance ---
    foreach ($d in @("Saved","Mods","logs","Backups")) {
        $Path = Join-Path $InstancePath $d
        if (-not (Test-Path $Path)) {
            New-Item -ItemType Directory -Force -Path $Path | Out-Null
            Write-Host "Dossier créé : $Path"
        }
    }

    # --- Créer sous-dossiers pour chaque mod si existant ---
    if ($instance.mods -and $instance.mods.Count -gt 0) {
        foreach ($mod in $instance.mods) {
            if ($mod) { # Ignore les entrées vides
                $ModPath = Join-Path $InstancePath "Mods\$mod"
                if (-not (Test-Path $ModPath)) {
                    New-Item -ItemType Directory -Force -Path $ModPath | Out-Null
                    Write-Host "Sous-dossier mod créé : $ModPath"
                }
            }
        }
    }

    # --- Service NSSM ---
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
    & $NssmPath install $ServiceName "powershell.exe" "-ExecutionPolicy Bypass -File `"$StartScript`" -InstanceName `"$($instance.name)`""
    & $NssmPath set $ServiceName AppDirectory $FS25.install_dir
    & $NssmPath set $ServiceName Start SERVICE_AUTO_START
    #& $NssmPath set $ServiceName ObjectName $FS25.user  # optionnel

    # --- Firewall port ---
    Write-Host "Configuration Firewall port $($instance.port)..."
    New-NetFirewallRule -DisplayName "$ServiceName Game Port" `
        -Direction Inbound -Protocol UDP -LocalPort $instance.port `
        -Action Allow -Profile Any -ErrorAction SilentlyContinue

    # --- Démarrer le service ---
    Start-Service $ServiceName
    Write-Host "Service $ServiceName démarré avec succès"
}
