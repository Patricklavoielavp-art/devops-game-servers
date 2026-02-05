# Hardening WinRM
# - Disable Basic authentication
# - Disable unencrypted traffic

Write-Host "Configuration du hardening WinRM..." -ForegroundColor Cyan

try {
    # Service WinRM
    Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $false
    Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $false

    # Client WinRM
    Set-Item -Path WSMan:\localhost\Client\Auth\Basic -Value $false
    Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $false

    Write-Host "Basic auth désactivé"
    Write-Host "Unencrypted WinRM désactivé"
}
catch {
    Write-Host "Erreur lors de la configuration WinRM" -ForegroundColor Red
    Write-Host $_
}

Write-Host "Hardening WinRM terminé." -ForegroundColor Green
