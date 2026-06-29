import sqlite3
from pathlib import Path

db = Path(__file__).resolve().parents[1] / "n8n" / "database.sqlite"
conn = sqlite3.connect(db)
for table in ["workflow_entity", "workflow_published_version", "webhook_entity", "workflow_publish_history"]:
    try:
        rows = conn.execute(f"SELECT * FROM {table} LIMIT 5").fetchall()
        cols = [c[1] for c in conn.execute(f"PRAGMA table_info({table})")]
        print(table, "cols", cols)
        print(table, "rows", rows)
    except Exception as e:
        print(table, e)
