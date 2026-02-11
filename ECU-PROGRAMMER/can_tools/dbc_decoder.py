import cantools

def decode_can(msg, dbc_file):
    db = cantools.database.load_file(dbc_file)
    decoded = db.decode_message(msg.arbitration_id, msg.data)
    return decoded
