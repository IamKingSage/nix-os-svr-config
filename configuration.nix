# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader Configuration.
  boot.loader = {
    grub.enable = true;
    grub.device = "/dev/sda";
    grub.useOSProber = true;
  };

  # Networking and Firewall Configuration.
  networking = {
    # Enable Networking
    networkmanager.enable = true;

    hostName = "SageNixSvr"; # Define your hostname.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant

    # Configure Network proxy if necessary.
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  
    # Or disable the firewall altogether.
    # firewall.enable = true;

  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Services
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = false;
  services = {

    # Configure keymap in X11.
    xserver = {
      # Enable the X11 windowing system.
      # enable = true;

      # Enable the Gnome Desktop Environment.
      # displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;

      # Configure keymap in X11.
      xkb.layout = "us";
      xkb.variant = "";
    };

    # Printing - Enable CUPS to print Documents.
    # printing.enable = true;

    # Enable Tailscale. 
    tailscale.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Setting up VSCODE Webserver for Server
    # openvscode-server = {
    # enable = true;
    # serverDataDir = "/opt/openvscode-server";
    # withoutConnectionToken = true;
    # telemetryLevel = "off";
    # user = "sage";
    # port = 3001;
    # host = "127.0.0.1";
    # }

    # Enable sound with pipewire.
    # pipewire = {
      # enable = lib.mkDefault true;
      # alsa.enable = true;
      # alsa.support32Bit = true;
      # pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    # };

    # Enable touchpad support (enabled default in most desktopManager).
    # xserver.libinput.enable = true;
  };

  # Install Programs
  programs = {

    # Install Firefox
    # firefox.enable = true;
  
    # Install nix-ld? Have no idea what this is...
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
  
    # Install Git to Nix
    git.enable = true;

    # Enable direnv program
    direnv.enable = true;

    # Some programs need SUID wrappers, can be configured further or are started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  # Define a user account for OpenSSH. Don't forget to set a password with ‘passwd’.
  users.users.sage = {
    isNormalUser = true;
    description = "sage";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPliz30Qy/H2738bbKsA3c/UR31isFweWMoIKoXLIUOp zachs@DESKTOP-UJDPFRD"
    ];
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # # create a oneshot job to authenticate to Tailscale
  # systemd.services.tailscale-autoconnect = {
  #   description = "Automatic connection to Tailscale";

  #   # make sure tailscale is running before trying to connect to tailscale
  #   after = [ "network-pre.target" "tailscale.service" ];
  #   wants = [ "network-pre.target" "tailscale.service" ];
  #   wantedBy = [ "multi-user.target" ];

  #   # set this service as a oneshot job
  #   serviceConfig.Type = "oneshot";

  #   # have the job run this shell script
  #   script = with pkgs; ''
  #     # wait for tailscaled to settle
  #     sleep 2

  #     # check if we are already authenticated to tailscale
  #     status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
  #     if [ $status = "Running" ]; then # if so, then do nothing
  #       exit 0
  #     fi

  #     # otherwise authenticate with tailscale
  #     ${tailscale}/bin/tailscale up -authkey tskey-auth-kb2RHoMM7n11CNTRL-WPektUWAsbaLSXmxZujLcaEdeBd6bAskJ
  #   '';
  # };

  # "sagenixsvr.tailf51c16.ts.net" is the tailscale ssh setup.
  # Looking up how to set up SSH between Tailscale and NixOS

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Enabled the ability to get VSCODE work for my server.
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    nixpkgs-fmt
  ];

  nix.nixPath = [
    "nixos-config=/home/sage/nixosconfig/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
