## 1️⃣ Étape 1 – Ajouter l’instance dans config.yaml

Ouvre ton config.yaml.

Ajoute une nouvelle instance sous fs25.instances. Par exemple :

- name: "test"
  service_name: "FS25-Test"
  port: 10825
  session_name: "TestFarm"
  max_players: 8
  map: "Zielonka"
  mods:
    - "Mod_TestTractor"
    - "Mod_WeatherPlus"


## ⚠️ Règles importantes :

name = nom unique de l’instance → sert pour le dossier et le script.

service_name = nom du service Windows NSSM → unique aussi.

port = port UDP du serveur → ne pas dupliquer.

mods = liste de noms de dossier / mod présents dans le dossier Mods de l’instance.

## 2️⃣ Étape 2 – Créer le dossier de l’instance

Ton script setup_fs25.ps1 fait normalement ça automatiquement.
Mais si tu veux le créer manuellement avant :

C:\devops-game-servers\fs25\instances\test\
    ├─ Saved
    ├─ Mods
    ├─ logs
    └─ Backups


Copie tes fichiers de mods dans Mods.

Saved sera rempli automatiquement par le serveur.

logs et Backups seront gérés par le script.

## 3️⃣ Étape 3 – Installer ou mettre à jour les services

Après avoir ajouté l’instance au YAML :

Lancer setup_fs25.ps1.

Il va automatiquement :

Créer le service NSSM pour la nouvelle instance (FS25-Test).

Configurer le port dans le firewall.

Démarrer le service.

Tu peux vérifier avec PowerShell :

Get-Service | Where-Object Name -like "FS25*"

## 4️⃣ Étape 4 – Démarrer / arrêter l’instance

Démarrage automatique via NSSM.

Pour tester manuellement depuis PowerShell :

Start-Service FS25-Test
Stop-Service FS25-Test


Les logs se trouvent dans C:\devops-game-servers\fs25\instances\test\logs\fs25.log.

## 5️⃣ Étape 5 – Jouer sur l’instance

Chaque instance a son port UDP dédié.

Tu peux te connecter depuis le jeu avec le même compte Steam utilisé par le serveur.

Vanilla et Modded peuvent tourner simultanément sans conflit.