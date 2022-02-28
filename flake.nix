{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.kmonad.url = "github:kmonad/kmonad?dir=nix";
  inputs.kmonad.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-store-emacs-packages.url = "github:teu5us/nix-store-emacs-packages";
  inputs.nix-store-emacs-packages.inputs.nixpkgs.follows = "nixpkgs";

  inputs.emacs-overlay.url = "github:nix-community/emacs-overlay?rev=396182cd543073db96ea696bd2a41cb24e87781f";

  outputs = inputs:
    let baseSystem = import ./base-system.nix inputs;
    in
      {

        nixosConfigurations.nix450s = baseSystem "x86_64-linux"
          [ ./machines/nix450s ./modules/gui/gnome.nix ./modules/yggdrasil ];

        nixosConfigurations.nix450s-startx = baseSystem "x86_64-linux"
          [ ./machines/nix450s ./modules/gui/startx.nix ./modules/yggdrasil ];

      };
}
