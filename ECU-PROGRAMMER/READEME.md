# CarTuner - ECU Dashboard & CAN/UDS Tools

Projet Python pour monitorer et explorer les capteurs d'une voiture via OBD-II / CAN / UDS.

## Structure

- `dashboard/` : Interface graphique et gauges
- `can_tools/` : Lecture et décodage des messages CAN
- `uds_tools/` : Communication UDS / Diagnostic ECU
- `examples/` : Scripts d'exemple

## Installation

pip install -r requirements.txt

## Usage  
Lancer le dashboard principal :

python dashboard/ecu_reader.py


---

# 4️⃣ `dashboard/__init__.py`

```python
# dashboard package