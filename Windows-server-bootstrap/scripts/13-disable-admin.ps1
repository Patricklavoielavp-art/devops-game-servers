# Désactive le compte Administrator local

Write-Host "Désactivation du compte Administrator..." -ForegroundColor Cyan

try {
    Disable-LocalUser -Name "Administrator"
    Write-Host "Compte Administrator désactivé." -ForegroundColor Green
}
catch {
    Write-Host "Erreur lors de la désactivation du compte Administrator." -ForegroundColor Red
    Write-Host $_
}
