import sqlite3

conn = sqlite3.connect(r"C:\Users\hi\Documents\com.ragwatson\n8n\database-live.sqlite")
cols = [c[1] for c in conn.execute("PRAGMA table_info(user_api_keys)")]
print(cols)
