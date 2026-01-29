# ---------------------------------------------
# SECTION SERVICE FS25 - Création et démarrage
# ---------------------------------------------
$ServiceName = "FS25-Server"
$NssmDir = "C:\nssm"
$NssmExe = Join-Path $NssmDir "nssm.exe"
$StartScript = "C:\FS25\start_fs25.ps1"
$LogDir = "C:\FS25\logs"

# --- Création dossier logs ---
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
}

# --- Téléchargement NSSM si absent ---
if (-not (Test-Path $NssmExe)) {
    Write-Host "Téléchargement de NSSM..."
    New-Item -ItemType Directory -Force -Path $NssmDir | Out-Null
    $NssmZip = Join-Path $NssmDir "nssm.zip"
    
    Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile $NssmZip
    Expand-Archive -Path $NssmZip -DestinationPath $NssmDir -Force
    Remove-Item $NssmZip
    
    # NSSM se trouve généralement dans nssm-2.24\win64\nssm.exe
    $NssmExe = Join-Path $NssmDir "nssm-2.24\win64\nssm.exe"
}

# --- Vérification du script start_fs25.ps1 ---
if (-not (Test-Path $StartScript)) {
    Write-Host "Erreur: start_fs25.ps1 introuvable à $StartScript" -ForegroundColor Red
    exit 1
}

# --- Suppression du service existant ---
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Service $ServiceName existe deja. Arret et suppression..."
    Stop-Service -Name $ServiceName -Force
    & "$NssmExe" remove $ServiceName confirm
    Write-Host "Service supprime."
}

# --- Création du service avec logs ---
Write-Host "Creation du service $ServiceName..."
& "$NssmExe" install $ServiceName `
    "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
    "-NoProfile -ExecutionPolicy Bypass -File `"$StartScript`""

# --- Configuration des logs NSSM ---
& "$NssmExe" set $ServiceName AppStdout (Join-Path $LogDir "stdout.log")
& "$NssmExe" set $ServiceName AppStderr (Join-Path $LogDir "stderr.log")
& "$NssmExe" set $ServiceName AppRotateFiles 1

# --- Démarrage du service ---
Write-Host "Demarrage du service $ServiceName..."
Start-Service -Name $ServiceName

# --- Vérification de l'état du service ---
$svc = Get-Service -Name $ServiceName
if ($svc.Status -eq "Running") {
    Write-Host "Service $ServiceName demarre avec succes." -ForegroundColor Green
} else {
    Write-Host "Erreur: le service $ServiceName n'a pas demarre. Consultez $LogDir\stdout.log et stderr.log" -ForegroundColor Red
}
