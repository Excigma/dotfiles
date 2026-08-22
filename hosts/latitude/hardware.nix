{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    sensor.iio.enable = true;
    logitech.wireless = {
      enableGraphical = true;
      enable = true;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-ocl
        intel-compute-runtime
        intel-media-driver # opengl, vulkan, vaapi
        vpl-gpu-rt
      ];
    };

    firmware = [
      (pkgs.writeTextDir "/lib/firmware/hda-jack-retask.fw" (builtins.readFile "${self}/etc/firmware/hda-jack-retask.fw"))
    ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "hid-sensor-hub"
    ];
    initrd.kernelModules = [
      "xe"
      "lz4"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-intel"
      "snd-aloop"
    ];
    kernelParams = [
      "zswap.enabled=0"
    ];
    extraModprobeConfig = ''
      options snd-hda-intel patch=hda-jack-retask.fw
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d1ed8f8e-7a95-4cc3-a36e-186e62b6d109";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/126C-B207";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/media" = {
      device = "/dev/disk/by-uuid/3af7cc7f-1ac0-4d87-bcbc-0f4c459bafdb";
      fsType = "btrfs";
      options = [ "noatime" ];
    };
  };

  swapDevices = [ ];

  services = {
    thermald.enable = true;
    fstrim.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "suspend";
    };
  };

  # Route bass speaker pin (0x17) onto amplified DAC (0x03);
  systemd = {
    services.hda-dac-fix = {
      description = "Route bass speaker pin to amplified DAC";
      after = [ "sound.target" ];
      wantedBy = [ "sound.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.alsaTools}/bin/hda-verb /dev/snd/hwC1D0 0x17 0x701 1";
      };
    };
  };

  # Hardware utilities
  environment.systemPackages = with pkgs; [
    alsaTools
    intel-gpu-tools
    intel-undervolt
    libsmbios
    logitech-udev-rules
    pciutils
    qmassa
    smartmontools
    solaar
    usbutils
  ];
}
