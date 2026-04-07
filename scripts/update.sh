#!/usr/bin/env bash

set -euo pipefail

setup="${1:-home}"

sudo nix run nixpkgs/nixos-25.11#nixos-rebuild -- switch --flake ".#${setup}"