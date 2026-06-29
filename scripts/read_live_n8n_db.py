import sqlite3
import subprocess

subprocess.run(
    [
        "docker",
        "cp",
        "n8n:/home/node/.n8n/database.sqlite",
        r"C:\Users\hi\Documents\com.ragwatson\n8n\database-live.sqlite",
    ],
    check=True,
)
conn = sqlite3.connect(r"C:\Users\hi\Documents\com.ragwatson\n8n\database-live.sqlite")
row = conn.execute(
    "SELECT id, name, active, length(nodes), versionId, activeVersionId FROM workflow_entity"
).fetchone()
print("entity", row)
pub = conn.execute("SELECT * FROM workflow_published_version").fetchall()
print("published", pub)
hist = conn.execute(
    "SELECT versionId, name, length(nodes) FROM workflow_history"
).fetchall()
print("history", hist)
