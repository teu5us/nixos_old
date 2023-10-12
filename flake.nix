{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-store-emacs-packages = {
      url = "github:teu5us/nix-store-emacs-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # yandex-browser = {
    #   url = "github:Teu5us/nix-yandex-browser";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs:
    let baseSystem = import ./base-system.nix inputs;
    in
      {
        nixosConfigurations = {
          nix450s = baseSystem {
            hostname = "nix450s";
            system = "x86_64-linux";
            modules = [ ./machines/nix450s ./modules/gui/gnome.nix ./modules/yggdrasil

                        ({ config, ... }: {
                          specialisation = {
                            startx = {
                              inheritParentConfig = true;
                              configuration = {
                                imports = [ ./modules/gui/startx.nix ];
                              };
                            };
                          };
                          networking.bridges.br0 = {
                            interfaces = [ "enp0s25" ];
                          };
                        })
                      ];
          };
        };
        overlay = import ./packages;
      };
}
