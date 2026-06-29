import json
import sqlite3
import uuid
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DB_LOCAL = ROOT / "n8n" / "database.sqlite"
WORKFLOW_ID = "Olwu79JfKywy4ALF"

# Load nodes from deploy script logic - read from workflow_entity
conn = sqlite3.connect(DB_LOCAL)
row = conn.execute(
    "SELECT nodes, connections, name, settings FROM workflow_entity WHERE id=?",
    (WORKFLOW_ID,),
).fetchone()
nodes, connections, name, settings = row
new_version_id = str(uuid.uuid4())
now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]

conn.execute(
    """
    UPDATE workflow_history
    SET nodes = ?, connections = ?, name = ?, updatedAt = ?, versionId = ?
    WHERE workflowId = ?
    """,
    (nodes, connections, name, now, new_version_id, WORKFLOW_ID),
)

conn.execute(
    """
    UPDATE workflow_entity
    SET versionId = ?, activeVersionId = ?, updatedAt = ?
    WHERE id = ?
    """,
    (new_version_id, new_version_id, now, WORKFLOW_ID),
)

conn.execute("DELETE FROM workflow_published_version WHERE workflowId = ?", (WORKFLOW_ID,))
conn.execute(
    """
    INSERT INTO workflow_published_version (workflowId, publishedVersionId, createdAt, updatedAt)
    VALUES (?, ?, ?, ?)
    """,
    (WORKFLOW_ID, new_version_id, now, now),
)

conn.commit()
conn.close()
print("Synced workflow_history + published version:", new_version_id)
