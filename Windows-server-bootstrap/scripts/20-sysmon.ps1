# Installation et configuration de Sysmon (Microsoft Sysinternals)
# Equivalent Windows à auditd / osquery / Falco

Write-Host "Installation et configuration de Sysmon..." -ForegroundColor Cyan

# 1. Définir dossier temporaire
$TempDir = "$env:TEMP\Sysmon"
$SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$SysmonZip = "$TempDir\Sysmon.zip"
$SysmonExe = "$TempDir\Sysmon.exe"
$ConfigFile = "$TempDir\SysmonConfig.xml"

# Création du dossier temporaire
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

# 2. Téléchargement de Sysmon
Write-Host "Téléchargement de Sysmon..."
Invoke-WebRequest -Uri $SysmonUrl -OutFile $SysmonZip

# 3. Extraction
Write-Host "Extraction..."
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($SysmonZip, $TempDir)

# 4. Création d’un fichier de configuration basique Sysmon
# Logging des processus, réseau, fichiers, etc.
$ConfigXml = @"
<Sysmon schemaversion="4.71">
  <!-- Log process creation with command line -->
  <EventFiltering>
    <ProcessCreate onmatch="include">
      <CommandLine condition="is not empty" />
    </ProcessCreate>

    <!-- Log network connections -->
    <NetworkConnect onmatch="include" />

    <!-- Log file creation / deletion (optional) -->
    <FileCreateTime onmatch="include" />
    <FileCreate onmatch="include" />

    <!-- Load image (DLL) events -->
    <ImageLoad onmatch="include" />

    <!-- Registry events -->
    <
