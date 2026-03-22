#!/usr/bin/env bash
set -euo pipefail

config_name="home"
left_config=""
right_config=""
left_ref=""
right_ref=""

usage() {
  cat <<'USAGE'
Usage: scripts/diff-config-commits.sh [options]

Compare a NixOS configuration between two revisions and show a unified diff.

Options:
  --config NAME      NixOS configuration name in flake outputs (default: home)
  --left-config NAME Left-side NixOS configuration name
  --right-config NAME Right-side NixOS configuration name
  --left REV         Left git revision (e.g. HEAD~1, main, <commit>)
  --right REV        Right git revision
  -h, --help         Show this help

Default revision selection:
  - clean tree:       left=HEAD~1, right=HEAD
  - dirty tree:       left=HEAD,   right=WORKTREE

Notes:
  - WORKTREE means your current checked-out files (including unstaged changes).
  - Uses --impure to allow absolute-path imports such as /etc/nixos/hardware-configuration.nix.

Examples:
  scripts/diff-config-commits.sh
  scripts/diff-config-commits.sh --left HEAD --right HEAD --left-config home --right-config lab
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config)
      config_name="${2:-}"
      shift 2
      ;;
    --left-config)
      left_config="${2:-}"
      shift 2
      ;;
    --right-config)
      right_config="${2:-}"
      shift 2
      ;;
    --left)
      left_ref="${2:-}"
      shift 2
      ;;
    --right)
      right_ref="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$left_ref" && -z "$right_ref" ]]; then
  if git diff --quiet -- .; then
    left_ref="HEAD~1"
    right_ref="HEAD"
  else
    left_ref="HEAD"
    right_ref="WORKTREE"
  fi
elif [[ -z "$left_ref" || -z "$right_ref" ]]; then
  echo "Both --left and --right must be provided together." >&2
  exit 2
fi

if [[ -z "$left_config" ]]; then
  left_config="$config_name"
fi
if [[ -z "$right_config" ]]; then
  right_config="$config_name"
fi

if [[ "$left_ref" != "WORKTREE" ]]; then
  git rev-parse --verify "$left_ref^{commit}" >/dev/null
fi
if [[ "$right_ref" != "WORKTREE" ]]; then
  git rev-parse --verify "$right_ref^{commit}" >/dev/null
fi

if [[ "$left_ref" == "HEAD~1" ]]; then
  git rev-parse --verify "HEAD~1^{commit}" >/dev/null
fi

tmp_root="$(mktemp -d)"
cleanup() {
  if [[ -n "${left_wt:-}" ]] && [[ -d "${left_wt:-}" ]]; then
    git worktree remove --force "$left_wt" >/dev/null 2>&1 || true
  fi
  if [[ -n "${right_wt:-}" ]] && [[ -d "${right_wt:-}" ]]; then
    git worktree remove --force "$right_wt" >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_root"
}
trap cleanup EXIT

resolve_flake_path() {
  local ref="$1"
  if [[ "$ref" == "WORKTREE" ]]; then
    printf '%s\n' "$PWD"
  else
    local dir
    dir="$(mktemp -d "$tmp_root/wt.XXXXXX")"
    git worktree add --detach "$dir" "$ref" >/dev/null
    if [[ -z "${left_wt:-}" ]]; then
      left_wt="$dir"
    else
      right_wt="$dir"
    fi
    printf '%s\n' "$dir"
  fi
}

nix_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '%s' "$s"
}

