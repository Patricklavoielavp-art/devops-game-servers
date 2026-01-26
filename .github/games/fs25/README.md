## FS25 Dedicated Server – Windows Automation
# 📌 Description
Ce dossier contient l’ensemble des scripts PowerShell permettant d’installer, mettre à jour, sauvegarder, monitorer et exécuter un serveur Farming Simulator 25 sur Windows.
L’objectif : fournir une solution automatisée, robuste et professionnelle.

# 📁 Structure
fs25/
├── install.ps1
├── update.ps1
├── backup.ps1
├── start_fs25.ps1
├── stop_fs25.ps1
├── restart_fs25.ps1
├── auto-update_fs25.ps1
├── monitor_fs25.ps1
└── service/
    └── fs25-service-setup.ps1



# 🚀 Installation
- Exécuter :
.\install.ps1


- Installer le service Windows :
.\service\fs25-service-setup.ps1


- Démarrer le serveur :
.\start_fs25.ps1



# 🔄 Mise à jour
.\update.ps1


Ou automatiquement :
.\auto-update_fs25.ps1



# 💾 Sauvegardes
.\backup.ps1


Les backups sont compressés dans C:\FS25\backups.

# 🩺 Monitoring
Planifier :
.\monitor_fs25.ps1



# 🧰 Service Windows
Le service s’appelle :
FS25-Server


# Commandes utiles :
Start-Service FS25-Server
Stop-Service FS25-Server
Restart-Service FS25-Server




