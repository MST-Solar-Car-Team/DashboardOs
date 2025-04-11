{
  description = "Raspberry Pi 3B Kiosk SD Image using cross-compilation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Architecture we're targeting
        targetSystem = "aarch64-linux";

        # For host tools
        pkgs = import nixpkgs {
          inherit system;
        };

        # Correct way to create nixosSystem using lib
        nixosSystem = nixpkgs.lib.nixosSystem {
          system = targetSystem;
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./config.nix
          ];
        };
      in {
        packages.rpiImage = nixosSystem.config.system.build.sdImage;
        defaultPackage = self.packages.${system}.rpiImage;
      });
}

