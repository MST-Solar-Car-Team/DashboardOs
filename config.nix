  { config, pkgs, ... }: {
    system.stateVersion = "24.05";

    users.users.root.initialPassword = "raspberry";

    #networking
    networking.hostName = "pi";
    networking.useDHCP = true;

    #ssh
    services.openssh.enable = true;
    services.openssh.ports = [22];


    users.users.pi = {
      isNormalUser = true;
      password = "raspberry";
      extraGroups = [ "wheel" "networkmanager"];
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
}
