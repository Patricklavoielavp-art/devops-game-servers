import obd 
from threading import Thread
import time

class ECUConnection:

    def __init__(self):
        self.connection = None
        self.connected = False
        self.rpm = 0
        self.speed = 0
        self.boost = 0
        self.running = False

    def connect(self):
        try : 
            self.connection = obd.OBD() # auto-connect au port USB
            self.connected = self.connection.is_connected()
            if self.connected:
                self.running = True
                Thread(target=self.update_loop, daemon=True).start()
        except Exception as e:
            print(f"Erreur de connexion OBD: {e}")
            self.connected = False

    def update_loop(self):
        while self.running:
            try :
                rpm_resp = self.connection.query(obd.commands.RPM)
                speed_resp = self.connection.query(obd.commands.SPEED)
                boost_resp = self.connection.query(obd.commands.BOOST_PRESSURE)

                self.rpm = rpm_resp.value.magnitude if rpm_resp.value else 0
                self.speed = speed_resp.value.magnitude if speed_resp.value else 0
                self.boost = boost_resp.value.magnitude if boost_resp.value else 0
            except Exception as e:
                print(f"Erreur de lecture ECU: {e}")
            time.sleep(0.5) # update toutes les 500ms

    def disconnect(self):
        self.running = False
        if self.connection:
            self.connection.close()
        self.connected = False