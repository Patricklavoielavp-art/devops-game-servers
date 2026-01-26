# Palworld Dedicated Server - Linux Automation

Ce dépôt contient une solution complète , automatisée et documentée pour déployer , maintenir et administrer un serveur Palworld dédié sous Linux
l'objectif est de fournir une architecture reproductible , propre et facile à maintenir , basée sur SteamCMD , systemd et une série de script DevOps.

---

# Structure u dépôt 
Palworld-Server/ 
│ ├── Install/ 
│     ├── install.sh          # Installation complète du serveur 
│     ├── update.sh           # Mise à jour via SteamCMD │     
      ├── backup.sh           # Sauvegarde compressée du monde │     
      ├── status.sh           # État rapide du serveur │     
      ├── restart.sh          # Redémarrage propre │     
      ├── logs.sh             # Logs en temps réel │     
      ├── monitor.sh          # Monitoring CPU/RAM + processus 
│     ├── health-check.sh     # Détection de freeze + auto-restart 
│     ├── auto-update.sh      # Mise à jour automatique + restart 
│     └── reset-world.sh      # Réinitialisation complète du monde 
│ └── config/ 
      └── DefaultPalWorldSettings.ini
---
## Installation 

Sur Votre Machine Linux :

'''bash
cd Palworld-Server/Install
./install.sh
Ce script :
    - installe SteamCMD
    - télécharge le serveur PalWorld(AppID 2394010)
    - installe la configuration
    - crée le service systemd
    - démarre automatiquement le serveur ( qui seras installé dans /servers/palworld sur la machine Linux)

## Scripts disponibles 
    - install.sh        # Installe SteamCMD , télécharge le serveur , configure systemd et démarre le service
    - updateé.sh        # Met à jour le serveur via SteamCMD et redémarre automatiquement
    - backup.sh         # Crée une archive compressée du dossier Saved/ > /servers/palworld-backups/
    - monitor.sh        # Affiche
                         - état du service 
                         - processus PalServer
                         - utilisation CPU/RAM
                         - taille du monde
    - log.sh            # Affiche les logs en temps réel via systemd
    - restart.sh        # Arrête puis redémarre proprement le serveur
    - health-check.sh   # Vérifie
                          - si le service est actif
                          - si le processus PalServer existe
                        # Redémarre automatiquement en cas de crash
    - auto-update.sh    # Met à jour le serveur et le redémarre  automatiquement , Idéal pour un cron job
    - reset-world.sh    # Supprime complètement le monde PalWorld et force sa recréation 
                        - Action Destructive -- confirmation obligatoire
    
## Ports Réseau

Assurez-vous d'ouvrir les ports réseau suivants : 
|Port   | Protocole | Description                | 
|8211   |   UDP     | Port Principale du serveur | 
|27015  |   UDP     | Query Steam                | 
|27016  |   UDP     | Query secondaire           | 

## Structure du serveur installé

/servers/palworld/
│
├── PalServer.sh
├── Pal/
│   ├── Binaries/
│   ├── Content/
│   └── Saved/
│       └── Config/
│           └── LinuxServer/
│               └── DefaultPalWorldSettings.ini
└── Engine/

## Maintenance recommanée

Sauvegarde quotidienne
Ajouter dans crontab :
0 3 * * * /servers/palworld/backup.sh


Mise à jour automatique
0 */6 * * * /servers/palworld/auto-update.sh


Health-check toutes les 5 minutes
*/5 * * * * /servers/palworld/health-check.sh

## Troubleshooting

Le serveur ne démarre pas
- Vérifier les logs :
./logs.sh
- Vérifier les permissions :
chmod +x /servers/palworld/PalServer.sh
- Vérifier que SteamCMD est installé :
/servers/steamcmd/steamcmd.sh
Le monde ne charge plus
- Faire une sauvegarde
- Exécuter reset-world.sh
Le serveur freeze
- Lancer health-check.sh
- Vérifier la RAM disponible

📘 Licence
Libre d’utilisation, modification et redistribution.

👤 Auteur
Patrick — Architecture DevOps Linux pour serveurs dédiés de jeux.




