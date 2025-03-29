{
  description = "Build image";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  outputs = { self, nixpkgs }: rec {
    nixosConfigurations.rpi2 = nixpkgs.lib.nixosSystem {
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
        # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        {
          nixpkgs.config.allowUnsupportedSystem = true;
          # nixpkgs.crossSystem = { system = "armv7l-linux"; };
          nixpkgs.hostPlatform.system = "armv7l-linux";
          nixpkgs.buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.
          # ... extra configs as above
          
          system.stateVersion = "24.05";
          
          #Pi Stuff
          # boot.loader.grub.enable = false;
          # boot.loader.generic-extlinux-compatible.enable = true;

          # nixpkgs.crossSystem.system = "armv7l-linux";
          # imports = [
          #   <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
          # ];

        }
      ];
    };
    images.rpi2 = nixosConfigurations.rpi2.config.system.build.sdImage;
  };
}