dump_config() {
  local flake_dir="$1"
  local ref_label="$2"
  local cfg_name="$3"
  local out_file="$4"

  local escaped_dir escaped_cfg expr_base drv_expr pkgs_expr users_expr drv_path pkg_json users_json
  escaped_dir="$(nix_escape "$flake_dir")"
  escaped_cfg="$(nix_escape "$cfg_name")"

  expr_base="let f = builtins.getFlake \"path:${escaped_dir}\"; c = (builtins.getAttr \"${escaped_cfg}\" f.nixosConfigurations).config;"
  drv_expr="${expr_base} in c.system.build.toplevel.drvPath"
  pkgs_expr="${expr_base} in let names = builtins.map (p: p.name or p.pname or \"unknown\") c.environment.systemPackages; unique = builtins.attrNames (builtins.listToAttrs (builtins.map (n: { name = n; value = true; }) names)); in unique"
  users_expr="${expr_base} in
    let
      sysUsers = c.users.users or {};
      hmUsers = c.home-manager.users or {};
      toPkgNames = pkgList:
        let
          names = builtins.map (p: p.name or p.pname or \"unknown\") pkgList;
        in
          builtins.attrNames (builtins.listToAttrs (builtins.map (n: { name = n; value = true; }) names));
      toShellName = shell:
        if shell == null then
          null
        else if builtins.isAttrs shell && shell ? name then
          shell.name
        else if builtins.isAttrs shell && shell ? pname then
          shell.pname
        else
          toString shell;
      summarizeSystemUser = userCfg: {
        isNormalUser = userCfg.isNormalUser or false;
        home = userCfg.home or null;
        shell = toShellName (userCfg.shell or null);
        extraGroups = userCfg.extraGroups or [];
      };
      summarizeHmUser = userCfg: {
        homeUsername = userCfg.home.username or null;
        homeDirectory = userCfg.home.homeDirectory or null;
        packages = toPkgNames (userCfg.home.packages or []);
        programs = {
          git = userCfg.programs.git.enable or false;
          neovim = userCfg.programs.neovim.enable or false;
          nushell = userCfg.programs.nushell.enable or false;
          kitty = userCfg.programs.kitty.enable or false;
          vscode = userCfg.programs.vscode.enable or false;
          gnomeShell = userCfg.programs.gnome-shell.enable or false;
        };
      };
    in
    {
      systemUsers = builtins.listToAttrs (
        builtins.map (
          name: {
            inherit name;
            value = summarizeSystemUser sysUsers.\${name};
          }
        ) (builtins.attrNames sysUsers)
      );
      homeManagerUsers = builtins.listToAttrs (
        builtins.map (
          name: {
            inherit name;
            value = summarizeHmUser hmUsers.\${name};
          }
        ) (builtins.attrNames hmUsers)
      );
    }"

  echo "Evaluating flake at '$ref_label' for config '$cfg_name'. This may take a moment..."
  drv_path="$(nix eval --impure --raw --expr "$drv_expr")"
  pkg_json="$(nix eval --impure --json --expr "$pkgs_expr")"
  users_json="$(nix eval --impure --json --expr "$users_expr")"

  {
    echo "ref: $ref_label"
    echo "config: $cfg_name"
    echo "drvPath: $drv_path"
    echo "packages:"
    python3 -c 'import json,sys; [print(f"  - {x}") for x in json.loads(sys.stdin.read())]' <<<"$pkg_json"
    echo "systemUsers:"
    USERS_JSON="$users_json" python3 - <<'PY'
import json
import os

data = json.loads(os.environ["USERS_JSON"])
for name in sorted(data.get("systemUsers", {}).keys()):
    user = data["systemUsers"][name]
    print(f"  - {name}")
    print(f"    isNormalUser: {user.get('isNormalUser', False)}")
    print(f"    home: {user.get('home')}")
    print(f"    shell: {user.get('shell')}")
    groups = user.get("extraGroups", [])
    print("    extraGroups:")
    for group in groups:
        print(f"      - {group}")
PY
    echo "homeManagerUsers:"
    USERS_JSON="$users_json" python3 - <<'PY'
import json
import os

data = json.loads(os.environ["USERS_JSON"])
for name in sorted(data.get("homeManagerUsers", {}).keys()):
    user = data["homeManagerUsers"][name]
    print(f"  - {name}")
    print(f"    homeUsername: {user.get('homeUsername')}")
    print(f"    homeDirectory: {user.get('homeDirectory')}")
    print("    programs:")
    for program in sorted(user.get("programs", {}).keys()):
        print(f"      {program}: {user['programs'][program]}")
    print("    packages:")
    for package in user.get("packages", []):
        print(f"      - {package}")
PY
  } > "$out_file"
}

left_flake="$(resolve_flake_path "$left_ref")"
right_flake="$(resolve_flake_path "$right_ref")"

left_dump="$tmp_root/left.txt"
right_dump="$tmp_root/right.txt"

dump_config "$left_flake" "$left_ref" "$left_config" "$left_dump"
dump_config "$right_flake" "$right_ref" "$right_config" "$right_dump"

echo "Comparing: ${left_ref}:${left_config} -> ${right_ref}:${right_config}"
echo ""
if diff -u "$left_dump" "$right_dump"; then
  echo ""
  echo "No differences."
else
  echo ""
  echo "Differences found."
fi
