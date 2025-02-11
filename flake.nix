{
  description = "Dylan Kirby's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let

      system = "x86_64-linux";
      allowed-unfree-pkgs = [
        "vscode"
        "vscode-extension-github-copilot"
        "vscode-extension-github-copilot-chat"
        "vscode-extension-MS-python-vscode-pylance"
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "reaper"
      ];

      # Define the pkgs and unstable pkgs with the allowed unfree pkgs using the predicate
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowed-unfree-pkgs;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate =
          pkg: builtins.elem (nixpkgs-unstable.lib.getName pkg) allowed-unfree-pkgs;
      };
    in
    {
      nixosConfigurations = {
        kirby = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
          ];
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
            inherit allowed-unfree-pkgs;
          };
        };
      };
    };
}
