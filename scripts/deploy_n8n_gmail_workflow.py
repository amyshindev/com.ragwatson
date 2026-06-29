"""Deploy Automata Gmail workflow into local n8n SQLite (stop container first)."""

from __future__ import annotations

import json
import sqlite3
import subprocess
import uuid
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DB_CONTAINER = "n8n:/home/node/.n8n/database.sqlite"
DB_LOCAL = ROOT / "n8n" / "database.sqlite"
WORKFLOW_ID = "Olwu79JfKywy4ALF"

webhook_id = str(uuid.uuid4())
nodes = [
    {
        "parameters": {
            "httpMethod": "POST",
            "path": "automata",
            "responseMode": "responseNode",
            "options": {},
        },
        "id": str(uuid.uuid4()),
        "name": "Webhook",
        "type": "n8n-nodes-base.webhook",
        "typeVersion": 2,
        "position": [240, 300],
        "webhookId": webhook_id,
    },
    {
        "parameters": {
            "conditions": {
                "options": {
                    "caseSensitive": True,
                    "leftValue": "",
                    "typeValidation": "strict",
                },
                "conditions": [
                    {
                        "id": str(uuid.uuid4()),
                        "leftValue": "={{ $json.workflow }}",
                        "rightValue": "gmail-send",
                        "operator": {"type": "string", "operation": "equals"},
                    }
                ],
                "combinator": "and",
            },
            "options": {},
        },
        "id": str(uuid.uuid4()),
        "name": "IF gmail-send",
        "type": "n8n-nodes-base.if",
        "typeVersion": 2,
        "position": [480, 300],
    },
    {
        "parameters": {
            "sendTo": "={{ $json.to }}",
            "subject": "={{ $json.subject }}",
            "message": "={{ $json.body }}",
            "options": {},
        },
        "id": str(uuid.uuid4()),
        "name": "Gmail Send",
        "type": "n8n-nodes-base.gmail",
        "typeVersion": 2.1,
        "position": [720, 220],
    },
    {
        "parameters": {
            "respondWith": "json",
            "responseBody": '={{ { "ok": true, "messageId": $json.id } }}',
            "options": {},
        },
        "id": str(uuid.uuid4()),
        "name": "Respond OK",
        "type": "n8n-nodes-base.respondToWebhook",
        "typeVersion": 1.1,
        "position": [960, 220],
    },
    {
        "parameters": {
            "respondWith": "json",
            "responseBody": '={{ { "ok": false, "error": "unknown workflow" } }}',
            "options": {"responseCode": 400},
        },
        "id": str(uuid.uuid4()),
        "name": "Respond Skip",
        "type": "n8n-nodes-base.respondToWebhook",
        "typeVersion": 1.1,
        "position": [720, 400],
    },
]

connections = {
    "Webhook": {"main": [[{"node": "IF gmail-send", "type": "main", "index": 0}]]},
    "IF gmail-send": {
        "main": [
            [{"node": "Gmail Send", "type": "main", "index": 0}],
            [{"node": "Respond Skip", "type": "main", "index": 0}],
        ]
    },
    "Gmail Send": {"main": [[{"node": "Respond OK", "type": "main", "index": 0}]]},
}

settings = {"executionOrder": "v1"}
now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]


def main() -> None:
    subprocess.run(["docker", "stop", "n8n"], check=True, cwd=ROOT)
    subprocess.run(
        ["docker", "cp", DB_CONTAINER, str(DB_LOCAL)],
        check=True,
        cwd=ROOT,
    )

    conn = sqlite3.connect(DB_LOCAL)
    conn.execute(
        """
        UPDATE workflow_entity
        SET name = ?, active = 1, nodes = ?, connections = ?, settings = ?,
            updatedAt = ?, versionCounter = versionCounter + 1
        WHERE id = ?
        """,
        (
            "Automata Gmail Send",
            json.dumps(nodes),
            json.dumps(connections),
            json.dumps(settings),
            now,
            WORKFLOW_ID,
        ),
    )
    conn.commit()
    conn.close()

    subprocess.run(
        ["docker", "cp", str(DB_LOCAL), DB_CONTAINER],
        check=True,
        cwd=ROOT,
    )
    subprocess.run(
        [
            "docker",
            "run",
            "--rm",
            "-v",
            "comragwatson_n8n_data:/home/node/.n8n",
            "alpine",
            "chown",
            "-R",
            "1000:1000",
            "/home/node/.n8n",
        ],
        check=True,
        cwd=ROOT,
    )
    subprocess.run(["docker", "start", "n8n"], check=True, cwd=ROOT)
    print("Deployed Automata Gmail Send workflow and activated.")


if __name__ == "__main__":
    main()
