## Game Server VM Installer

Installs:
 -  SteamCMD
 -  ARK Survival Ascended
 -  Palworld Dedicated Server


## Requirements
-  Ubuntu 22.04 / 24.04
-  Root access
-  Nested virtualization enabled (VM)

## Install
```bash
git clone https://github.com/Patricklavoielavp-art/devops-game-servers/game-server-vm.git
cd game-server-vm
sudo chmod +x *.sh scripts/*.sh
sudo ./install.sh

