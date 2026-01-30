README.md
# Farming Simulator 25 – Dedicated Server (Windows)

Setup professionnel d’un serveur dédié **Farming Simulator 25**
sur **Windows Server 2022**, avec :

- Steam (installation officielle)
- NSSM (service Windows)
- PowerShell 7
- Connexion joueur depuis un PC distant (même compte Steam)

---

## 🧱 Architecture



C:\devops-game-servers
│
├─ config.yaml
├─ setup_fs25.ps1
│
├─ fs25
│ └─ start_fs25.ps1
│
└─ logs
└─ fs25


---

## 🎮 Principe de fonctionnement

- FS25 est installé **via Steam**
- Le serveur est lancé avec `-server`
- NSSM gère le service Windows
- Le service tourne sous **le même user Windows que Steam**
- Le joueur se connecte depuis **un autre PC** avec le **même compte Steam**

---

## 🖥️ Prérequis

### Serveur
- Windows Server 2022
- Steam installé
- FS25 installé :


C:\Program Files (x86)\Steam\steamapps\common\Farming Simulator 25


### Client joueur
- PC personnel
- Steam
- Même compte Steam
- FS25 installé

---

## ⚙️ Configuration

### config.yaml (exemple)

```yaml
gameservers:
  fs25:
    service_name: "FS25"

🚀 Installation
1️⃣ Lancer le setup
powershell -ExecutionPolicy Bypass -File setup_fs25.ps1


Le script :

installe NSSM

crée le service

configure le firewall

démarre le serveur

🎮 Connexion joueur

Depuis le PC personnel :

Lancer FS25

Multijoueur

Connexion directe

Entrer l’IP du serveur

🔄 Mise à jour FS25

Stopper le service Windows

Lancer Steam sur le serveur

Mettre à jour FS25

Redémarrer le service

✅ Bonnes pratiques

✔ Un seul client Steam connecté
✔ Le serveur ne lance pas Steam UI
✔ Le service ne tourne PAS sous SYSTEM
✔ Logs persistants dans /logs/fs25

🔜 Roadmap possible

Backup auto des saves

Multi-instances FS25

Rotation des logs

Monitoring

Auteur : Patrick