import tkinter as tk
import math

class ProGauge(tk.Canvas):
    def __init__(self, master, size=200, max_value=100, label="Gauge", unit="", **kwargs):
        canvas_height = size//1.2 + 60
        super().__init__(master, width=size, height=canvas_height, bg="#ffffff", highlightthickness=0, **kwargs)
        
        self.size = size
        self.radius = size//2 - 20
        self.max_value = max_value
        self.label = label
        self.unit = unit

        self.offset_y = 40
        self.center_x = self.size / 2
        self.center_y = self.offset_y + self.radius

        self.create_text(self.center_x, 20, text=label, fill="black", font=("Consolas", 14, "bold"), tag="label")
        self.value_text = self.create_text(self.center_x, self.center_y + self.radius/2, text="0", fill="blue", font=("Consolas", 16, "bold"))
        self.bg_arc = self.create_arc(
            self.center_x - self.radius, self.center_y - self.radius,
            self.center_x + self.radius, self.center_y + self.radius,
            start=0, extent=180, style="arc", outline="#aaa", width=20
        )
        self.fg_arc = self.create_arc(
            self.center_x - self.radius, self.center_y - self.radius,
            self.center_x + self.radius, self.center_y + self.radius,
            start=0, extent=0, style="arc", outline="green", width=20
        )
        self.needle = self.create_line(self.center_x, self.center_y, self.center_x, self.center_y, width=3, fill="red")

    def update_value(self, value):
        if value is None:
            value = 0
        value = min(max(value, 0), self.max_value)
        self.itemconfig(self.value_text, text=f"{int(value)} {self.unit}")
        extent = (value / self.max_value) * 180
        color = self._value_to_color(value / self.max_value)
        self.itemconfig(self.fg_arc, extent=extent, outline=color)
        angle_deg = (value / self.max_value) * 180
        angle_rad = math.radians(angle_deg)
        x = self.center_x + self.radius * math.cos(angle_rad)
        y = self.center_y - self.radius * math.sin(angle_rad)
        self.coords(self.needle, self.center_x, self.center_y, x, y)

    def _value_to_color(self, pct):
        if pct < 0.5:
            r = int(0 + (255-0)*(pct/0.5))
            g = 255
        else:
            r = 255
            g = int(255 - (255*(pct-0.5)/0.5))
        b = 0
        return f"#{r:02x}{g:02x}{b:02x}"
