import tkinter as tk
from tkinter import ttk
from datetime import datetime
from gauges import ProGauge

# ---------- Fenêtre ----------
root = tk.Tk()
root.title("Car Tuner ECU Dashboard")
root.configure(bg="#ffffff")
root.state('zoomed')

# ---------- Logs ----------
log_box = tk.Text(root, height=8, bg="#f0f0f0", fg="#000000")
log_box.pack(fill="x", padx=10, pady=5)
def log(msg):
    now = datetime.now().strftime("%H:%M:%S")
    log_box.insert(tk.END, f"[{now}] {msg}\n")
    log_box.see(tk.END)

# ---------- Connexion OBD ----------
try:
    import obd
    connection = obd.OBD()
    if not connection.is_connected():
        connection = None
        log("⚠️ Aucun ECU détecté. Les gauges afficheront 0 par défaut.")
except Exception as e:
    connection = None
    log(f"Erreur de connexion OBD: {e}")

# ---------- Onglets ----------
notebook = ttk.Notebook(root)
notebook.pack(fill="both", expand=True, padx=10, pady=5)
notebook_frames = {}
sectors = ["Moteur","Transmission","Echappement","Turbo","Autres"]
gauges = {}
for sector_name in sectors:
    frame = tk.Frame(notebook, bg="#ffffff")
    notebook.add(frame, text=sector_name)
    notebook_frames[sector_name] = frame
    gauges[sector_name] = {}

# ---------- Création de gauges de démonstration ----------
demo_list = [
    ("RPM", 8000, "Moteur"),
    ("Throttle %", 100, "Moteur"),
    ("Vehicle Speed km/h", 250, "Transmission"),
    ("Engine Load %", 100, "Moteur"),
    ("Coolant Temp °C", 120, "Moteur")
]

for name, max_val, sector in demo_list:
    row = len(gauges[sector]) // 3
    col = len(gauges[sector]) % 3
    g = ProGauge(notebook_frames[sector], size=200, max_value=max_val, label=name)
    g.grid(row=row, column=col, padx=20, pady=20)
    gauges[sector][name] = g

# ---------- Rafraîchissement ----------
def refresh():
    for sector, sensors in gauges.items():
        for name, gauge in sensors.items():
            try:
                value = 0
                if connection and connection.is_connected():
                    cmd_name = name.replace(" ","_").replace("%","PERCENT")
                    cmd = getattr(obd.commands, cmd_name, None)
                    if cmd:
                        val = connection.query(cmd)
                        value = val.value.magnitude if val.value else 0
                gauge.update_value(value)
            except Exception as e:
                log(f"Erreur {name}: {e}")
    root.after(1000, refresh)

refresh()
root.mainloop()

if connection:
    connection.close()
