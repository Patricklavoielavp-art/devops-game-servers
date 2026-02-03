param(
    [Parameter(Mandatory=$true)]
    [string]$InstanceName
)

# Toujours Stop si un ancien serveur tourne
Get-Process -Name dedicatedServer -ErrorAction SilentlyContinue | Stop-Process -Force

# Base paths
$ROOT = "C:\devops-game-servers"
$InstanceName = $InstanceName.ToLower()
$InstancePath = Join-Path $ROOT "fs25\instances\$InstanceName"

# Créer dossiers si manquants
foreach ($sub in @("Saved","Mods","logs","Backups")) {
    $subPath = Join-Path $InstancePath $sub
    if (-not (Test-Path $subPath)) { New-Item -ItemType Directory -Force -Path $subPath | Out-Null }
}

$SavedDir = Join-Path $InstancePath "Saved"
$LogDir   = Join-Path $InstancePath "logs"
$ServerLog = Join-Path $LogDir "fs25_server.log"
$WrapperLog = Join-Path $LogDir "fs25_wrapper.log"

# Supprimer fichiers DB lock
Remove-Item "$SavedDir\dedicated_server\*.db-journal" -ErrorAction SilentlyContinue

# Chemin correct vers l’exécutable
$ExePath = "C:\Program Files (x86)\Steam\steamapps\common\Farming Simulator 25\dedicatedServer.exe"
if (-not (Test-Path $ExePath)) { Write-Error "DedicatedServer.exe introuvable"; exit 1 }

# Construire arguments
$Args = "-saveDir `"$SavedDir`" -log"

# Logger wrapper
function Log { param([string]$M)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $M" | Out-File -Append -FilePath $WrapperLog -Encoding UTF8
}

# Rotation wrapper log
if (Test-Path $WrapperLog) { Move-Item $WrapperLog (Join-Path $LogDir "fs25_wrapper_$(Get-Date -Format yyyyMMdd_HHmmss).log") -Force }
New-Item -ItemType File -Force -Path $WrapperLog | Out-Null

# Lancer le serveur en arrière-plan
$Process = Start-Process -FilePath $ExePath `
    -ArgumentList $Args `
    -WorkingDirectory "C:\Program Files (x86)\Steam\steamapps\common\Farming Simulator 25\x64" `
    -NoNewWindow -PassThru `
    -RedirectStandardOutput $ServerLog

Log "FS25 lancé (PID=$($Process.Id))"

# Boucle simple pour garder wrapper actif
while ($true){
    Start-Sleep -Seconds 60
    if (-not (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) { Log "FS25 arrêté"; exit 1 }
}
