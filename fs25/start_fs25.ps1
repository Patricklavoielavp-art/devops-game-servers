param(
    [Parameter(Mandatory=$true)]
    [string]$InstanceName
)

# Paths
$ROOT = "C:\devops-game-servers"
$InstanceName = $InstanceName.ToLower()
$InstancePath = Join-Path $ROOT "fs25\instances\$InstanceName"
$SavedDir = Join-Path $InstancePath "Saved"

# Stop old processes
Get-Process -Name dedicatedServer -ErrorAction SilentlyContinue | Stop-Process -Force

# Clean DB lock files
Remove-Item "$SavedDir\dedicated_server\*.db-journal" -ErrorAction SilentlyContinue

# Path to executable
$ExePath = "C:\Program Files (x86)\Steam\steamapps\common\Farming Simulator 25\dedicatedServer.exe"
if (-not (Test-Path $ExePath)) { Write-Error "DedicatedServer.exe introuvable"; exit 1 }

# Arguments
$Args = "-saveDir `"$SavedDir`" -log"

# Start the server in a new window
Start-Process -FilePath $ExePath -ArgumentList $Args -WorkingDirectory "C:\Program Files (x86)\Steam\steamapps\common\Farming Simulator 25\x64" -WindowStyle Normal
