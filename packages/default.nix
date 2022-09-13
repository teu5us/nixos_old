self: super: {
  spoof-dpi = super.callPackage ./spoof-dpi {};
  dmenu = super.callPackage ./dmenu {};
  dwm = super.callPackage ./dwm {};
  st = super.callPackage ./st {};
  wheel-accel = super.callPackage ./wheel-accel {
    mkDerivation = super.stdenv.mkDerivation;
    buildPythonPackage = super.python3.pkgs.buildPythonPackage;
    fetchPypi = super.python3.pkgs.fetchPypi;
  };
  easystroke = super.callPackage ./easystroke {};
  vimPlugins = super.vimPlugins.extend (self': super': {
    lens-vim = self.vimUtils.buildVimPluginFrom2Nix {
      pname = "lens.vim";
      version = "2022-09-13";
      src = self.fetchFromGitHub {
        owner = "Teu5us";
        repo = "lens.vim";
        rev = "43ad41c9fbe3add97aaff0294af74b59191de85a";
        sha256 = "0sbj24pg1286sk3wkqbj66vddiysiq5lp46ykqnv6alkr90ng8p5";
      };
      meta.homepage = "https://github.com/Teu5us/lens.vim/";
    };
  });
}
