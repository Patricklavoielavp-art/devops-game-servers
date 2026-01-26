<#
    FS25 - START SCRIPT
    Autheur : Patrick
    Démarre le serveur FS25 en mode standalone ou via service 
#>

$ServiceName = "FS25-Server"
$ServerExe = "C:\FS25\server\FarmingSimulator2025Game.exe"

if(Get-Service -Name $ServiceName -ErrorAction SilentlyContinue){
    Start-Service $ServiceName
    Write-Output "Service FS25 démarré."
    exit
}

if(Test-Path $ServerExe) {
    Start-Process -FilePath $ServerExe -WorkingDirectory "C:\FS25\server"
    Write-Output "FS25 démarré en mode standalone"
} else {
    Write-Output "Erreur : Impossible de trouver l'exécutable FS25" 
}