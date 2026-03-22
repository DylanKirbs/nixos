#!/usr/bin/env bash

set -euo pipefail

setup="${1:-home}"

sudo nix run nixpkgs/nixos-25.05#nixos-rebuild -- switch --flake ".#${setup}"