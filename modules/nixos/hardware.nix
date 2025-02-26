{ config, lib, ... }: {
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" "v4l2loopback" "snd-aloop" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d1ed8f8e-7a95-4cc3-a36e-186e62b6d109";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/126C-B207";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [ ];
}
