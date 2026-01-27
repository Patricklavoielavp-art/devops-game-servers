# 📘 docs/architecture.md
Architecture du Framework DevOps Multi‑Serveurs
Gestion automatisée de serveurs ARK: Survival Ascended, Palworld et Farming Simulator 25

 # 🏗️ 1. Vue d’ensemble
Ce framework fournit une plateforme DevOps complète permettant de gérer plusieurs serveurs de jeux vidéo sur Linux et Windows, via une architecture modulaire, automatisée et entièrement pilotée par un fichier unique : .
L’objectif est de fournir :
• 	une infrastructure reproductible
• 	une automatisation complète (install, update, backup, monitoring, services)
• 	une architecture modulaire par jeu
• 	un CLI global unifié
• 	une documentation professionnelle

# 🧩 2. Architecture globale
+---------------------------------------------------------------+
|                        config.yaml                            |
|     (Configuration centrale pour tous les serveurs)           |
+---------------------------------------------------------------+
                |                    |                    |
                v                    v                    v
        +--------------+     +--------------+     +--------------+
        |     ARK      |     |   Palworld   |     |     FS25     |
        |   (Linux)    |     |   (Linux)    |     |  (Windows)   |
        +--------------+     +--------------+     +--------------+
        | install.sh   |     | install.sh   |     | install.ps1  |
        | update.sh    |     | update.sh    |     | update.ps1   |
        | backup.sh    |     | backup.sh    |     | backup.ps1   |
        | monitor.sh   |     | monitor.sh   |     | monitor.ps1  |
        | start_ark.sh |     | start_pal..  |     | start_fs25.. |
        | setup.sh     |     | setup.sh     |     | setup_fs25.. |
        +--------------+     +--------------+     +--------------+
                |                    |                    |
                +--------------------+--------------------+
                                     |
                                     v
                         +-----------------------+
                         |        COMMON/        |
                         |  Modules partagés     |
                         +-----------------------+
                         | common.sh             |
                         | yaml.sh               |
                         | system.sh             |
                         | network.sh            |
                         | backup.sh             |
                         | generate_service.sh   |
                         +-----------------------+
                                     |
                                     v
                         +-----------------------+
                         |        CLI global     |
                         +-----------------------+
                         | cli.sh  (Linux)       |
                         | cli.ps1 (Windows)     |
                         +-----------------------+

 # 🧠 3. Rôle des composants
3.1 config.yaml — Le cœur du système
Ce fichier centralise toute la configuration :
- chemins d’installation
- utilisateurs
- ports
- paramètres du jeu
- configuration des backups
- monitoring
- webhooks Discord
- AppIDs SteamCMD
Chaque script lit ce fichier via un loader YAML (Bash ou PowerShell).

3.2 COMMON/ — Modules partagés
Le dossier COMMON/ contient les modules réutilisables :
|Module               | Rôle                                      | 
| common.sh           | Logging, colors, helpers                  | 
| yaml.sh             | Lecture du YAML en Bash                   | 
| system.sh           | Gestion systemd(start/stop/status)        | 
| network.sh          | Vérification de ports                     | 
| backup.sh           | Fonctions de rotation/purge               | 
| generate_service.sh | Génération automatique de services sytemd | 


Ces modules garantissent :
- cohérence entre les jeux
- réduction de duplication
- maintenance simplifiée
- architecture professionnelle

3.3 Modules par jeu
Chaque jeu possède son propre dossier contenant :
| Script    | Rôle                                                          | 
| install   | Installation complète du serveur                              | 
| update    | Mise à jour via SteamCMD                                      | 
| backup    | Sauvegarde + rotation + Discord                               | 
| monitor   | Auto-heal + port check + Discord                              | 
| start     | Lancement du serveur                                          | 
| setup     | Orchestration complète (install + update + service + start)   | 


Linux (ARK & Palworld)
- Services systemd
- Bash
- SteamCMD Linux
- Monitoring via cron ou systemd timer
Windows (FS25)
- PowerShell
- SteamCMD Windows
- Services via NSSM
- Monitoring via tâches planifiées

# 🖥️ 4. CLI global
Le CLI global fournit une interface unifiée :
Linux

./cli.sh install ark
./cli.sh update palworld
./cli.sh backup ark
./cli.sh monitor palworld
./cli.sh setup ark

Windows 

cli.ps1 install fs25
cli.ps1 update fs25
cli.ps1 backup fs25
cli.ps1 monitor fs25
cli.ps1 setup fs25

Le CLI :
- détecte le jeu
- route vers les bons scripts
- garantit une syntaxe cohérente
- simplifie l’usage pour l’utilisateur final

# 🔄 5. Flux opérationnel
5.1 Installation complète (setup)
setup → install → update → generate_service → start → healthcheck

5.2 Mise à jour
update → restart service → healthcheck

5.3 Backup
backup → compression → rotation → purge → Discord

5.4 Monitoring
monitor → check service → check port → restart on fail → Discord


# 🛡️ 6. Sécurité & bonnes pratiques
- utilisateurs dédiés par jeu
- pas de credentials en clair
- scripts idempotents
- services isolés
- ports configurables
- logs propres
- architecture modulaire

# 📦 7. Extensibilité
Le framework permet d’ajouter facilement :
- de nouveaux jeux
- de nouveaux modules
- des intégrations (Prometheus, Grafana, Loki, ELK)
- un orchestrateur (Docker, Kubernetes)
- un dashboard web

# 🧑‍💻 8. Objectif du projet
Ce framework est conçu pour :
- démontrer des compétences DevOps avancées
- fournir une architecture professionnelle
- automatiser des environnements multi‑serveurs
- servir de base à un portfolio technique solide

# 🎯 Conclusion
Cette architecture offre :
- une automatisation complète
- une modularité exemplaire
- une cohérence multi‑OS
- une documentation claire
- un framework DevOps prêt pour la production


