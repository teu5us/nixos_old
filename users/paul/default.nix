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
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCq0y7v3jkbf6y0JO8w8AMwwaVR8bRGorApkRHU3A2yKOF91BsN4EGcdNs1bj3zSD+cXVihARacILRFkN5FHKNakLsZ4AQzhMpXwT0vdVaWDM5KNaeHLoZDHEXj2UFTOndwmfLb0YOgkCbTx2gWKvEzd50AJLH4PRbkQO3SM5ZUKswQNHTATsIOwZ3Y51a2lBIXHA8TMM9IdjV5g/V/3VQLV8EuE5ASt/wusLltek8bHrNKtEP691/bHNP6neCSCHKbT9TMfxzC1ovb/IJWKyNVBdI8FKwgAsLIBZ1vLhgx2kUGISpacnvz/OWRZRKfhztLpiKclIpIc+dJURyhq9/SDqLBNmY/gzvhs5V42ZmmYiwMzZBUaLRXfuJKqbdY93qYbd+LjfxnxeB8RFjoEDLQL68b0k5opdgRiEwsbxyg/4VCh09XDqqN7V7kk0FLZoH9UyI0Lg8/3jOKHU+4U/znASoSf9S6SCFcGocddpvs9kszQy6KX1lFJ9yQxSUeRuw2KcYcKm8fODtb+hmzdiXEenUtILWR6tPJ5IN8OR91V5mXQCYatM5BMP0NcfNemJMjvNp/n++eVfAeHXf2Vax2CjxJfUq/yAZsQmHH5Drg/FE/NC3AyeyQpQmLY80bvbga8T5o/bmmRnLvNOE8pBuIjZkApP1OHdRpQfKutdNCIw== u0_a305@localhost"
        ];
      };
    };
  };

  home-manager.users.paul = import ./hm;

  services.xserver.displayManager.session = [
    { manage = "window";
      name = "exwm";
      start = ''
        dbus-launch --sh-syntax --exit-with-session exwm
        waitPID=$!
      '';
    }
  ];
}
