param(
    [Parameter(Mandatory=$true)]
    [string]$InstanceName
)

$ErrorActionPreference = "Stop"

# --- Chemins de base ---
$ROOT = "C:\devops-game-servers"
$InstanceName = $InstanceName.ToLower()
$InstancePath = Join-Path $ROOT "fs25\instances\$InstanceName"

# Créer dossiers de l'instance si nécessaire
foreach ($sub in @("Saved","Mods","logs","Backups")) {
    $subPath = Join-Path $InstancePath $sub
    if (-not (Test-Path $subPath)) {
        New-Item -ItemType Directory -Force -Path $subPath | Out-Null
    }
}

# --- Dossier dédié FS25 ---
$DedicatedDir = Join-Path $InstancePath "Saved\dedicated_server"
if (-not (Test-Path $DedicatedDir)) {
    New-Item -ItemType Directory -Force -Path $DedicatedDir | Out-Null
}

# --- Config XML par défaut ---
$ConfigXmlPath = Join-Path $DedicatedDir "dedicatedServerConfig.xml"
if (-not (Test-Path $ConfigXmlPath)) {
    $xmlContent = @"
<?xml version="1.0" encoding="utf-8" standalone="no" ?>
<server>
    <webserver port="8080">
        <initial_admin>
            <username>admin</username>
            <passphrase>TQZPSEC2</passphrase>
        </initial_admin>
        <tls port="8443" active="false" />
    </webserver>
    <game description="Farming Simulator 25" name="FarmingSimulator2025" exe="dedicatedServer.exe" />
</server>
"@
    $xmlContent | Out-File -Encoding UTF8 -FilePath $ConfigXmlPath
}

# --- Chemins FS25 ---
$FS25Install = "C:\Program Files (x86)\Steam\steamapps\common\Farming Simulator 25"
$ExePath = Join-Path $FS25Install "FS25DedicatedServer.exe"

$SavedDir = Join-Path $InstancePath "Saved"
$LogDir = Join-Path $InstancePath "logs"
$ServerLog = Join-Path $LogDir "fs25_server.log"
$WrapperLog = Join-Path $LogDir "fs25_wrapper.log"
$ModsDir  = Join-Path $InstancePath "Mods"
$BackupDst= Join-Path $InstancePath "Backups"
$RetentionDays = 7   # jours à conserver les backups

# --- Fonction log wrapper ---
function Log { param([string]$M)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $M" | Out-File -Append -FilePath $WrapperLog -Encoding UTF8
}

# --- Backup automatique ---
function Run-Backup {
    try {
        $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $ZipPath = Join-Path $BackupDst "FS25_$Stamp.zip"
        Compress-Archive -Path "$SavedDir\*" -DestinationPath $ZipPath -CompressionLevel Optimal
        # Supprimer anciens backups
        Get-ChildItem $BackupDst -Filter "FS25_*.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } | Remove-Item -Force
        Log "Backup OK : FS25_$Stamp.zip"
    } catch { Log "Erreur backup : $_" }
}

# --- Rotation logs wrapper ---
if (Test-Path $WrapperLog) {
    Move-Item $WrapperLog (Join-Path $LogDir "fs25_wrapper_$(Get-Date -Format yyyyMMdd_HHmmss).log") -Force
}
New-Item -ItemType File -Force -Path $WrapperLog | Out-Null

# --- Arguments serveur ---
$Args = "-saveDir `"$SavedDir`" -log"

# --- Vérifier exe ---
if (-not (Test-Path $ExePath)) {
    Log "Erreur : FS25DedicatedServer.exe introuvable ! Chemin utilisé : $ExePath"
    exit 1
}

# --- Lancer serveur ---
$Process = Start-Process -FilePath $ExePath `
    -ArgumentList $Args `
    -WorkingDirectory $FS25Install `
    -NoNewWindow -PassThru `
    -RedirectStandardOutput $ServerLog

Log "FS25 lancé (PID=$($Process.Id))"

# --- Ouvrir WebAdmin après 10 secondes ---
Start-Sleep -Seconds 10
if (Get-Command msedge.exe -ErrorAction SilentlyContinue) {
    Start-Process "msedge.exe" -ArgumentList "http://192.168.18.54:8080"
    Log "WebAdmin ouvert dans Edge"
} else {
    Log "Edge non trouvé, WebAdmin non ouvert"
}

# --- Boucle monitoring ---
while ($true){
    Start-Sleep -Seconds 60
    if (-not (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) { 
        Log "FS25 arrêté"
        exit 1
    }
}
