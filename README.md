# DevOps Game Server Framework  
Gestion automatisée de serveurs ARK: Survival Ascended, Palworld et Farming Simulator 25

Ce projet fournit une plateforme DevOps complète permettant d’installer, mettre à jour, sauvegarder, monitorer et administrer plusieurs serveurs de jeux vidéo, sur Linux et Windows, via une architecture modulaire, YAML‑driven et entièrement automatisée.

---

## 🚀 Fonctionnalités principales

### ✔ Multi‑serveurs
- ARK: Survival Ascended (Linux)
- Palworld (Linux)
- Farming Simulator 25 (Windows)

### ✔ Automatisation complète
- Installation
- Mise à jour
- Sauvegardes (avec rotation)
- Monitoring (auto‑heal)
- Services systemd (Linux) / NSSM (Windows)
- Démarrage propre
- Setup complet en une commande

### ✔ CLI global
- `cli.sh` pour Linux (ARK + Palworld)
- `cli.ps1` pour Windows (FS25)

### ✔ Architecture modulaire
- Scripts séparés par jeu
- COMMON/ pour les modules partagés
- Configuration centralisée via `config.yaml`

### ✔ Portfolio‑ready
- Code propre, robuste, idempotent
- Documentation claire
- Structure professionnelle

---

## 📂 Structure du dépôt

 ├── ark/ 
 │   ├── install.sh 
 │   ├── update.sh 
 │   ├── backup.sh 
 │   ├── monitor.sh 
 │   ├── start_ark.sh 
 │   └── setup.sh 
 │ ├── palworld/ 
 │   ├── install.sh 
 │   ├── update.sh 
 │   ├── backup.sh
 │   ├── monitor.sh 
 │   ├── start_palworld.sh 
 │   └── setup.sh 
 │ ├── fs25/ 
 │   ├── install.ps1 
 │   ├── update.ps1 
 │   ├── backup.ps1 
 │   ├── monitor.ps1 
 │   ├── start_fs25.ps1 
 │   └── setup_fs25.ps1 
 │ ├── COMMON/ 
 │   ├── common.sh 
 │   ├── yaml.sh 
 │   ├── system.sh 
 |   ├── network.sh 
 │   ├── backup.sh 
 │   └── generate_service.sh 
 ├── cli.sh 
 ├── cli.ps1 
 ├── config.yaml 
 └── docs/ 
 |    ├── architecture.md 
 |    ├── ark.md ├── palworld.md 
 |    └── fs25.md

---

## ⚙️ Configuration (config.yaml)

Toute la plateforme est pilotée par un fichier unique :

```yaml
gameservers:
  ark:
    enabled: true
    os: linux
    user: "steam"
    install_dir: "/opt/ark"
    service_name: "ark"
    appid: 2430930
    ports:
      game: 7777
    backup:
      source: "/opt/ark/ShooterGame/Saved"
      retention_days: 5
    monitoring:
      enabled: true
      interval: 60
      restart_on_fail: true
      discord_webhook: ""

  palworld:
    enabled: true
    os: linux
    user: "steam"
    install_dir: "/opt/palworld"
    service_name: "palworld"
    appid: 2394010
    ports:
      game: 8211
      query: 27015
    backup:
      source: "/opt/palworld/Pal/Saved"
      retention_days: 5
    monitoring:
      enabled: true
      interval: 60
      restart_on_fail: true
      discord_webhook: ""

  fs25:
    enabled: true
    os: windows
    user: "fs25"
    install_dir: "C:\\FS25"
    service_name: "FS25"
    appid: 2430930
    ports:
      game: 10823
    backup:
      source: "C:\\FS25\\savegame"
      retention_days: 7
    monitoring:
      enabled: true
      interval: 60
      restart_on_fail: true
      discord_webhook: ""

# 🖥️ CLI global
Linux (ARK + Palworld)

./cli.sh install ark
./cli.sh update palworld
./cli.sh backup ark
./cli.sh monitor palworld
./cli.sh setup ark

Windows (FS25)

cli.ps1 install fs25
cli.ps1 update fs25
cli.ps1 backup fs25
cli.ps1 monitor fs25
cli.ps1 setup fs25

# 🛠️ Installation rapide

Linux

git clone https://github.com/tonrepo/devops-game-servers
cd devops-game-servers
chmod +x cli.sh
./cli.sh setup ark

Windows

git clone https://github.com/tonrepo/devops-game-servers
cd devops-game-servers
powershell.exe -ExecutionPolicy Bypass -File cli.ps1 setup fs25

# 📡 Monitoring & Auto‑Heal
• 	Vérification du service systemd / NSSM
• 	Vérification du port du serveur
• 	Redémarrage automatique
• 	Alerte Discord optionnelle

🔒 Sécurité
- Scripts idempotents
- Pas de credentials en clair
- Pas de dépendances externes non maîtrisées
- Utilisateurs dédiés par jeu

# Auteur : Patrick Lavoie
Projet conçu pour être un portfolio DevOps professionnel, démontrant :
- automatisation multi‑OS
- scripting Bash & PowerShell
- gestion de services
- monitoring
- architecture modulaire
- documentation claire
