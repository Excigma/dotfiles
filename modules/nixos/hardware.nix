{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "hid-sensor-hub"
    ];
    initrd.kernelModules = [ "xe" ];
    kernelPackages = pkgs.unstable.linuxPackages;
    kernelModules = [
      "kvm-intel"
      "v4l2loopback"
      "snd-aloop"
    ];
    kernelParams = [
      "i915.force_probe=!a7a1"
      "xe.force_probe=a7a1"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 devices=1 card_label="Iriun Webcam,Iriun Webcam #2,Iriun Webcam #3,Iriun Webcam #4"
      options snd-aloop index=0
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
  };

  swapDevices = [ ];
}
