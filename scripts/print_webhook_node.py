import json
import sqlite3

conn = sqlite3.connect(r"C:\Users\hi\Documents\com.ragwatson\n8n\database-live.sqlite")
nodes = json.loads(conn.execute("SELECT nodes FROM workflow_history").fetchone()[0])
print(json.dumps(nodes[0], indent=2))
