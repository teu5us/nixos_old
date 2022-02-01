{ config, pkgs, options, lib, ... }:

let
  aliases = {
    ls = "${pkgs.exa}/bin/exa";
    v = "nvim";
  };
in
{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      undistractMe.enable = true;
      shellAliases = aliases;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      histSize = 10000;
      syntaxHighlighting.enable = true;
      autosuggestions = {
        enable = true;
        async= true;
      };
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
