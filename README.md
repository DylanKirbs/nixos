# Dylan Kirby NixOS configuration

![NixOs Logo](https://img.shields.io/badge/Nix%20OS-5277C3?style=for-the-badge&logo=Nixos&logoColor=white)


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

Currently, this configuration uses a dendritic flakes setup with flake-parts. This allows me to compose machine bundles from reusable modules in a single repository.

The flake imports packages from Nixpkgs 24.05 and unstable in two separate inputs. This allows more flexibility in the packages that can be used in the configuration. In addition it features an `allowed-unfree-pkgs` attribute that allows me to easily configure which packages are allowed to be used in both safe and unsafe package repositories.

## Checking the config

To check the configuration, run the following command:

> We need impure because we use an absolute path to reference the `hardware-configuration.nix` file

```
nix flake check --impure
```

If all is well, then the configuration is good to go.

You may also wish to format the configuration:

```
treefmt
```


# Inspired by:

[![Vimjoyer](https://img.shields.io/badge/GitHub-Vimjoyer-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/vimjoyer/)

[![Librephoenix](https://img.shields.io/badge/GitHub-Librephoenix-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/librephoenix/)
