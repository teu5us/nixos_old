{ config, pkgs, options, lib, ... }:

{
  users = {
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
        hashedPassword = "$6$6TbBDrWaFNFUxUu2$vbwiaynzRobGBSlqvmuGolQmOA7l2HeirACJCBIalVTLdspFFKo7Ho/VH/81jKrQqNoLM7/.wr0DNfjlHRafH0";
        shell = pkgs.zsh;
      };
    };
  };
  home-manager.users.paul = import ./hm;
}
