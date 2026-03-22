# Dylan Kirby NixOS configuration

![NixOs Logo](https://img.shields.io/badge/Nix%20OS-5277C3?style=for-the-badge&logo=Nixos&logoColor=white)

This repo follows a dendritic flake layout inspired by https://github.com/mightyiam/dendritic.

## Layout

- `modules/config/` flake-parts plumbing and shared flake options
- `modules/nixos/` reusable NixOS modules (system features)
- `modules/dev/` devShell definitions
- `setups/` host bundles (`home`, `work`, `lab`)
- `profiles/` Home Manager profiles and HM feature modules
- `misc/` non-module shared assets (e.g. `nvim-lua`)
- `scripts/` helper scripts (`update.sh`, `flake-age.sh`)


## How to update and/or switch the configuration

**Update the flake:**
```
sudo nix flake update
```


**Switch the configuration to a setup:**
```
sudo nixos-rebuild switch --flake .#<setup>
```

> See `setups/` for machine bundles<br>
> See `modules/` for reusable feature modules

---

This is my personal NixOS configuration. It is a work in progress and is constantly changing. I am using this repository to keep track of my configuration and to make it easier to replicate my setup on other machines.

Currently, this configuration uses a dendritic flake setup with flake-parts. This allows composing machine bundles from reusable modules in a single repository.

The flake imports packages from Nixpkgs 25.05 and unstable in two separate inputs. This allows more flexibility in the packages used in the configuration. It also defines `meta.allowedUnfreePackages` so unfree package allow-listing is managed in one place.

## Checking the config

To check the configuration, run the following command:

> We need impure because we use an absolute path to reference the `hardware-configuration.nix` file

```
nix flake check --impure
```

You can also evaluate a specific host derivation directly:

```
nix eval .#nixosConfigurations.lab.config.system.build.toplevel.drvPath --impure
```

If all is well, then the configuration is good to go.

You may also wish to format the configuration:

```
treefmt
```


# Inspired by:

[![Vimjoyer](https://img.shields.io/badge/GitHub-Vimjoyer-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/vimjoyer/)

[![Librephoenix](https://img.shields.io/badge/GitHub-Librephoenix-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/librephoenix/)
