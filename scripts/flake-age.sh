#!/usr/bin/env bash
set -euo pipefail

lock_file="${1:-flake.lock}"
if [[ ! -f "$lock_file" ]]; then
  echo "flake-age: no $lock_file found"
  exit 0
fi

python3 - "$lock_file" <<'PY'
import json
import sys
from datetime import datetime, timezone

lock_path = sys.argv[1]
with open(lock_path, "r", encoding="utf-8") as handle:
    data = json.load(handle)

nodes = data.get("nodes", {})
now = datetime.now(timezone.utc)

tracked = [
    ("nixpkgs", "nixpkgs stable"),
    ("nixpkgs-unstable", "nixpkgs unstable"),
    ("home-manager", "home-manager"),
    ("flake-parts", "flake-parts"),
]

rows = []
for key, label in tracked:
    node = nodes.get(key, {})
    locked = node.get("locked", {})
    last_modified = locked.get("lastModified")
    rev = locked.get("rev", "?")
    if not isinstance(last_modified, int):
        continue

    then = datetime.fromtimestamp(last_modified, tz=timezone.utc)
    days = (now - then).days
    rows.append((label, days, rev[:12]))

if not rows:
    print("flake-age: no lock timestamps found")
    sys.exit(0)

print("flake-age summary:")
for label, days, rev in rows:
    print(f"  - {label:17} {days:4d} days old  ({rev})")

oldest = max(rows, key=lambda item: item[1])
print(f"oldest pinned input: {oldest[0]} ({oldest[1]} days)")
PY
