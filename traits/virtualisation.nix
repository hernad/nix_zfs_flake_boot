/*
  A trait for configurations which are most definitely machines
*/
{ config, pkgs, ... }:

{
  config = {
    boot.kernel.sysctl = {
      # TCP Fast Open (TFO)
      "net.ipv4.tcp_fastopen" = 3;
    };
    boot.initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "virtio_blk"
      "ehci_pci"
      "nvme"
      "uas"
      "sd_mod"
      "sr_mod"
      "sdhci_pci"
    ];
    boot.kernelModules = [
      "coretemp"
      "vfio-pci"
      "i2c-dev"
      "i2c-piix"
    ];
   
    boot.binfmt.emulatedSystems = (if pkgs.stdenv.isx86_64 then [
      "aarch64-linux"
    ] else if pkgs.stdenv.isAarch64 then [
      "x86_64-linux"
    ] else [ ]);

    # http://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
    # security.pam.u2f.enable = true;
    # security.pam.u2f.cue = true;
    # security.pam.u2f.control = "optional";
    boot.initrd.systemd.enable = true;
    # boot.initrd.luks.fido2Support = true;
    boot.initrd.luks.mitigateDMAAttacks = true;

    environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    environment.systemPackages = with pkgs; [
      i2c-tools
    ];

    users.mutableUsers = false;

    powerManagement.cpuFreqGovernor = "ondemand";

    #networking.networkmanager.enable = true;
    #networking.wireless.enable = false; # For Network Manager
    #networking.firewall.enable = true;
    
    # For libvirt: https://releases.nixos.org/nix-dev/2016-January/019069.html
    networking.firewall.checkReversePath = false;

    programs.nm-applet.enable = true;

    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    
    #services.tailscale.enable = true;

    security.rtkit.enable = true;

    hardware.pulseaudio.enable = false;
    hardware.i2c.enable = true;
    hardware.hackrf.enable = true;
    hardware.bluetooth.enable = true;

    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.onBoot = "ignore";
    virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
    virtualisation.libvirtd.qemu.ovmf.enable = true;
    virtualisation.libvirtd.qemu.ovmf.packages = if pkgs.stdenv.isx86_64 then [ pkgs.OVMFFull.fd ] else [ pkgs.OVMF.fd ];
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.libvirtd.qemu.swtpm.package = pkgs.swtpm;
    virtualisation.libvirtd.qemu.runAsRoot = false;
    virtualisation.spiceUSBRedirection.enable = true; # Note that this allows users arbitrary access to USB devices. 
    virtualisation.podman.enable = true;

    
  };
}
