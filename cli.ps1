<#
    FS25 - CLI FILE 
    Autheur : Patrick
    Script de gestion des ps1 globale pour le serveur FS25
#>
Set-StrictMode -Version Latest
Import-Module powershell-yaml

$ErrorActionPreference = "Stop"

if($args.Count -ne 2) {
    Write-Host "Usage : cli.ps1 {install|update|backup|monitor|start|setup} FS25"
    exit 1
}

$Action = $args[0]
$Game   = $args[1]

$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path

echo "$ROOT"

switch($Game) {
    "fs25" { $Dir = "$ROOT/fs25"}
    default {
        Write-Host "Jeu inconnu : $Game " -ForegroundColor Red
        exit 1
    }
}

switch ($Action) {
    "install" {pwsh.exe -ExecutionPolicy Bypass -File "$Dir\install.ps1"}
    "update" {pwsh.exe -ExecutionPolicy Bypass -File "$Dir\update.ps1"}
    "backup" {pwsh.exe -ExecutionPolicy Bypass -File "$Dir\backup.ps1"}
    "monitor" {pwsh.exe -ExecutionPolicy Bypass -File "$Dir\monitor.ps1"}
    "start" {pwsh.exe -ExecutionPolicy Bypass -File "$Dir\start_fs25.ps1"}
    "setup" {pwsh.exe -ExecutionPolicy Bypass -File "$Dir\setup_fs25.ps1"}
    default {
        Write-Host "Action inconue : $Action" -ForegroundColor Red
        exit 1 
    }
}