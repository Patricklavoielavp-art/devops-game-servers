# Hybrid enterprise-style Windows Server 2022 bootstrap
# Fully cleaned, safe for PowerShell execution

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogFile = "C:\Windows\Temp\windows-bootstrap.log"

# Start logging
Start-Transcript -Path $LogFile -Append

Write-Host "========================================"
Write-Host "🚀 Windows Server Bootstrap Starting"
Write-Host "🕒 $(Get-Date)"
Write-Host "========================================"

# Load configuration
$configFile = Join-Path $ScriptDir "config\server.psd1"
if (Test-Path $configFile) {
    . $configFile
    Write-Host "✅ Configuration loaded from server.psd1"
} else {
    Write-Host "⚠️ Configuration file not found: $configFile"
}

# Base system scripts
$baseScripts = @(
    "00-check-admin.ps1",
    "01-windows-update.ps1",
    "02-users.ps1",
    "03-rdp.ps1",
    "04-firewall.ps1",
    "05-defender.ps1",
    "06-audit-policy.ps1"
)

# Optional / hybrid scripts
$optionalScripts = @(
    "07-winget-packages.ps1",
    "08-docker.ps1",
    "09-monitoring.ps1",
    "10-hardening.ps1",
    "12-uac.ps1",
    "14-disable-smbv1.ps1",
    "16-powershell-logging.ps1",
    "18-rdp-hardening.ps1",
    "19-eventlog-retention.ps1",
    "22-ntp.ps1",
    "23-disk-optimization.ps1",
    "24-crashdump.ps1"
)

# -----------------------------
# Run base scripts
# -----------------------------
foreach ($script in $baseScripts) {
    $path = Join-Path $ScriptDir ("scripts\" + $script)
    if (Test-Path $path) {
        Write-Host "➡ Running $script"
        & $path
    } else {
        Write-Host "⚠️ Base script not found: $script"
    }
}

# -----------------------------
# Run optional scripts if enabled
# -----------------------------
foreach ($script in $optionalScripts) {
    $scriptName = $script.Split('.')[0]
    $enabledVarName = "ENABLE_$scriptName"

    $enabledVar = $false
    $var = Get-Variable -Name $enabledVarName -Scope Script -ErrorAction SilentlyContinue
    if ($var) { $enabledVar = $var.Value }

    if ($enabledVar -eq $true) {
        $path = Join-Path $ScriptDir ("scripts\" + $script)
        if (Test-Path $path) {
            Write-Host "➡ Running optional script $script"
            & $path
        } else {
            Write-Host "⚠️ Optional script not found: $script"
        }
    } else {
        Write-Host "ℹ️ Optional script $script skipped"
    }
}

Write-Host "========================================"
Write-Host "✅ Bootstrap complete"
Write-Host "🧾 Log file: $LogFile"
Write-Host "========================================"

Stop-Transcript
