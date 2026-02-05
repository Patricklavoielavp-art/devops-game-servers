# Configure Windows Update: automatic updates, scheduled installs, reboot policy

Write-Host "Configuration de Windows Update..." -ForegroundColor Cyan

try {
    # Mode automatique avec planification
    # 4 = Auto download and schedule the install
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 4 -Type DWord -ErrorAction SilentlyContinue

    # Heure planifiée pour les mises à jour (ex: 3h du matin)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "ScheduledInstallDay" -Value 0 -Type DWord # 0 = chaque jour
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "ScheduledInstallTime" -Value 3 -Type DWord

    # Pas de redémarrage automatique sans notification
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord

    Write-Host "Windows Update configuré : installation planifiée à 03h, redémarrage contrôlé." -ForegroundColor Green
}
catch {
    Write-Host "Erreur lors de la configuration de Windows Update" -ForegroundColor Red
    Write-Host $_
}
