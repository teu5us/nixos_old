{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

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

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    yandex-browser.url = "github:Teu5us/nix-yandex-browser";
    yandex-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, kmonad, nix-store-emacs-packages, emacs-overlay, yandex-browser }:
    let baseSystem = import ./base-system.nix inputs;
    in
      {
        nixosConfigurations = {
          nix450s = baseSystem {
            hostname = "nix450s";
            system = "x86_64-linux";
            modules = [ ./machines/nix450s ./modules/gui/gnome.nix ./modules/yggdrasil ];
          };

          # nix450s-startx = baseSystem "x86_64-linux"
          #   [ ./machines/nix450s ./modules/gui/startx.nix ./modules/yggdrasil ];
        };
        overlay = import ./packages;
      };
}
