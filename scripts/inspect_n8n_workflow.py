import json
import sqlite3
import uuid
from pathlib import Path

db = Path(__file__).resolve().parents[1] / "n8n" / "database.sqlite"
conn = sqlite3.connect(db)
cols = conn.execute("PRAGMA table_info(workflow_entity)").fetchall()
print("workflow_entity columns:", [c[1] for c in cols])
row = conn.execute(
    "SELECT id, name, active, nodes, connections FROM workflow_entity LIMIT 3"
).fetchall()
for r in row:
    print("id", r[0], "name", r[1], "active", r[2], "nodes_len", len(r[3] or ""))
