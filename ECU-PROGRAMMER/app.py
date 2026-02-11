import customtkinter as ctk
from collections import deque
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from threading import Thread
import time

# --- Import des traductions depuis ui.i18n ---
from ui.i18n import tr, set_lang

# --- ECU Connection simulée pour test ---
class ECUConnection:
    def __init__(self):
        self.connected = False
        self.rpm = 0
        self.speed = 0
        self.boost = 0
        self.running = False

    def connect(self):
        self.connected = True
        self.running = True
        Thread(target=self.simulate_data, daemon=True).start()

    def disconnect(self):
        self.connected = False
        self.running = False
        self.rpm = 0
        self.speed = 0
        self.boost = 0

    def simulate_data(self):
        while self.running:
            if self.connected:
                self.rpm = (self.rpm + 100) % 8000
                self.speed = (self.speed + 5) % 200
                self.boost = (self.boost + 0.1) % 2
            time.sleep(0.5)

# --- Dashboard avec graphiques live ---
class DashboardTab(ctk.CTkFrame):
    def __init__(self, parent, ecu_connection, max_points=50):
        super().__init__(parent)
        self.ecu = ecu_connection
        self.max_points = max_points

        self.rpm_data = deque([0]*max_points, maxlen=max_points)
        self.speed_data = deque([0]*max_points, maxlen=max_points)
        self.boost_data = deque([0]*max_points, maxlen=max_points)

        # Status ECU dans le dashboard
        self.status_label = ctk.CTkLabel(self, text=tr("ecu_disconnected"), font=("Arial", 16))
        self.status_label.pack(pady=10)

        # Figure matplotlib
        self.fig = Figure(figsize=(6,3), dpi=100)
        self.ax_rpm = self.fig.add_subplot(311)
        self.ax_speed = self.fig.add_subplot(312)
        self.ax_boost = self.fig.add_subplot(313)

        self.line_rpm, = self.ax_rpm.plot(self.rpm_data, color="red")
        self.ax_rpm.set_title("RPM")
        self.line_speed, = self.ax_speed.plot(self.speed_data, color="blue")
        self.ax_speed.set_title("Speed (km/h)")
        self.line_boost, = self.ax_boost.plot(self.boost_data, color="green")
        self.ax_boost.set_title("Boost")

        self.canvas = FigureCanvasTkAgg(self.fig, master=self)
        self.canvas.get_tk_widget().pack(fill="both", expand=True)

        self.after(500, self.update_ui)

    def update_ui(self):
        if self.ecu.connected:
            self.status_label.configure(text=tr("ecu_connected"))
            self.rpm_data.append(self.ecu.rpm)
            self.speed_data.append(self.ecu.speed)
            self.boost_data.append(self.ecu.boost)
        else:
            self.status_label.configure(text=tr("ecu_disconnected"))
            self.rpm_data.append(0)
            self.speed_data.append(0)
            self.boost_data.append(0)

        self.line_rpm.set_ydata(self.rpm_data)
        self.line_speed.set_ydata(self.speed_data)
        self.line_boost.set_ydata(self.boost_data)

        self.ax_rpm.relim()
        self.ax_rpm.autoscale_view()
        self.ax_speed.relim()
        self.ax_speed.autoscale_view()
        self.ax_boost.relim()
        self.ax_boost.autoscale_view()

        self.canvas.draw()
        self.after(500, self.update_ui)

# --- Application principale ---
ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")

