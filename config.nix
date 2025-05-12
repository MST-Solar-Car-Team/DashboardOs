  { config, pkgs, dashboard, ... }: {
    system.stateVersion = "24.05";

    users.users.root.initialPassword = "pi";

    #networking
    networking.hostName = "pi";
    # networking.useDHCP = true;
    networking.wireless.enable = true;

    networking.wireless.networks = {
      solar-car = {
        auth= ''
          ssid="solar-car"
          psk="password"
          proto=RSN
          key_mgmt=WPA-PSK
          pairwise=CCMP
          auth_alg=OPEN
        '';
      };
    };

    #ssh
    services.openssh.enable = true;
    services.openssh.ports = [22];


    users.users.pi = {
      isNormalUser = true;
      password = "pi";
      extraGroups = [ "wheel" "networkmanager" "video" "input"];
    };

     # Auto loging
    services.displayManager.autoLogin.user = "pi";
    services.displayManager.autoLogin.enable = true;


    services.cage = {
      enable = true;
      # program = "${pkgs.firefox}/bin/firefox";
      program = "${dashboard.packages.x86_64-linux.default}/bin/dashboard";
      user = "pi";  
    };

    

    # wait for network and DNS
    systemd.services."cage-tty1".after = [
      # "network-online.target"
      "systemd-resolved.service"
    ];


    environment.systemPackages = [
      dashboard.packages.x86_64-linux.default
      pkgs.xterm
      pkgs.cage
    ];

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    #allows for serial communication
    boot.kernelParams = [
      "console=ttyS1,115200n8"
    ];


    # boot.loader.timeout = 0;

    boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

    boot.initrd.availableKernelModules = [ "bcm2835_dma" "sdhci_iproc" "sdhci" "mmc_block" ];


    # boot.kernelPackages = pkgs.linuxPackages_rpi3;
    hardware.enableRedistributableFirmware = true;
}
