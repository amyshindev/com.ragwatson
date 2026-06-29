import sqlite3
from pathlib import Path

db = Path(__file__).resolve().parents[1] / "n8n" / "database.sqlite"
conn = sqlite3.connect(db)
for table in ["workflow_history", "workflow_published_version", "workflow_entity"]:
    cols = [c[1] for c in conn.execute(f"PRAGMA table_info({table})")]
    print(table, cols)
    rows = conn.execute(f"SELECT * FROM {table}").fetchall()
    print("count", len(rows))
    if rows:
        print("sample", rows[0][:5] if len(rows[0]) > 5 else rows[0])
