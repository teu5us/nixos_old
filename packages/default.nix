self: super: {
  spoof-dpi = super.callPackage ./spoof-dpi {};
  dmenu = super.callPackage ./dmenu {};
  dwm = super.callPackage ./dwm {};
  st = super.callPackage ./st {};
}