class ECUProgrammerApp(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("ECU Programmer")
        self.geometry("1200x700")

        self.grid_columnconfigure(1, weight=1)
        self.grid_rowconfigure(0, weight=1)

        # --- Sidebar ---
        self.sidebar = ctk.CTkFrame(self, width=200, corner_radius=0)
        self.sidebar.grid(row=0, column=0, sticky="ns")

        # Titre
        self.title_label = ctk.CTkLabel(self.sidebar, text=tr("ecu_tool"), font=("Arial", 20, "bold"))
        self.title_label.pack(pady=(20, 10))

        # ECU horizontal frame
        ecu_status_frame = ctk.CTkFrame(self.sidebar)
        ecu_status_frame.pack(pady=(5,20), padx=10, fill="x")

        # Petit rond de status
        self.status_frame = ctk.CTkFrame(ecu_status_frame, height=20, width=20, corner_radius=10)
        self.status_frame.pack(side="left", padx=(0,5))

        # Label texte
        self.status_label = ctk.CTkLabel(ecu_status_frame, text=tr("ecu_disconnected"), font=("Arial",12))
        self.status_label.pack(side="left", padx=(0,5))

        # Bouton Connect / Disconnect
        self.btn_ecu = ctk.CTkButton(ecu_status_frame, text=tr("connect_ecu"), command=self.toggle_ecu_connection)
        self.btn_ecu.pack(side="left")

        # Autres boutons
        self.btn_dashboard = ctk.CTkButton(self.sidebar, text=tr("dashboard"), command=self.show_dashboard)
        self.btn_dashboard.pack(pady=5, padx=10, fill="x")
        self.btn_can = ctk.CTkButton(self.sidebar, text=tr("can"), command=self.show_can)
        self.btn_can.pack(pady=5, padx=10, fill="x")
        self.btn_flash = ctk.CTkButton(self.sidebar, text=tr("flash"), command=self.show_flash)
        self.btn_flash.pack(pady=5, padx=10, fill="x")
        self.btn_logger = ctk.CTkButton(self.sidebar, text=tr("logger"), command=self.show_logger)
        self.btn_logger.pack(pady=5, padx=10, fill="x")

        # Language selector
        lang_label = ctk.CTkLabel(self.sidebar, text=tr("language"))
        lang_label.pack(pady=(40,5))
        lang_menu = ctk.CTkOptionMenu(self.sidebar, values=["fr","en"], command=self.change_language)
        lang_menu.pack()

        # --- Main area ---
        self.main_frame = ctk.CTkFrame(self)
        self.main_frame.grid(row=0, column=1, sticky="nsew")

        self.content = ctk.CTkFrame(self.main_frame)
        self.content.pack(fill="both", expand=True, padx=10, pady=10)

        # Log panel
        self.log_box = ctk.CTkTextbox(self.main_frame, height=120)
        self.log_box.pack(fill="x", padx=10, pady=10)
        self.log("ECU Programmer started")

        # ECU simulation
        self.ecu = ECUConnection()

        # Status loop
        self.update_ecu_status_color()
        self.start_ecu_status_loop()

        # Show dashboard
        self.show_dashboard()

    # --- Logging ---
    def log(self, message):
        self.log_box.insert("end", message + "\n")
        self.log_box.see("end")

    # --- Content management ---
    def clear_content(self):
        for widget in self.content.winfo_children():
            widget.destroy()

    # --- Tabs / Views ---
    def show_dashboard(self):
        self.clear_content()
        dash = DashboardTab(self.content, self.ecu)
        dash.pack(fill="both", expand=True)
        self.log("Dashboard loaded with live graphs")

    def show_can(self):
        self.clear_content()
        label = ctk.CTkLabel(self.content, text=tr("can"), font=("Arial",24))
        label.pack(pady=20)
        self.log("CAN monitor opened")

    def show_flash(self):
        self.clear_content()
        label = ctk.CTkLabel(self.content, text=tr("flash"), font=("Arial",24))
        label.pack(pady=20)
        self.log("Flash tool opened")

    def show_logger(self):
        self.clear_content()
        label = ctk.CTkLabel(self.content, text=tr("logger"), font=("Arial",24))
        label.pack(pady=20)
        self.log("Datalogger opened")

    # --- Language ---
    def change_language(self, lang):
        set_lang(lang)
        self.refresh_ui()

    def refresh_ui(self):
        self.title_label.configure(text=tr("ecu_tool"))
        self.btn_dashboard.configure(text=tr("dashboard"))
        self.btn_can.configure(text=tr("can"))
        self.btn_flash.configure(text=tr("flash"))
        self.btn_logger.configure(text=tr("logger"))
        self.btn_ecu.configure(text=tr("connect_ecu"))
        self.show_dashboard()

    # --- ECU control ---
    def toggle_ecu_connection(self):
        if self.ecu.connected:
            self.ecu.disconnect()
            self.log(tr("ecu_disconnected"))
        else:
            self.ecu.connect()
            self.log(tr("ecu_connected") if self.ecu.connected else tr("ecu_connection_failed"))
        self.update_ecu_status_color()

    def update_ecu_status_color(self):
        color = "green" if self.ecu.connected else "red"
        self.status_frame.configure(fg_color=color)
        self.status_label.configure(text=tr("ecu_connected") if self.ecu.connected else tr("ecu_disconnected"))

    def start_ecu_status_loop(self):
        self.update_ecu_status_color()
        self.after(500, self.start_ecu_status_loop)

# --- Lancer l'app ---
if __name__ == "__main__":
    app = ECUProgrammerApp()
    app.mainloop()
