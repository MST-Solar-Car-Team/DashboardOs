  { config, pkgs, lib, dashboard, ... }: {
    system.stateVersion = "24.05";

    users.users.root.initialPassword = "pi";

    #networking
    networking.hostName = "pi";
    # networking.useDHCP = true;
    networking.wireless.enable = true;
    networking.networkmanager.enable = false;

    networking.wireless.networks = {
      solar-car = {
        auth= ''
          psk="password"
          ssid="solar-car"
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
    # services.displayManager.autoLogin.user = "pi";
    # services.displayManager.autoLogin.enable = true;

    # services.wayland.enable = true;  
    services.xserver.enable = false;


    services.cage = {
      enable = true;
      # program = "${pkgs.firefox}/bin/firefox";
      # program = "${dashboard.packages.x86_64-linux.default}/bin/dashboard";
      program ="${pkgs.foot}/bin/foot"; 
      user = "pi";  
      # tty = "tty1";
    };

    

    #wait for network and DNS
    systemd.services."cage-tty1".after = [
      # "network-online.target"
      "systemd-resolved.service"
    ];


    environment.systemPackages = [
      dashboard.packages.x86_64-linux.default
      pkgs.xterm
      pkgs.cage
      pkgs.libxkbcommon

      #debugging tools
      pkgs.helix
      pkgs.git
    ];

    environment.sessionVariables = {
      # LD_LIBRARY_PATH = "${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.xorg.libXi}/lib:${pkgs.libxkbcommon}/lib";
      LD_LIBRARY_PATH="${pkgs.wayland}/lib:${pkgs.libxkbcommon}/lib";
      WINIT_UNIX_BACKEND = "wayland";
    };


    #add git repo to build from
    # environment.etc.dashboard_os = {
    #   source = builtins.fetchGit{
    #     url = "https://github.com/MST-Solar-Car-Team/DashboardOs.git";
    #     # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    #     ref = "speed-up-boot";
    #     rev = "0a199eaf8a600fd5af0beadd2645d166ff742ac2";
    #   };
    #   mode = "0440";
    # };


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

    hardware.opengl.enable = true;
    # hardware.raspberry-pi-3.fkms-3d.enable = true; # Or rpi3 if appropriate

}
