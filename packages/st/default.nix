{ stdenv, fetchgit, pkgconfig, writeText, libX11, ncurses, libXext, libXft, fontconfig
, conf? null, patches ? []}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-0.8.2";

  src = fetchgit {
    url = "http://github.com/LukeSmithxyz/st.git";
    rev = "7e01028f866d669396ed459e48dbb6b56852bb44";
    sha256 = "1sghnwczcbph4c27z79sy3l07gy4bv2hqp4wmhpjdjmscncwb3bk";
  };

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  # Allow users to apply their own list of patches
  inherit patches;

  buildInputs = [ pkgconfig libX11 ncurses libXext libXft fontconfig ];

  NIX_LDFLAGS = "-lfontconfig";

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = http://st.suckless.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = with maintainers; [viric];
    platforms = with platforms; linux;
  };
}
