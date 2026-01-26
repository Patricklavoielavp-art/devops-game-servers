## 🚜 Farming Simulator 25 — Serveur Dédié (Windows)
Framework d’automatisation pour installer, configurer, mettre à jour et gérer un serveur Farming Simulator 25 sous Windows.
Conçu pour être simple, reproductible et adapté à une architecture multi‑serveurs.

# 📂 Structure du dossier
FS25/
 ├── INSTALL/
 │     └── install_fs25.ps1
 ├── UPDATE/
 │     └── update_fs25.ps1
 ├── BACKUP/
 │     └── backup_fs25.ps1
 ├── MONITOR/
 │     └── monitor_fs25.ps1
 ├── SERVICE/
 │     └── fs25_service.xml   (si utilisation de NSSM)
 └── CONFIG/
       └── fs25_config.json


Les noms exacts peuvent être adaptés selon ton repo actuel — je peux les harmoniser si tu me montres ton arborescence.


# ⚙️ Fonctionnalités principales
✔️ Installation automatisée (PowerShell)
- Téléchargement du serveur dédié FS25
- Création des dossiers nécessaires
- Configuration initiale
- Enregistrement du service Windows (NSSM ou sc.exe)
✔️ Mise à jour
- Vérification de la version locale
- Téléchargement des mises à jour
- Redémarrage contrôlé du service
✔️ Sauvegardes
- Copie des fichiers critiques
- Compression ZIP
- Rotation configurable
✔️ Monitoring
- Vérification du statut du service
- Logs
- Redémarrage automatique optionnel

# 🪟 Prérequis Windows
- Windows 10 / 11 / Server 2019+
- PowerShell 5.1 ou PowerShell 7
- Droits administrateur
- NSSM (recommandé) pour gérer le service
https://nssm.cc/download

# 🚀 Installation du serveur FS25
Depuis PowerShell en administrateur :
Set-ExecutionPolicy Bypass -Scope Process -Force
.\INSTALL\install_fs25.ps1


Le script :
- crée les dossiers
- télécharge le serveur
- configure les fichiers
- installe le service Windows

# 🔧 Gestion du service Windows
Démarrer le serveur
Start-Service FS25


Arrêter le serveur
Stop-Service FS25


Vérifier le statut
Get-Service FS25


Redémarrer
Restart-Service FS25



# 📦 Sauvegardes
Les sauvegardes sont générées dans :
C:\FS25\backups\


Rotation configurable dans backup_fs25.ps1.
Pour lancer une sauvegarde manuelle :
.\BACKUP\backup_fs25.ps1



# 🔍 Monitoring
Pour vérifier l’état du serveur :
.\MONITOR\monitor_fs25.ps1


Fonctionnalités :
- statut du service
- disponibilité du port
- logs
- redémarrage automatique (optionnel)

# 🛣️ Roadmap FS25 (Windows)
- [ ] Ajout d’un dashboard local (HTML)
- [ ] Intégration Prometheus Windows Exporter
- [ ] Support Docker Windows (si utile)
- [ ] CLI unifié multi‑jeux

# 🤝 Contribution
Projet personnel DevOps — ouvert aux suggestions et améliorations.


