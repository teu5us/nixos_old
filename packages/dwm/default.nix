{stdenv, lib, fetchgit, libX11, libXinerama, libXft, patches ? []}:

let
  name = "dwm-6.2";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchgit {
    url = "https://gitlab.com/Teu5us/gen220-dwm";
    rev = "4b57940745c601b6203529ca7d2dca49efa1c50f";
    sha256 = "1r48ysy53538lzrjppg39ijmrpj034c1ji327cwcxq91widbixyw";
  };

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  buildPhase = " make ";

  meta = {
    homepage = https://suckless.org/;
    description = "Dynamic window manager for X";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; all;
  };
}
