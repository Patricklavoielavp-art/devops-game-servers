<#
    FS25 - MONITORING SCRIPT 
    Autheur : Patrick
    Vérifie si FS25 tourne , sinon redémarre
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Chargement du loader YAML
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ROOT\yaml.ps1"

Write-Host "=== Monitoring FS25 ===" -ForegroundColor Cyan

# Lecture du YAML
$ServiceName = Get-YamlValue ".gameservers.fs25.service_name"
$GamePort    = Get-YamlValue ".gameservers.fs25.ports.game"
$Enabled     = Get-YamlValue ".gameservers.fs25.monitoring.enabled"
$RestartOnFail = Get-YamlValue ".gameservers.fs25.monitoring.restart_on_fail"
$Webhook     = Get-YamlValue ".gameservers.fs25.monitoring.discord_webhook"

if ($Enabled -ne "true") {
    Write-Host "Monitoring FS25 désactivé dans config.yaml" -ForegroundColor Yellow
    exit 0
}

Write-Host "Vérification du serveur FS25..."

# 1. Vérification du service Windows
$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if (-not $Service) {
    Write-Host "Service introuvable : $ServiceName" -ForegroundColor Red
    exit 1
}

if ($Service.Status -ne "Running") {
    Write-Host "Le service FS25 ($ServiceName) est arrêté." -ForegroundColor Red

    if ($RestartOnFail -eq "true") {
        Write-Host "Redémarrage automatique du service..."
        Restart-Service -Name $ServiceName -Force
        Write-Host "Service redémarré." -ForegroundColor Green
    }

    if ($Webhook -and $Webhook -ne "") {
        try {
            Invoke-RestMethod -Uri $Webhook -Method Post -ContentType "application/json" `
                -Body (@{ content = "⚠️ FS25 est tombé. Redémarrage automatique effectué." } | ConvertTo-Json)
        }
        catch {
            Write-Host "Échec de l'envoi Discord." -ForegroundColor Yellow
        }
    }

    exit 1
}

# 2. Vérification du port du serveur
$Connection = Test-NetConnection -ComputerName "localhost" -Port $GamePort -WarningAction SilentlyContinue

if (-not $Connection.TcpTestSucceeded) {
    Write-Host "Le port FS25 ($GamePort) ne répond pas." -ForegroundColor Red

    if ($RestartOnFail -eq "true") {
        Write-Host "Redémarrage automatique du service..."
        Restart-Service -Name $ServiceName -Force
        Write-Host "Service redémarré." -ForegroundColor Green
    }

    if ($Webhook -and $Webhook -ne "") {
        try {
            Invoke-RestMethod -Uri $Webhook -Method Post -ContentType "application/json" `
                -Body (@{ content = "⚠️ FS25 ne répond plus sur le port $GamePort. Redémarrage automatique effectué." } | ConvertTo-Json)
        }
        catch {
            Write-Host "Échec de l'envoi Discord." -ForegroundColor Yellow
        }
    }

    exit 1
}

Write-Host "FS25 fonctionne normalement." -ForegroundColor Green