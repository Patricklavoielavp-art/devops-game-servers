import can

def sniff_can(interface='can0', channel='can0', bustype='socketcan'):
    bus = can.interface.Bus(channel=channel, bustype=bustype)
    print("Sniffing CAN bus...")
    for msg in bus:
        print(msg)

if __name__ == "__main__":
    sniff_can()
