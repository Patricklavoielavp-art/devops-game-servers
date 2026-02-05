# Installation et activation de Windows LAPS (Windows LAPS intégré)

Write-Host "Configuration de Windows LAPS..." -ForegroundColor Cyan

$BasePath = "HKLM:\SOFTWARE\Microsoft\Policies\LAPS"

New-Item -Path $BasePath -Force | Out-Null

# Nom du compte administrateur local
Set-ItemProperty -Path $BasePath -Name "AdministratorAccountName" -Value "Administrator" -Type String

# Activer la sauvegarde du mot de passe dans Active Directory
Set-ItemProperty -Path $BasePath -Name "BackupDirectory" -Value 1 -Type DWord

# Complexité du mot de passe
# 4 = maj + min + chiffres + symboles
Set-ItemProperty -Path $BasePath -Name "PasswordComplexity" -Value 4 -Type DWord

# Longueur du mot de passe
Set-ItemProperty -Path $BasePath -Name "PasswordLength" -Value 14 -Type DWord

# Âge du mot de passe (jours)
Set-ItemProperty -Path $BasePath -Name "PasswordAgeDays" -Value 30 -Type DWord

Write-Host "Paramètres LAPS configurés"

# Mise à jour des policies
gpupdate /force | Out-Null

# Rotation immédiate
try {
    Invoke-LapsPolicyProcessing
    Write-Host "Rotation du mot de passe administrateur déclenchée"
}
catch {
    Write-Host "Invoke-LapsPolicyProcessing non disponible (normal si hors domaine)"
}

Write-Host "Windows LAPS configuré avec succès." -ForegroundColor Green
