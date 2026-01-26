<#
    FS25 - START SCRIPT
    Autheur : Patrick
    Démarre le serveur FS25 en mode standalone ou via service 
#>
$config = .\yaml.ps1
$InstallDir = $config.gameservers.fs25.install_dir

$ServiceName = "FS25-Server"
$ServerExe = "$installDir\server\FarmingSimulator2025Game.exe"

if(Get-Service -Name $ServiceName -ErrorAction SilentlyContinue){
    Start-Service $ServiceName
    Write-Output "Service FS25 démarré."
    exit
}

if(Test-Path $ServerExe) {
    Start-Process -FilePath $ServerExe -WorkingDirectory "$InstallDir\server"
    Write-Output "FS25 démarré en mode standalone"
} else {
    Write-Output "Erreur : Impossible de trouver l'exécutable FS25" 
}