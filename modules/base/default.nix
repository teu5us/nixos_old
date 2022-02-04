{ config, pkgs, options, lib, ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
    };
    efi.canTouchEfiVariables = true;
  };

  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    keyMap = "emacs";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales =
      [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
  };

  time.timeZone = "Asia/Omsk";

  nix = {
    trustedUsers = [ "root" ];
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    # nixPath = options.nix.nixPath.default
    #   ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      nix-direnv = super.nix-direnv-flakes;
    })
  ];

  documentation = {
    enable = true;
    dev.enable = true;
    man = {
      enable = true;
      generateCaches = false;
    };
    doc.enable = true;
    info.enable = true;
    nixos = {
      enable = false;
      includeAllModules = true;
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    forwardX11 = false;
  };

  services.nscd.enable = true;

  services.cron.enable = true;

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = ''
      RuntimeDirectorySize=20%
    '';
  };

  programs = {
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    file
    findutils
    fd ripgrep
    which
    nix-prefetch-scripts
    lm_sensors
    zip unzip
    poppler_utils poppler_data
    libnotify
    bat
    aria2 curl wget
    htop
    gitAndTools.gitFull
    vim
  ];

  users.extraGroups.uinput = { name = "uinput"; };
  users.mutableUsers = false;
}
