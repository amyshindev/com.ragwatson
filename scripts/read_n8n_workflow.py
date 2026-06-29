import json
import sqlite3
from pathlib import Path

db = Path(__file__).resolve().parents[1] / "n8n" / "database.sqlite"
conn = sqlite3.connect(db)
row = conn.execute(
    "SELECT nodes, connections FROM workflow_entity WHERE id='Olwu79JfKywy4ALF'"
).fetchone()
print(json.dumps(json.loads(row[0]), indent=2)[:2000])
print("connections", row[1])
