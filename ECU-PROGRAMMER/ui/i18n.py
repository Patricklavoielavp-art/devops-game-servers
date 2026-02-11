LANG = "fr"

translations = {
    "fr": {
        "dashboard": "Tableau de bord",
        "can": "Moniteur CAN",
        "flash": "Programmation ECU",
        "logger": "Enregistreur",
        "language": "Langue",
        "ecu_tool": "OUTIL ECU",
        "rpm": "RPM",
        "speed": "Vitesse",
        "boost": "Boost",
        "connected": "ECU connecté",
        "ecu_programming": "Programmation ECU",
        "backup_ecu": "Sauvegarder ECU",
        "restore_ecu": "Restaurer ECU",
        "tuning_tools": "Outils de tuning",
        "not_connected": "ECU non connecté",
        "connect_ecu": "Connecter / Déconnecter ECU",
        "backup_completed": "Sauvegarde ECU terminée avec succès.",
        "restore_completed": "Restauration ECU terminée avec succès.",
        "tuning_tools": "Outils de Tuning",
        "max_rpm": "RPM Max",
        "max_boost": "Boost Max",
        "apply_tuning": "Appliquer le tuning",
        "reset_tuning": "Réinitialiser",
        "tuning_applied": "Tuning appliqué avec succès."
    },
    "en": {
        "dashboard": "Dashboard",
        "can": "CAN Monitor",
        "flash": "Flash ECU",
        "logger": "Datalogger",
        "language": "Language",
        "ecu_tool": "ECU TOOL",
        "rpm": "RPM",
        "speed": "Speed",
        "boost": "Boost",
        "connected": "ECU connected",
        "ecu_programming": "ECU Programming",
        "backup_ecu": "Backup ECU",
        "restore_ecu": "Restore ECU",
        "tuning_tools": "Tuning Tools",
        "not_connected": "ECU not connected",
        "connect_ecu": "Connect / Disconnect ECU",
        "backup_completed": "ECU backup completed successfully.",
        "restore_completed": "ECU restore completed successfully.",
        "tuning_tools": "Tuning Tools",
        "max_rpm": "Max RPM",
        "max_boost": "Max Boost",
        "apply_tuning": "Apply Tuning",
        "reset_tuning": "Reset",
        "tuning_applied": "Tuning applied successfully."
    },
}


def tr(key):
    return translations[LANG].get(key, key)


def set_lang(new_lang):
    global LANG
    LANG = new_lang