"""Restore Obsidian graph groups: frontend (green) vs backend (blue)."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

COLOR_GROUPS = [
    {"query": "path:frontend", "color": {"a": 1, "rgb": 5873999}},
    {"query": "path:backend", "color": {"a": 1, "rgb": 5142951}},
]

GRAPH_OPTIONS = {
    "collapse-filter": False,
    "search": "",
    "showTags": False,
    "showAttachments": False,
    "hideUnresolved": True,
    "showOrphans": False,
    "collapse-color-groups": False,
    "colorGroups": COLOR_GROUPS,
    "collapse-display": True,
    "showArrow": False,
    "textFadeMultiplier": 0,
    "nodeSizeMultiplier": 1,
    "lineSizeMultiplier": 1,
    "collapse-forces": True,
    "centerStrength": 0.518713248970312,
    "repelStrength": 10,
    "linkStrength": 1,
    "linkDistance": 250,
    "close": False,
}


def patch_graph_leaves(data: dict) -> None:
    def walk(obj: object) -> None:
        if isinstance(obj, dict):
            if obj.get("type") in ("graph", "localgraph") and "state" in obj:
                state = obj["state"]
                if obj["type"] == "localgraph" and isinstance(state, dict) and "options" in state:
                    state["options"].update(GRAPH_OPTIONS)
                elif obj["type"] == "graph" and isinstance(state, dict):
                    state.update(GRAPH_OPTIONS)
                    state["colorGroups"] = COLOR_GROUPS
                    state["collapse-color-groups"] = False
            for value in obj.values():
                walk(value)
        elif isinstance(obj, list):
            for item in obj:
                walk(item)

    walk(data)


def main() -> None:
    (ROOT / ".obsidian" / "harness-graph-color-groups.json").write_text(
        json.dumps(COLOR_GROUPS, indent=2) + "\n",
        encoding="utf-8",
    )

    graph_path = ROOT / ".obsidian" / "graph.json"
    data = json.loads(graph_path.read_text(encoding="utf-8")) if graph_path.exists() else {}
    data.update(GRAPH_OPTIONS)
    data["colorGroups"] = COLOR_GROUPS
    graph_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("updated .obsidian/graph.json")

    ws_path = ROOT / ".obsidian" / "workspace.json"
    if ws_path.exists():
        ws_data = json.loads(ws_path.read_text(encoding="utf-8"))
        patch_graph_leaves(ws_data)
        ws_path.write_text(json.dumps(ws_data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        print("updated .obsidian/workspace.json")


if __name__ == "__main__":
    main()
