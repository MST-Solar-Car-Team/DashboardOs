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

            ({ config, pkgs, ... }: {
              system.stateVersion = "24.05";

              users.users.root.initialPassword = "raspberry";

              networking.useDHCP = true;
              services.openssh.enable = true;

              users.users.pi = {
                isNormalUser = true;
                password = "raspberry";
                extraGroups = [ "wheel" ];
              };

              # services.xserver.enable = true;
              # services.xserver.windowManager.matchbox.enable = true;
              # services.xserver.displayManager.auto.enable = true;
              # services.xserver.displayManager.auto.user = "pi";

              # services.xserver.displayManager.sessionCommands = ''
              #   ${pkgs.xorg.xset}/bin/xset s off
              #   ${pkgs.xorg.xset}/bin/xset -dpms
              #   ${pkgs.xorg.xset}/bin/xset s noblank
              #   ${pkgs.chromium}/bin/chromium --noerrdialogs --kiosk https://example.com --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI &
              # '';

              # environment.systemPackages = with pkgs; [
              #   chromium
              #   xorg.xset
              # ];

              boot.loader.grub.enable = false;
              boot.loader.generic-extlinux-compatible.enable = true;

              boot.initrd.availableKernelModules = [ "bcm2835_dma" "sdhci_iproc" "sdhci" "mmc_block" ];

          
              # boot.kernelPackages = pkgs.linuxPackages_rpi3;
              hardware.enableRedistributableFirmware = true;
            })
          ];
        };
      in {
        packages.rpiImage = nixosSystem.config.system.build.sdImage;
        defaultPackage = self.packages.${system}.rpiImage;
      });
}

