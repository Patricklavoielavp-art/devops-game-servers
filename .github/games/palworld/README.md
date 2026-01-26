## 📘 README — ARK :SURVIVAL Ascended (ARK ASA)
# 🐦 Palworld — Serveur Dédié
Scripts complets pour installer, mettre à jour, sauvegarder et gérer un serveur Palworld via SteamCMD.

# 📂 Structure
PALWORLD/
 ├── install_palworld.sh
 ├── update_palworld.sh
 ├── backup_palworld.sh
 ├── monitor_palworld.sh
 ├── service/
 │    └── palworld.service
 └── config/
      └── palworld.env



 # ⚙️ Fonctionnalités
- Installation automatisée via SteamCMD
- Mise à jour silencieuse
- Sauvegardes compressées + rotation
- Monitoring du service
- Service systemd complet

# 🚀 Installation
sudo bash install_palworld.sh



# 🔧 Commandes utiles
sudo systemctl start palworld
sudo systemctl stop palworld
sudo systemctl status palworld
sudo systemctl restart palworld



# 📦 Sauvegardes
Stockées dans :
/opt/palworld/backups/


Rotation configurable dans backup_palworld.sh.

# 🛠️ Dépendances
- Linux (Ubuntu recommandé)
- SteamCMD
- systemd
- bash





