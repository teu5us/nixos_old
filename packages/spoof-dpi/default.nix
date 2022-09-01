{ buildGoModule, fetchurl, go }:

buildGoModule rec {
  pname = "SpoofDPI";
  version = "0.4";
  src = fetchurl {
    url = "https://github.com/xvzc/${pname}/archive/refs/tags/${version}.tar.gz";
    sha256 = "0kpm7ggva3c9pfbp2yzkwcmhjfx06siqfs1qy771k9b3h6674hfn";
  };
  vendorSha256 = "sha256-ib9xRklkLfrDCuLf7zDkJE8lJiNiUMPZ01MDxvqho6o=";
}
