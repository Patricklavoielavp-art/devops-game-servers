import customtkinter as ctk
from tkinter import messagebox
from ui.i18n import tr

class TuningTab(ctk.CTkFrame):
    def __init__(self, parent, ecu_connection, log_callback=None):
        super().__init__(parent)
        self.ecu = ecu_connection
        self.log = log_callback if log_callback else print

        # --- Titre ---
        self.label = ctk.CTkLabel(self, text=tr("tuning_tools"), font=("Arial",24))
        self.label.pack(pady=20)

        # --- Paramètres de tuning ---
        params_frame = ctk.CTkFrame(self)
        params_frame.pack(padx=20, pady=10, fill="x")

        # --- RPM Max ---
        rpm_min = 5000
        rpm_max = 12000
        rpm_default = 6000

        self.rpm_label = ctk.CTkLabel(params_frame, text=f"{tr('max_rpm')} ({rpm_min}-{rpm_max} RPM)")
        self.rpm_label.grid(row=0, column=0, sticky="w", padx=5, pady=5)

        self.rpm_slider = ctk.CTkSlider(params_frame, from_=rpm_min, to=rpm_max)
        self.rpm_slider.set(rpm_default)
        self.rpm_slider.grid(row=0, column=1, padx=5, pady=5, sticky="ew")

        self.rpm_value_label = ctk.CTkLabel(params_frame, text=f"{rpm_default:.0f} RPM")
        self.rpm_value_label.grid(row=0, column=2, padx=5, pady=5)

        self.rpm_slider.configure(command=lambda val: self.rpm_value_label.configure(text=f"{float(val):.0f} RPM"))

        # --- Boost Max ---
        boost_min = 0
        boost_max = 100
        boost_default = 15

        self.boost_label = ctk.CTkLabel(params_frame, text=f"{tr('max_boost')} ({boost_min}-{boost_max} PSI)")
        self.boost_label.grid(row=1, column=0, sticky="w", padx=5, pady=5)

        self.boost_slider = ctk.CTkSlider(params_frame, from_=boost_min, to=boost_max)
        self.boost_slider.set(boost_default)
        self.boost_slider.grid(row=1, column=1, padx=5, pady=5, sticky="ew")

        self.boost_value_label = ctk.CTkLabel(params_frame, text=f"{boost_default:.1f} PSI")
        self.boost_value_label.grid(row=1, column=2, padx=5, pady=5)

        self.boost_slider.configure(command=lambda val: self.boost_value_label.configure(text=f"{float(val):.1f} PSI"))

        # Faire que les sliders s'étendent
        params_frame.grid_columnconfigure(1, weight=1)

        # --- Boutons d'action ---
        buttons_frame = ctk.CTkFrame(self)
        buttons_frame.pack(pady=20, fill="x", padx=20)

        self.btn_apply = ctk.CTkButton(buttons_frame, text=tr("apply_tuning"), command=self.apply_tuning)
        self.btn_apply.pack(side="left", padx=(0,10))

        self.btn_reset = ctk.CTkButton(buttons_frame, text=tr("reset_tuning"), command=self.reset_tuning)
        self.btn_reset.pack(side="left")

    # --- Appliquer le tuning ---
    def apply_tuning(self):
        if not self.ecu.connected:
            self.log(tr("ecu_not_connected"))
            return

        rpm = self.rpm_slider.get()
        boost = self.boost_slider.get()

        self.log(f"Applying tuning: max RPM={rpm:.0f}, max Boost={boost:.1f} PSI")
        messagebox.showinfo(tr("tuning_tools"), tr("tuning_applied"))

    # --- Réinitialiser sliders aux valeurs par défaut ---
    def reset_tuning(self):
        self.rpm_slider.set(6000)
        self.rpm_value_label.configure(text="6000 RPM")
        self.boost_slider.set(15)
        self.boost_value_label.configure(text="15.0 PSI")
        self.log("Tuning parameters reset to default")
