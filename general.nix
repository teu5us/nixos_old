{ config, pkgs, options, lib, ... }:

{
  users = {
    mutableUsers = false;
    users = {
      paul = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "disk"
          "networkmanager"
          "input"
          "uinput"
          "dialout"
          "docker"
          "kvm"
          "libvirtd"
          "tty"
        ]; # Enable ‘sudo’ and other groups for the user.
        group = "users";
        home = "/home/paul";
        uid = 1000;
        password = "loveyou";
        shell = pkgs.zsh;
      };
    };
    extraGroups.uinput = { name = "uinput"; };
  };

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
    # nixPath = options.nix.nixPath.default
    #   ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
  };

  documentation = {
    enable = true;
    dev.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    doc.enable = true;
    info.enable = true;
    nixos = {
      enable = true;
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

    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "hfjbmagddngcpeloejdejnfgbamkjaeg" # vimium c
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # darkreader
        "chphlpgkkbolifaimnlloiipkdnihall" # onetab
        "lhaoghhllmiaaagaffababmkdllgfcmc" # atomic-chrome
        "egpjdkipkomnmjhjmdamaniclmdlobbo" # firenvim
        "djflhoibgkdhkhhcedjiklpkjnoahfmg" # user-agent switcher
        "jinjaccalgkegednnccohejagnlnfdag" # violentmonkey
        "oboonakemofpalcgghocfoadofidjkkk" # keepassxc-browser
        "fhcgjolkccmbidfldomjliifgaodjagh" # cookieautodelete
        "gphhapmejobijbbhgpjhcjognlahblep" # gnome extensions
      ];
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
    ncdu
    bat
    aria2 curl wget
    ffmpeg
    zoxide
    htop
    gitAndTools.gitFull
    vim
    (hunspellWithDicts (with hunspellDicts; [ en_GB-large en_US-large ru_RU ]))
    paprefs pavucontrol pulsemixer
    xtrlock-pam
    compton
    chromium brave
    wmctrl
    dragon-drop
    redshift
    qemu spice-gtk virglrenderer virtviewer virt-manager
  ];
}
