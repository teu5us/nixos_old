{ config, pkgs, options, lib, ... }:

let
  aliases = let
    exa = "${pkgs.exa}/bin/exa --group-directories-first";
  in {
    ls = "${exa}";
    ll = "${exa} -l";
    la = "${exa} -a";
    lla = "${exa} -al";
    v = "nvim";
    mkd = "mkdir -pv";
    diff = "diff --color=auto";
    grep = "grep --color=auto";
    cp = "cp -i";
  };
in
{
  programs = {
    bash = {
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
      };
      shellAliases = aliases;
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables = {
    PATH = "$PATH:$HOME/.local/bin";
    PROMPT_SFZ_CHAR = "λ";
  };
}
