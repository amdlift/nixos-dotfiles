# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "aaronix"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  services.power-profiles-daemon.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aaron = {
    isNormalUser = true;
    description = "Aaron Davis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    vscode
    firefox
    pwvucontrol
    brightnessctl
    networkmanagerapplet
    jellyfin-desktop
    btop
    steamcmd
    dua
    qbittorrent

    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];

  services.displayManager.sddm = {
    enable = true;

    wayland = {
      enable = true;
    };
    theme = "catppuccin-mocha-mauve";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fix brightness issue
  boot.kernelParams = [ "amdgpu.backlight=0" ];

  #Needed for hyprlock
  security.pam.services.hyprlock = {};

  # Nvidia Business
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  hardware.nvidia.open = true;

  # Fix backlight issues on Legion 5
  services.udev.extraRules = ''
    SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl*", ATTR{type}=="raw", SYMLINK+="backlight"
  '';

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  # Steam
  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
    # Other general flags if available can be set here.
  };
  # Tip: For improved gaming performance, you can also enable GameMode:
  programs.gamemode.enable = true;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
