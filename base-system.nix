inputs:

system: modules:

inputs.nixpkgs.lib.nixosSystem {
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

    ({ pkgs, lib, ... }: {
      imports =
        lib.optional (builtins.pathExists /etc/nixos/cachix.nix) /etc/nixos.cachix.nix;
      environment.systemPackages =
        lib.optional (builtins.pathExists /etc/nixos/cachix.nix) pkgs.cachix;
    })

    inputs.kmonad.nixosModule

    inputs.nix-store-emacs-packages.nixosModule

    ({ pkgs, ... }: {
      nixpkgs.overlays = [
        inputs.emacs-overlay.overlay
      ];
    })
  ] ++ modules;
}
