<#
    FS25 - STOP SCRIPT 
    Autheur : Patrick 
    Arrête le serveur FS25 proprement 
#>

$ServiceName = "FS25-Server"

if(Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Stop-Service $ServiceName -Force
    Write-Output "Service FS25 arrêté."
    exit
}

Get-Process "FarmingSimulator2025Game" -ErrorAction -SilentlyContinue | Stop-Process -Force
Write-Output "Processus FS25 Arrêté."