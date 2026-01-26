<#
    FS25 - RESTART SCRIPT 
    Autheur : Patrick
    Redémarre le serveur FS25
#>

Write-Output "Redémarrage du serveur FS25 ..."
& ".\stop_fs25.ps1"
Start-Sleep -Second 3
& ".\start_fs25.ps1"
Write-Output "Redémarrage terminé."