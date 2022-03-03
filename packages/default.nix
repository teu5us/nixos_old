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
}
