{ config, pkgs, options, lib, ... }:

{
  boot = {
    kernelParams = [
      "quiet"
      "loglevel=3"
      "consoleblank=0"
      "pcie_aspm=force"
      # "acpi_osi="
      "acpi_osi=!"
      "acpi_osi=\"Windows 2009\""
      "usbcore.autosuspend=0"
      "intel_iommu=on"
      "iommu=pt"
    ];

    supportedFilesystems = [ "ntfs" "exfat" ];

    initrd.kernelModules = [ "atkbd" ];

    kernelModules = [
      "acpi_call" "intel_agp" "i915" "uinput" "kvmgt" "vfio-iommu-type1" "mdev"
    ];

    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

    extraModprobeConfig = ''
      options i915 modeset=1 enable_fbc=1 enable_dc=2 enable_psr=1 fastboot=1 enable_dpcd_backlight=3 enable_guc=0 enable_gvt=1
      options drm vblankoffdelay=1
      options snd_hda_intel power_save=1
      options iwlwifi power_save=1 power_level=5 swcrypto=0 uapsd_disable=0 d0i3_disable=0
      options iwlmvm power_scheme=3
      options thinkpad_acpi fan_control=1
      options kvm ignore_msrs=1
    '';

    kernel.sysctl = {
      # change ttl
      "net.ipv4.ip_default_ttl" = 65;
      # NETWORK
      "net.core.somaxconn" = 4096;
      "net.core.rmem_default" = 31457280;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_default" = 31457280;
      "net.core.wmem_max" = 16777216;
      "net.core.optmem_max" = 25165824;
      "net.ipv4.tcp_mem" = "65536 131072 262144";
      "net.ipv4.udp_mem" = "65536 131072 262144";
      "net.ipv4.tcp_rmem" = "8192 87380 16777216";
      "net.ipv4.udp_rmem_min" = 16384;
      "net.ipv4.tcp_wmem" = "8192 65536 16777216";
      "net.ipv4.udp_wmem_min" = 16384;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_fastopen" = 3;
      # "net.core.default_qdisc" = "fq";
      # "net.ipv4.tcp_congestioncontrol" = "bbr";
      "net.ipv4.tcp_congestion_control" = "cubic";
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.ip_no_pmtu_disc" = 0;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_sack" = 1;
      "net.ipv4.tcp_fack" = 1;
      "net.ipv4.tcp_window_scaling" = 1;
      "net.ipv4.tcp_workaround_signed_windows" = 1;
      "net.ipv4.tcp_timestamps" = 1;
      "net.ipv4.tcp_ecn" = 0;
      "net.ipv4.route.flush" = 1;
      "net.ipv4.tcp_low_latency" = 1;
      "net.ipv4.tcp_frto" = 2;
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;
      "net.ipv6.conf.lo.disable_ipv6" = 1;
      "net.ipv6.conf.wlp3s0.disable_ipv6" = 1;
      "net.ipv6.conf.enp0s25.disable_ipv6" = 1;

      # VM
      "vm.swappiness" = 3;
      "vm.vfs_cache_pressure" = 50;
      "vm.watermark_scale_factor" = 200;
      "vm.dirty_ratio" = 3;
      "vm.dirty_background_ratio" = 3;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.laptop_mode" = 5;
    };
  };
}
