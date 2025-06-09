#!/usr/bin/env bash
set -euo pipefail

# Error codes: 1=usage, 2=directory, 3=shell OR the result of the nix shell

if [ "$#" -lt 2 ]; then
  echo "Usage: nixwarp <shell-type> <directory>"
  echo "  The shell must be present as ~/nix-shells/<shell-type>-shell.nix"
  echo "  Specifying a <shell-type> of . indicates that the shell in the directory must be used"
  exit 1
fi

shell_type=$1
directory=$2

# Directory
if command -v zoxide &> /dev/null; then
  if zoxide query "$directory" &> /dev/null; then
    directory="$(zoxide query "$directory")"
  fi
fi

# Ensure directory exists
if [ ! -d "$directory" ]; then
  echo "Directory not found: $directory"
  exit 2
fi

cd "$directory"

# If type == . then use the local shell
if [ "$shell_type" = "." ]; then
    nix-shell --run "nu"
    exit $?
fi

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
  lowest_distance=$(("${#shell_type}" + 5))

  tmp1=$(mktemp /tmp/str1.XXXXXX) || exit 1
  tmp2=$(mktemp /tmp/str2.XXXXXX) || exit 1
  trap 'rm -f "$tmp1" "$tmp2"' EXIT
  
  for shell in "${available_shells[@]}"; do
    # Simple Levenshtein-like distance calculation
    # This is a basic approximation - consider using a proper algorithm
    echo -n "$shell_type" | sed -e "s/./&\n/g" | grep -v "^$" | sort > "$tmp1"
    echo -n "$shell" | sed -e "s/./&\n/g" | grep -v "^$" | sort > "$tmp2"
    common=$(comm -12 "$tmp1" "$tmp2" | wc -l)
    total=$(($(cat $tmp1 | wc -l) + $(cat $tmp2 | wc -l)))
    current_distance=$((total - 2 * common))
    
    if [[ $current_distance -lt $lowest_distance ]]; then
      lowest_distance=$current_distance
      best_match=$shell
    fi
  done
  
  # Only suggest if we found a reasonably close match
  if [[ -n "$best_match" && $lowest_distance -lt ${#shell_type} ]]; then
    echo "\"$shell_type\" not found, would you like to use \"$best_match\" instead? (Y/n)"
    read -r -t 10 response
    response="${response:-Y}"
    if [[ "${response^^}" != "Y" ]]; then
      echo "Operation cancelled."
      exit 3
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
    exit 3
  fi
fi

nix-shell "$shell_file" --run "nu"
exit $?
