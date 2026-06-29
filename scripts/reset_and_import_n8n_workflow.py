"""Reset broken workflow and re-import Automata Gmail via n8n CLI."""

from __future__ import annotations

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WORKFLOW_ID = "Olwu79JfKywy4ALF"
IMPORT_FILE = ROOT / "n8n" / "workflows" / "automata-gmail-import-array.json"
VOLUME = "comragwatson_n8n_data"


def run(cmd: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    print("+", " ".join(cmd))
    return subprocess.run(cmd, check=check, cwd=ROOT, text=True, capture_output=True)


def main() -> None:
    run(["docker", "stop", "n8n"])

    sql = f"""
DELETE FROM webhook_entity WHERE workflowId = '{WORKFLOW_ID}';
DELETE FROM workflow_published_version WHERE workflowId = '{WORKFLOW_ID}';
DELETE FROM workflow_publish_history WHERE workflowId = '{WORKFLOW_ID}';
DELETE FROM workflow_history WHERE workflowId = '{WORKFLOW_ID}';
DELETE FROM shared_workflow WHERE workflowId = '{WORKFLOW_ID}';
DELETE FROM workflow_entity WHERE id = '{WORKFLOW_ID}';
"""
    run(
        [
            "docker",
            "run",
            "--rm",
            "-v",
            f"{VOLUME}:/data",
            "alpine",
            "sh",
            "-c",
            f"apk add --no-cache sqlite >/dev/null && sqlite3 /data/database.sqlite \"{sql}\"",
        ],
    )

    run(
        [
            "docker",
            "run",
            "--rm",
            "--entrypoint",
            "n8n",
            "-v",
            f"{VOLUME}:/home/node/.n8n",
            "-v",
            f"{IMPORT_FILE.as_posix()}:/tmp/import.json:ro",
            "n8nio/n8n",
            "import:workflow",
            "--input=/tmp/import.json",
        ],
    )

    listed = run(
        [
            "docker",
            "run",
            "--rm",
            "--entrypoint",
            "n8n",
            "-v",
            f"{VOLUME}:/home/node/.n8n",
            "n8nio/n8n",
            "list:workflow",
        ],
    )
    print(listed.stdout)

    new_id = ""
    for line in listed.stdout.strip().splitlines():
        if "Automata Gmail Send" in line:
            new_id = line.split("|")[0].strip()
            break

    if new_id:
        run(
            [
                "docker",
                "run",
                "--rm",
                "--entrypoint",
                "n8n",
                "-v",
                f"{VOLUME}:/home/node/.n8n",
                "n8nio/n8n",
                "publish:workflow",
                f"--id={new_id}",
            ],
        )
        print("Published workflow:", new_id)
    else:
        print("Import may have failed; check list:workflow output above.")

    run(["docker", "start", "n8n"])
    print("n8n restarted. Open http://localhost:5678 and connect Gmail credential on Gmail Send node.")


if __name__ == "__main__":
    main()
