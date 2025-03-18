# Dylan Kirby NixOS configuration

![NixOs Logo](https://img.shields.io/badge/Nix%20OS-5277C3?style=for-the-badge&logo=Nixos&logoColor=white)


## How to update and/or switch the configuration

**Update the flake:**
```
sudo nix flake update
```


**Switch the configuration to a specific user on a specific host:**
```
sudo nixos-rebuild switch --flake .#<user>@<hostname>
```

> See `users/` for user configurations<br>
> See `hosts/` for host configurations

---

This is my personal NixOS configuration. It is a work in progress and is constantly changing. I am using this repository to keep track of my configuration and to make it easier to replicate my setup on other machines.

Currently, this configuration uses a flakes-based setup with a NixOS module approach to Home Manager. This allows me to easily manage my system configuration and user configuration in a single repository.

The flake imports packages from Nixpkgs 24.05 and unstable in two separate inputs. This allows more flexibility in the packages that can be used in the configuration. In addition it features an `allowed-unfree-pkgs` attribute that allows me to easily configure which packages are allowed to be used in both safe and unsafe package repositories.


# Inspired by:

[![Vimjoyer](https://img.shields.io/badge/GitHub-Vimjoyer-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/vimjoyer/)

[![Librephoenix](https://img.shields.io/badge/GitHub-Librephoenix-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/librephoenix/)
