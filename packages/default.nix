self: super: {
  spoof-dpi = super.callPackage ./spoof-dpi {};
  dmenu = super.callPackage ./dmenu {};
}
