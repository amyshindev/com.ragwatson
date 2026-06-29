import json
import sqlite3
from pathlib import Path

db = Path(__file__).resolve().parents[1] / "n8n" / "database.sqlite"
conn = sqlite3.connect(db)
h = conn.execute(
    "SELECT versionId, name, nodes FROM workflow_history WHERE workflowId='Olwu79JfKywy4ALF'"
).fetchone()
e = conn.execute(
    "SELECT versionId, activeVersionId, name, active FROM workflow_entity WHERE id='Olwu79JfKywy4ALF'"
).fetchone()
p = conn.execute("SELECT * FROM workflow_published_version").fetchall()
print("history version", h[0], "name", h[1])
print("nodes", json.loads(h[2])[0].get("type"))
print("entity", e)
print("published", p)
