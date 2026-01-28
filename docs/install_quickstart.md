## 📘 Guide d’installation rapide
DevOps Game Server Framework — ARK • Palworld • FS25

# 🚀 1. Prérequis
Linux (ARK & Palworld)
- Ubuntu 22.04+ ou Debian 12+
- sudo installé
- Ports ouverts selon les jeux
- Connexion Internet stable
- 5–20 Go d’espace disque selon le jeu
Windows (FS25)
- Windows Server 2019 / 2022 ou Windows 10/11
- PowerShell 5.1+
- Droits administrateur
- Connexion Internet stable
- 5–20 Go d’espace disque

# 📦 2. Installation du framework
Linux
git clone https://github.com/tonrepo/devops-game-servers
cd devops-game-servers
chmod +x cli.sh


Windows
git clone https://github.com/tonrepo/devops-game-servers
cd devops-game-servers



⚙️ 3. Configuration
Édite le fichier :
config.yaml


Active les jeux que tu veux gérer :
gameservers:
  ark:
    enabled: true
  palworld:
    enabled: true
  fs25:
    enabled: true


Assure-toi que les chemins, ports et utilisateurs correspondent à ton environnement.

# 🦖 4. Installation d’un serveur ARK (Linux)
./cli.sh setup ark


Ce que fait la commande :
- installe SteamCMD
- installe ARK
- met à jour ARK
- génère le service systemd
- démarre le serveur
- vérifie le port
Service systemd :
systemctl status ark
systemctl restart ark



# 🐦‍🔥 5. Installation d’un serveur Palworld (Linux)
./cli.sh setup palworld


Ce que fait la commande :
- installe SteamCMD
- installe Palworld
- met à jour Palworld
- génère le service systemd
- démarre le serveur
- vérifie le port
Service systemd :
systemctl status palworld
systemctl restart palworld



# 🚜 6. Installation d’un serveur FS25 (Windows)
Depuis PowerShell en administrateur :
powershell.exe -ExecutionPolicy Bypass -File cli.ps1 setup fs25


Ce que fait la commande :
- installe SteamCMD
- installe FS25
- met à jour FS25
- installe NSSM
- crée le service Windows
- démarre le serveur
- vérifie le port
Service Windows :
Get-Service FS25
Restart-Service FS25



# 🔄 7. Commandes essentielles
Linux (ARK & Palworld)
|   Action          | ARK                  | PalWorld                   | 
| Installer         | ./cli.sh setup ark   | ./cli.sh setup palworld    | 
| Mettre à jour     | ./cli.sh update ark  | ./cli.sh update palworld   | 
| Sauvegarder       | ./cli.sh backup ark  | ./cli.sh backup palworld   |  
| Monitorer         | ./cli.sh monitor ark | ./cli.sh monitor palworld  | 
| Démarrer          | ./cli.sh start ark   | ./cli.sh start palworld    | 



Windows (FS25)
| Action            | Commande                   | 
| Installer         | cli.ps1 setup fs25         | 
| Mise à jour       | cli.ps1 update fs25        | 
| Sauvegarde        | cli.ps1 backup fs25        | 
| Monitorer         | cli.ps1 monitor fs25       | 
| Démarrer          | cli.ps1 start fs25         | 



# 🧪 8. Vérification rapide
Linux
systemctl status ark
systemctl status palworld
ss -tulpn | grep -E "7777|8211"


Windows
Get-Service FS25
Test-NetConnection -Port 10823 -ComputerName localhost



# 🎉 9. Serveurs prêts !
Tu peux maintenant :
- te connecter aux serveurs
- automatiser les backups
- activer le monitoring
- gérer tout via le CLI global
