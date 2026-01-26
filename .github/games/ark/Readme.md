## 📘 README — ARK :SURVIVAL Ascended (ARK ASA)
🦖 ARK: Survival Ascended — Serveur Dédié
Scripts automatisés pour installer, mettre à jour, sauvegarder et gérer un serveur ARK ASA via SteamCMD.

# 📂 Structure
ARK/
 ├── install_ark.sh
 ├── update_ark.sh
 ├── backup_ark.sh
 ├── monitor_ark.sh
 ├── service/
 │    └── ark.service
 └── config/
      └── ark.env



# ⚙️ Fonctionnalités
- Installation automatisée via SteamCMD
- Mise à jour silencieuse
- Sauvegardes compressées + rotation
- Monitoring du service
- Service systemd complet

# 🚀 Installation
sudo bash install_ark.sh



# 🔧 Commandes utiles
sudo systemctl start ark
sudo systemctl stop ark
sudo systemctl status ark
sudo systemctl restart ark



# 📦 Sauvegardes
Stockées dans :
/opt/ark/backups/


Rotation configurable dans backup_ark.sh.

# 🛠️ Dépendances
- Linux (Ubuntu recommandé)
- SteamCMD
- systemd
- bash
