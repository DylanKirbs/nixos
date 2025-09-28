{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
    }:
    let
      system = "x86_64-linux";
      allowed-unfree-pkgs = [
        "code"
        "vscode"
        "vscode-extension-github-copilot"
        "vscode-extension-github-copilot-chat"
        "vscode-extension-MS-python-vscode-pylance"
        "vscode-extension-mhutchie-git-graph"
        "vscode-extension-ms-vscode-cpptools"
        "vscode-extension-ms-vscode-remote-remote-ssh"
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "reaper"
        "obsidian"
        "zerotierone"
      ];

      # Define unstable pkgs with the allowed unfree pkgs using the predicate
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate =
          pkg: builtins.elem (nixpkgs-unstable.lib.getName pkg) allowed-unfree-pkgs;
      };

      # Dynamically detect the current user and host
      currentUser = builtins.getEnv "USER";
      currentHost = builtins.getEnv "HOSTNAME";

      # Helper function to list Nix files in a directory, ignoring `common.nix`
      listNixFiles =
        dir:
        let
          files = builtins.attrNames (builtins.readDir dir);
          nixFiles = builtins.filter (name: builtins.match ".*\\.nix" name != null) files;
        in
        builtins.filter (name: name != "common.nix") nixFiles;

      # Dynamically read hosts and users
      hosts = builtins.listToAttrs (
        builtins.map (name: {
          name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
          value =
            if builtins.pathExists ./hosts/${name} then
              ./hosts/${name}
            else
              throw "Host configuration '${name}' not found!";
        }) (listNixFiles ./hosts)
      );

      users = builtins.listToAttrs (
        builtins.map (name: {
          name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
          value =
            if builtins.pathExists ./users/${name} then
              ./users/${name}
            else
              throw "User configuration '${name}' not found!";
        }) (listNixFiles ./users)
      );

      # Generate all user-host combinations
      userHostCombinations = nixpkgs.lib.cartesianProduct {
        user = builtins.attrNames users;
        host = builtins.attrNames hosts;
      };

      # Helper function to create a NixOS configuration
      mkNixOSConfig =
        {
          host,
          user ? currentUser,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              pkgs-unstable
              allowed-unfree-pkgs
              user
              ;
          };
          modules = [
            # Configure nixpkgs within the NixOS system
            {
              nixpkgs.config.allowUnfreePredicate =
                pkg: builtins.elem (nixpkgs.lib.getName pkg) allowed-unfree-pkgs;
            }
            hosts.${host}
            home-manager.nixosModules.home-manager
            {
              home-manager.users.${user} = users.${user};
              home-manager.extraSpecialArgs = {
                inherit
                  pkgs-unstable
                  allowed-unfree-pkgs
                  user
                  ;
              };
            }
          ];
        };
    in
    # # Helper function to create a Home Manager configuration
    # mkHomeConfig =
    #   { user }:
    #   home-manager.lib.homeManagerConfiguration {
    #     inherit system;
    #     configuration = users.${user};
    #     extraSpecialArgs = {
    #       inherit pkgs pkgs-unstable allowed-unfree-pkgs;
    #     };
    #   };
    {
      # NixOS configurations for all user-host combinations
      nixosConfigurations = builtins.listToAttrs (
        builtins.map (
          { user, host }:
          {
            name = "${user}@${host}";
            value = mkNixOSConfig { inherit host user; };
          }
        ) userHostCombinations
      );

      # Home Manager configurations (to allow non-sudo users to manage their own configuration: idk if it actually works though)
      # homeConfigurations = builtins.mapAttrs (name: value: mkHomeConfig { user = name; }) users;
    };
}
