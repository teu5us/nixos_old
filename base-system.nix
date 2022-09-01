inputs:

{ hostname, system, modules, overlay-compat-config ? hostname }:

let
  overlays-compat = builtins.toFile "overlays.nix" ''
    self: super:
    with super.lib;
    let
      # Load the system config and get the `nixpkgs.overlays` option
      overlays = getAttrFromPath [
        "nixosConfigurations"
        "${overlay-compat-config}"
        "config"
        "nixpkgs"
        "overlays"
      ] (builtins.getFlake "${./.}");
    in
      # Apply all overlays to the input of the current "main" overlay
      foldl' (flip extends) (_: super) overlays self
  '';
in
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
      nix.nixPath = [
        "nixpkgs-overlays=/etc/nixos/overlays-compat/"
      ];
      nix.registry.nixpkgs.flake = inputs.nixpkgs;

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };

      environment.etc = {
        "nixos/overlays-compat/overlays.nix".source = overlays-compat;
      };
    })

    ({ pkgs, lib, ... }: {
      imports =
        lib.optional (builtins.pathExists /etc/nixos/cachix.nix) /etc/nixos/cachix.nix;
      environment.systemPackages =
        lib.optional (builtins.pathExists /etc/nixos/cachix.nix) pkgs.cachix;
    })

    inputs.kmonad.nixosModules.default

    inputs.nix-store-emacs-packages.nixosModule

    ({ config, ... }: {
      networking.hostName = hostname; # Define your hostname.
      nixpkgs.overlays = [
        inputs.emacs-overlay.overlay
        (import ./packages)
      ];
    })
  ] ++ modules;
}
