{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    haskell-language-server
    (haskell.packages.ghc8107.ghcWithHoogle
      (haskellPackages: with haskellPackages; [
        xmonad xmonad-contrib xmonad-extras xmonad-screenshot
        brittany
      ]))
  ];
}
