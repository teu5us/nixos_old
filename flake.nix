# https://www.tweag.io/blog/2020-07-31-nixos-flakes/

# To switch from channels to flakes execute:
# cd /etc/nixos
# sudo wget -O flake.nix https://gist.githubusercontent.com/misuzu/80af74212ba76d03f6a7a6f2e8ae1620/raw/flake.nix
# sudo sed -i "s/myhost/$(hostname)/g" flake.nix
# sudo git init
# sudo git add . # won't work without this
# nix run nixpkgs.nixFlakes -c sudo nix --experimental-features 'flakes nix-command' build .#nixosConfigurations.$(hostname).config.system.build.toplevel
# sudo ./result/bin/switch-to-configuration switch

# Now nixos-rebuild can use flakes:
# sudo nixos-rebuild switch --flake /etc/nixos

# To update flake.lock run:
# sudo nix flake update --commit-lock-file /etc/nixos

{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.kmonad.url = "github:kmonad/kmonad?dir=nix";
  inputs.kmonad.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-store-emacs-packages.url = "github:teu5us/nix-store-emacs-packages";
  inputs.nix-store-emacs-packages.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs: rec {

      baseSystem = system: modules: (inputs.nixpkgs.lib.nixosSystem {
        system = system;
        # Things in this set are passed to modules and accessible
        # in the top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`).
        specialArgs = {
          inherit inputs;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager

          ({ pkgs, ... }: {
            nix.extraOptions = "experimental-features = nix-command flakes";
            nix.package = pkgs.nixFlakes;
            nix.registry.nixpkgs.flake = inputs.nixpkgs;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          })

          inputs.kmonad.nixosModule

          inputs.nix-store-emacs-packages.nixosModule
        ] ++ modules;
      });


      nixosConfigurations.nix450s = baseSystem "x86_64-linux"
        [ ./machines/nix450s ./modules/gui/gnome.nix ];

      nixosConfigurations.nix450s-startx = baseSystem "x86_64-linux"
        [ ./machines/nix450s ./modules/gui/startx.nix ];

    };
}
