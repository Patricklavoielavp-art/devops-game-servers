## 📘 docs/fs25.md
Farming Simulator 25 — Documentation du module serveur (Windows)

# 🚜 1. Présentation
Ce module gère entièrement un serveur Farming Simulator 25 Dedicated Server sous Windows, via une architecture automatisée, modulaire et pilotée par config.yaml.
Il inclut :
- installation via SteamCMD
- mise à jour automatisée
- sauvegardes avec rotation
- monitoring (auto‑heal + port check)
- service Windows via NSSM
- démarrage propre
- orchestration complète via setup_fs25.ps1
- intégration au CLI global Windows (cli.ps1)

# 🧩 2. Structure du module FS25
fs25/
├── install.ps1
├── update.ps1
├── backup.ps1
├── monitor.ps1
├── start_fs25.ps1
└── setup_fs25.ps1


Chaque script est indépendant, modulaire et 100 % YAML‑driven.

# ⚙️ 3. Configuration (config.yaml)
Exemple de configuration FS25 :
gameservers:
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



# 🛠️ 4. Scripts du module
4.1 install.ps1 — Installation complète
Fonctionnalités :
- installation via SteamCMD (méthode officielle)
- installation automatique de SteamCMD si absent
- création de l’utilisateur Windows dédié
- création des dossiers
- installation idempotente
- logs propres
Commande :
cli.ps1 install fs25



4.2 update.ps1 — Mise à jour
Fonctionnalités :
- mise à jour via SteamCMD
- validation des fichiers
- redémarrage automatique du service Windows
- logs professionnels
Commande :
cli.ps1 update fs25



4.3 backup.ps1 — Sauvegarde + rotation
Fonctionnalités :
- compression .zip
- rotation automatique selon retention_days
- purge des anciens backups
- notification Discord optionnelle
- logs propres
Commande :
cli.ps1 backup fs25



4.4 monitor.ps1 — Monitoring + auto‑heal
Fonctionnalités :
- vérification du service Windows
- vérification du port du serveur
- redémarrage automatique en cas de crash
- alerte Discord optionnelle
- logs professionnels
Commande :
cli.ps1 monitor fs25



4.5 start_fs25.ps1 — Démarrage du serveur
Fonctionnalités :
- construction de la commande FS25
- lecture des ports via YAML
- lancement propre via Start-Process
- parfait pour un service Windows (NSSM)
Commande :
cli.ps1 start fs25



4.6 setup_fs25.ps1 — Orchestration complète
Fonctionnalités :
- installation
- mise à jour
- installation de NSSM
- création du service Windows
- démarrage du service
- healthcheck du port
- logs professionnels
Commande :
cli.ps1 setup fs25



# 🖥️ 5. Service Windows (NSSM)
Généré automatiquement via setup_fs25.ps1.
Exemple :
Service Name: FS25
Executable: powershell.exe
Arguments: -ExecutionPolicy Bypass -File "C:\FS25\start_fs25.ps1"
Startup: Automatic
Working Directory: C:\FS25
Restart: Always



# 🔄 6. Flux opérationnel FS25
Installation complète
setup → install → update → install NSSM → create service → start → healthcheck


Mise à jour
update → restart service → healthcheck


Backup
backup → compression → rotation → purge → Discord


Monitoring
monitor → check service → check port → restart on fail → Discord



# 🛡️ 7. Sécurité
- utilisateur Windows dédié (fs25)
- service isolé via NSSM
- ports configurables
- scripts idempotents
- pas de credentials en clair

# 📦 8. Intégration CLI
cli.ps1 install fs25
cli.ps1 update fs25
cli.ps1 backup fs25
cli.ps1 monitor fs25
cli.ps1 start fs25
cli.ps1 setup fs25



# 🧑‍💻 9. Objectif du module
Ce module démontre :
- maîtrise de PowerShell avancé
- automatisation SteamCMD Windows
- gestion de services via NSSM
- monitoring et auto‑heal Windows
- architecture modulaire
- documentation professionnelle


