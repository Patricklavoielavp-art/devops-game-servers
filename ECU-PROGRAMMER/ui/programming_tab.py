import customtkinter as ctk
from tkinter import filedialog
from threading import Thread
import time
from ui.i18n import tr
from ui.tuning_tab import TuningTab  # importer la classe TuningTab

class ProgrammingTab(ctk.CTkFrame):
    def __init__(self, parent, ecu_connection, log_callback=None):
        super().__init__(parent)
        self.ecu = ecu_connection
        self.log = log_callback if log_callback else print

        # --- Titre ---
        self.label = ctk.CTkLabel(self, text=tr("ecu_programming"), font=("Arial",24))
        self.label.pack(pady=20)

        # --- Frame principale pour la ligne de boutons ---
        self.button_frame = ctk.CTkFrame(self)
        self.button_frame.pack(fill="x", padx=10, pady=10)

        # Backup / Restore à gauche
        left_buttons_frame = ctk.CTkFrame(self.button_frame)
        left_buttons_frame.pack(side="left")

        self.btn_backup = ctk.CTkButton(left_buttons_frame, text=tr("backup_ecu"), command=self.backup_ecu)
        self.btn_backup.pack(side="left", padx=(0,10))

        self.btn_restore = ctk.CTkButton(left_buttons_frame, text=tr("restore_ecu"), command=self.restore_ecu)
        self.btn_restore.pack(side="left")

        # Tuning à droite
        self.btn_tuning = ctk.CTkButton(self.button_frame, text=tr("tuning_tools"), command=self.show_tuning_tools)
        self.btn_tuning.pack(side="right")

        # --- Barre de progression invisible au départ ---
        self.progress = ctk.CTkProgressBar(self)
        self.progress.set(0)
        self.progress.pack(fill="x", padx=10, pady=(20,0))
        self.progress.pack_forget()

        # --- Zone pour le contenu dynamique (TuningTab s'affichera ici) ---
        self.tuning_frame = None  # initialement vide

    # --- Afficher les outils de tuning dans le même onglet ---
    def show_tuning_tools(self):
        # Supprimer l'ancien frame si existant
        if self.tuning_frame:
            self.tuning_frame.destroy()

        # Créer le TuningTab
        self.tuning_frame = TuningTab(self, self.ecu, log_callback=self.log)
        self.tuning_frame.pack(fill="both", expand=True, padx=10, pady=10)

    # --- Backup / Restore (identique à la version précédente) ---
    def set_buttons_state(self, state):
        self.btn_backup.configure(state=state)
        self.btn_restore.configure(state=state)
        self.btn_tuning.configure(state=state)

    def backup_ecu(self):
        if not self.ecu.connected:
            self.log(tr("ecu_not_connected"))
            return
        filepath = filedialog.asksaveasfilename(defaultextension=".bin", filetypes=[("Binary files","*.bin")])
        if filepath:
            Thread(target=self._simulate_operation, args=(filepath, "backup"), daemon=True).start()

    def restore_ecu(self):
        if not self.ecu.connected:
            self.log(tr("ecu_not_connected"))
            return
        filepath = filedialog.askopenfilename(filetypes=[("Binary files","*.bin")])
        if filepath:
            Thread(target=self._simulate_operation, args=(filepath, "restore"), daemon=True).start()

    def _simulate_operation(self, filepath, operation):
        self.set_buttons_state("disabled")
        self.progress.pack(fill="x", padx=10, pady=(20,0))
        self.progress.set(0)
        color = "blue" if operation=="backup" else "green"
        self.progress.configure(progress_color=color)
        if operation=="backup":
            self.log(f"Starting ECU backup to {filepath}...")
        else:
            self.log(f"Starting ECU restore from {filepath}...")
        for i in range(101):
            self.progress.set(i/100)
            self.update_idletasks()
            time.sleep(0.02)
        if operation=="backup":
            with open(filepath,"wb") as f:
                f.write(b"FAKE_ECU_BACKUP")
            self.log(f"Backup completed: {filepath}")
            ctk.CTkMessagebox(title=tr("backup_ecu"), message=tr("backup_completed"))
        else:
            with open(filepath,"rb") as f:
                data = f.read()
                self.log(f"Restored {len(data)} bytes to ECU")
            ctk.CTkMessagebox(title=tr("restore_ecu"), message=tr("restore_completed"))
        self.set_buttons_state("normal")
        self.progress.pack_forget()
