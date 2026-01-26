<#
    FS25 - MONITORING SCRIPT 
    Autheur : Patrick
    Vérifie si FS25 tourne , sinon redémarre
#>

$LogFile = "C:\FS25\monitor.log"
$ServiceName = "FS25-Server"

fonction Log {
    param([string] $Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timestamp] $Message"
}

$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if($Service -and $Service.Status -eq "Running") {
    Log "FS25 OK"
    exit
}

Log "FS25 DOWN - Redémarrage ..."
Start-Service $ServiceName
Log "FS25 Redémarré."