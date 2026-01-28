# # 📘 docs/palworld.md
Palworld — Documentation du module serveur

# 🐦‍🔥 1. Présentation
Ce module gère entièrement un serveur Palworld Dedicated Server sous Linux, via une architecture automatisée, modulaire et pilotée par config.yaml.
Il inclut :
- installation via SteamCMD
- mise à jour automatisée
- sauvegardes avec rotation
- monitoring (auto‑heal + port check)
- service systemd
- démarrage propre
- orchestration complète via setup.sh
- intégration au CLI global

# 🧩 2. Structure du module Palworld
palworld/
├── install.sh
├── update.sh
├── backup.sh
├── monitor.sh
├── start_palworld.sh
└── setup.sh


Chaque script est indépendant, modulaire et 100 % YAML‑driven.

# ⚙️ 3. Configuration (config.yaml)
Exemple de configuration Palworld :
gameservers:
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



# 🛠️ 4. Scripts du module
4.1 install.sh — Installation complète
Fonctionnalités :
- installation via SteamCMD
- création de l’utilisateur dédié
- création des dossiers
- installation idempotente
- logs professionnels
Commande :
./cli.sh install palworld



4.2 update.sh — Mise à jour
Fonctionnalités :
- mise à jour via SteamCMD
- validation des fichiers
- redémarrage automatique du service systemd
- logs propres
Commande :
./cli.sh update palworld



4.3 backup.sh — Sauvegarde + rotation
Fonctionnalités :
- compression .tar.gz
- rotation automatique selon retention_days
- purge des anciens backups
- notification Discord optionnelle
- logs professionnels
Commande :
./cli.sh backup palworld



4.4 monitor.sh — Monitoring + auto‑heal
Fonctionnalités :
- vérification du service systemd
- vérification du port du serveur
- redémarrage automatique en cas de crash
- alerte Discord optionnelle
- logs propres
Commande :
./cli.sh monitor palworld



4.5 start_palworld.sh — Démarrage du serveur
Fonctionnalités :
- construction de la commande Palworld
- lecture des ports et paramètres via YAML
- exécution via exec (parfait pour systemd)
- logs propres
Commande :
./cli.sh start palworld



4.6 setup.sh — Orchestration complète
Fonctionnalités :
- installation
- mise à jour
- génération du service systemd
- démarrage
- healthcheck du port
- logs professionnels
Commande :
./cli.sh setup palworld



# 🖥️ 5. Service systemd
Généré automatiquement via COMMON/generate_service.sh.
Exemple :
[Unit]
Description=Palworld Dedicated Server
After=network.target

[Service]
User=steam
WorkingDirectory=/opt/palworld
ExecStart=/opt/palworld/start_palworld.sh
Restart=always

[Install]
WantedBy=multi-user.target



# 🔄 6. Flux opérationnel Palworld
Installation complète
setup → install → update → generate_service → start → healthcheck


Mise à jour
update → restart service → healthcheck


Backup
backup → compression → rotation → purge → Discord


Monitoring
monitor → check service → check port → restart on fail → Discord



# 🛡️ 7. Sécurité
- utilisateur dédié steam
- service systemd isolé
- ports configurables
- scripts idempotents
- pas de credentials en clair

# 📦 8. Intégration CLI
./cli.sh install palworld
./cli.sh update palworld
./cli.sh backup palworld
./cli.sh monitor palworld
./cli.sh start palworld
./cli.sh setup palworld



# 🧑‍💻 9. Objectif du module
Ce module démontre :
- maîtrise de Bash avancé
- automatisation SteamCMD
- gestion de services systemd
- monitoring et auto‑heal
- architecture modulaire
- documentation professionnelle
