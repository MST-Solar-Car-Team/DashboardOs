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

     # Auto loging
    services.displayManager.autoLogin.user = "pi";
    services.displayManager.autoLogin.enable = true;

    services.cage = {
      enable = true;
      program = "${pkgs.firefox}/bin/firefox";
      user = "pi";
    };

    # wait for network and DNS
    systemd.services."cage-tty1".after = [
      "network-online.target"
      "systemd-resolved.service"
    ];


    environment.systemPackages = with pkgs; [
      chromium
      xorg.xset
    ];

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    #allows for serial communication
    boot.kernelParams = [
      "console=ttyS1,115200n8"
    ];

    boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

    boot.initrd.availableKernelModules = [ "bcm2835_dma" "sdhci_iproc" "sdhci" "mmc_block" ];


    # boot.kernelPackages = pkgs.linuxPackages_rpi3;
    hardware.enableRedistributableFirmware = true;
}
