import customtkinter as ctk
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from collections import deque

class DashboardTab(ctk.CTkFrame):
    def __init__(self, parent, ecu_connection, max_points=50):
        super().__init__(parent)
        self.ecu = ecu_connection
        self.max_points = max_points

        # Historique des valeurs
        self.rpm_data = deque([0]*max_points, maxlen=max_points)
        self.speed_data = deque([0]*max_points, maxlen=max_points)
        self.boost_data = deque([0]*max_points, maxlen=max_points)

        # Status ECU
        self.status_label = ctk.CTkLabel(self, text="ECU: Disconnected", font=("Arial", 18))
        self.status_label.pack(pady=10)

        # Création figure matplotlib
        self.fig = Figure(figsize=(6, 3), dpi=100)
        self.ax_rpm = self.fig.add_subplot(311)
        self.ax_speed = self.fig.add_subplot(312)
        self.ax_boost = self.fig.add_subplot(313)

        # Initial plot
        self.line_rpm, = self.ax_rpm.plot(self.rpm_data, color="red")
        self.ax_rpm.set_title("RPM")
        self.line_speed, = self.ax_speed.plot(self.speed_data, color="blue")
        self.ax_speed.set_title("Speed (km/h)")
        self.line_boost, = self.ax_boost.plot(self.boost_data, color="green")
        self.ax_boost.set_title("Boost")

        # Canvas tkinter
        self.canvas = FigureCanvasTkAgg(self.fig, master=self)
        self.canvas.get_tk_widget().pack(fill="both", expand=True)

        # Lancer la mise à jour UI
        self.after(500, self.update_ui)

    def update_ui(self):
        if self.ecu.connected:
            self.status_label.configure(text="ECU: Connected")
            self.rpm_data.append(self.ecu.rpm)
            self.speed_data.append(self.ecu.speed)
            self.boost_data.append(self.ecu.boost)
        else:
            self.status_label.configure(text="ECU: Disconnected")
            self.rpm_data.append(0)
            self.speed_data.append(0)
            self.boost_data.append(0)

        # Mettre à jour plots
        self.line_rpm.set_ydata(self.rpm_data)
        self.line_speed.set_ydata(self.speed_data)
        self.line_boost.set_ydata(self.boost_data)

        # Ajuster l’axe Y automatiquement
        self.ax_rpm.relim()
        self.ax_rpm.autoscale_view()
        self.ax_speed.relim()
        self.ax_speed.autoscale_view()
        self.ax_boost.relim()
        self.ax_boost.autoscale_view()

        self.canvas.draw()
        self.after(500, self.update_ui)  # rappel toutes les 0.5s
