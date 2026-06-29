import sqlite3
from pathlib import Path

db = Path(__file__).resolve().parents[1] / "n8n" / "database.sqlite"
conn = sqlite3.connect(db)
tables = [r[0] for r in conn.execute("SELECT name FROM sqlite_master WHERE type='table'")]
print("tables:", tables)
for t in tables:
    if "api" in t.lower() or "user" in t.lower():
        try:
            rows = conn.execute(f"SELECT * FROM {t} LIMIT 5").fetchall()
            print(t, rows)
        except Exception as e:
            print(t, e)
