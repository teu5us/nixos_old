{ mkDerivation, fetchgit, buildPythonPackage, fetchPypi, python3 }:

let
  better-exchook = buildPythonPackage rec {
    pname = "better_exchook";
    version = "1.20210319.113053";
    src = fetchPypi {
      inherit pname version;
      sha256 = "2e5b3666d5105a2e0ede58d100518b2a684f611e6ba142b15222dfbf66444148";
    };
  };
  pyinput = buildPythonPackage rec {
    pname = "pynput";
    version = "1.7.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "4e50b1a0ab86847e87e58f6d1993688b9a44f9f4c88d4712315ea8eb552ef828";
    };

    buildInputs = with python3.pkgs; [
      setuptools-lint
      sphinx
      six
      evdev
      xlib
    ];

    propagatedBuildInputs = with python3.pkgs; [ six xlib evdev ];

    doCheck = false;
  };
in
mkDerivation rec {
  pname = "wheel-accel";
  version = "master-2021-10-05";
  src = fetchgit {
    url = "https://github.com/albertz/mouse-scroll-wheel-acceleration-userspace";
    rev = "509bdfd60a53e7fceb20fbf9ad0b6ecf41ede5a6";
    sha256 = "11yc0npl543dcygyvldqzfnrxcxnngy4i0hqfsir71qn9sc5qrdw";
  };
  buildInputs = [ (python3.withPackages (ps: with ps; [ appdirs pynput better-exchook ])) ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/* $out/bin
    mv $out/bin/main.py $out/bin/wheel-accel
    chmod 555 $out/bin/wheel-accel
  '';
}
