#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: nixwarp <shell-type> <directory>"
  exit 1
fi

shell_type=$1
directory=$2

shell_file="$HOME/nix-shells/${shell_type}-shell.nix"

if [ ! -f "$shell_file" ]; then
  echo "Shell file not found: $shell_file"
  echo ""
  echo "Available shells in ~/nix-shells:"
  for f in "$HOME/nix-shells/"*-shell.nix; do
    [ -e "$f" ] || continue
    fname=$(basename "$f")
    echo "  - " $fname
  done
  exit 2
fi

nix-shell "$shell_file" --run "cd $directory && nu"
