{ stdenv, lib, fetchgit, libX11, libXinerama, libXft, zlib, patches ? [] }:

stdenv.mkDerivation rec {
  name = "dmenu-4.9";

  # src = fetchgit {
  #   url = "https://gitlab.com/Teu5us/x220-dmenu";
  #   rev = "a06b628ae3ed460c52e5f62939d2299914a70c4d";
  #   sha256 = "1g2gynh1g0yia00caryxq68gb4s9km1jyic2cf5vncxyb5mfi9vb";
  # };

  src = fetchgit {
    url = "https://gitlab.com/Teu5us/x220-dmenu";
    rev = "f7c6db082067c4a08d2bd515ca7bdecd6aa12f01";
    sha256 = "1m23x7p6x1anik15irz6zyj1fz64pdz671dw5bm9q7qm7xyi4bfg";
  };

  buildInputs = [ libX11 libXinerama zlib libXft ];

  inherit patches;

  postPatch = ''
    sed -ri -e 's!\<(dmenu|dmenu_path|stest)\>!'"$out/bin"'/&!g' dmenu_run
    sed -ri -e 's!\<stest\>!'"$out/bin"'/&!g' dmenu_path
  '';

  preConfigure = ''
    sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk
  '';

  makeFlags = [ "CC:=$(CC)" ];

  meta = with lib; {
      description = "A generic, highly customizable, and efficient menu for the X Window System";
      homepage = https://tools.suckless.org/dmenu;
      license = licenses.mit;
      maintainers = with maintainers; [ pSub globin ];
      platforms = platforms.all;
  };
}
