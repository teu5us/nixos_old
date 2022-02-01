{ config, pkgs, options, lib, ... }:

{
  security = {
    sudo.enable = true;

    # wrappers.spice-client-glib-usb-acl-helper = {
    #   source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
    #   capabilities = "cap_fowner+ep";
    # };
  };
}
