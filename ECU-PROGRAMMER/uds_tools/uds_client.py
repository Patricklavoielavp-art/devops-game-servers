from udsoncan.client import Client
from udsoncan.connections import PythonIsoTpConnection

def read_uds_example(conn):
    client = Client(conn)
    with client:
        try:
            val = client.read_data_by_identifier(0xF190)  # VIN example
            print("VIN:", val.value)
        except Exception as e:
            print("Erreur UDS:", e)
