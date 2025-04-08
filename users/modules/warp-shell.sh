#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: nixwarp <shell-type> <directory>"
  exit 1
fi

shell_type=$1
directory=$2

# Get available shells
available_shells=()
for f in "$HOME/nix-shells/"*-shell.nix; do
  [ -e "$f" ] || continue
  fname=$(basename "$f")
  available_shells+=("${fname%-shell.nix}")
done

# Shell file
shell_file="$HOME/nix-shells/${shell_type}-shell.nix"
if [ ! -f "$shell_file" ]; then
  # Find closest match
  best_match=""
  lowest_distance=100  # Some high number
  
  for shell in "${available_shells[@]}"; do
    # Simple Levenshtein-like distance calculation
    # This is a basic approximation - consider using a proper algorithm
    distance=$(echo -n "$shell_type" | sed -e "s/./&\n/g" | grep -v "^$" | sort > /tmp/str1)
    echo -n "$shell" | sed -e "s/./&\n/g" | grep -v "^$" | sort > /tmp/str2
    common=$(comm -12 /tmp/str1 /tmp/str2 | wc -l)
    total=$(($(cat /tmp/str1 | wc -l) + $(cat /tmp/str2 | wc -l)))
    current_distance=$((total - 2 * common))
    
    if [[ $current_distance -lt $lowest_distance ]]; then
      lowest_distance=$current_distance
      best_match=$shell
    fi
  done
  
  # Only suggest if we found a reasonably close match
  if [[ -n "$best_match" && $lowest_distance -lt ${#shell_type} ]]; then
    echo "\"$shell_type\" not found, would you like to use \"$best_match\" instead? (Y/n)"
    read -r response
    if [[ "$response" =~ ^[Nn]$ ]]; then
      echo "Operation cancelled."
      exit 2
    fi
    shell_type=$best_match
    shell_file="$HOME/nix-shells/${shell_type}-shell.nix"
  else
    echo "Shell file not found: $shell_file"
    echo ""
    echo "Available shells in ~/nix-shells:"
    for shell in "${available_shells[@]}"; do
      echo "  - $shell"
    done
    exit 2
  fi
fi

# Directory
if command -v zoxide &> /dev/null; then
  if zoxide query "$directory" &> /dev/null; then
    directory="$(zoxide query "$directory")"
  fi
fi

# Ensure directory exists
if [ ! -d "$directory" ]; then
  echo "Directory not found: $directory"
  exit 3
fi

nix-shell "$shell_file" --run "cd \"$directory\" && nu"
