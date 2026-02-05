
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (!$principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Administrator privileges confirmed."