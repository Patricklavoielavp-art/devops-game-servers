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
        "not_connected": "ECU non connecté",
        "connect_ecu": "Connecter / Déconnecter ECU"
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
        "not_connected": "ECU not connected",
        "connect_ecu": "Connect / Disconnect ECU"
    },
}


def tr(key):
    return translations[LANG].get(key, key)


def set_lang(new_lang):
    global LANG
    LANG = new_lang