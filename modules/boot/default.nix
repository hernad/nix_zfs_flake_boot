{ config, 
  lib, 
  ... 
}:

with lib;

let cfg = config.entry.boot;

in {
  #imports = [ ./grub-for-arm64/grub.nix ];
  options.entry.boot = {
    enable = mkOption {
      description = "Enable root on ZFS support";
      type = types.bool;
      default = true;
    };
    devNodes = mkOption {
      description = "Specify where to discover ZFS pools";
      type = types.str;
      apply = x:
        assert (strings.hasSuffix "/" x
          || abort "devNodes '${x}' must have trailing slash!");
        x;
      default = "/dev/disk/by-id/";
    };
    hostId = mkOption {
      description = "Set host id";
      type = types.str;
      default = "4e98920d";
    };
    hostName = mkOption {
      description = "Set hostName";
      type = types.str;
      default = "nixos";
    };
    bootDevices = mkOption {
      description = "Specify boot devices";
      type = types.nonEmptyListOf types.str;
      default = [ "ata-foodisk" ];
    };
    availableKernelModules = mkOption {
      type = types.nonEmptyListOf types.str;
      default = [ "uas" "nvme" "ahci" ];
    };
    immutable = mkOption {
      description = "Enable root on ZFS immutable root support";
      type = types.bool;
      default = false;
    };
    partitionScheme = mkOption {
      default = {
        efiBoot = "p5";
        bootPool = "p6";
        rootPool = "p7";
        swap = "p8";
        biosBoot = "p9";
      };
      description = "Describe on disk partitions";
      type = with types; attrsOf types.str;
    };
    system = mkOption {
      description = "Set system architecture";
      type = types.str;
      default = "x86_64-linux";
    };
    modules = mkOption {
      description = "default modules";
      type = types.listOf types.str;
      default = [];
    };
  };
  config = mkIf (cfg.enable) (mkMerge [
    {
      entry.fileSystems = {
        datasets = {
          "rpool/nixos/home" = mkDefault "/home";
          "rpool/nixos/var/log" = mkDefault "/var/log";
          "rpool/nixos/nix" = mkDefault "/nix";
          "bpool/nixos/root" = "/boot";
        };
      };
    }
    (mkIf (!cfg.immutable) {
      entry.fileSystems = { 
          datasets = { 
             "rpool/nixos/root" = "/"; 
          }; 
      };
    })
    (mkIf cfg.immutable {
      entry.fileSystems = {
        datasets = {
          "rpool/nixos/empty" = "/";
          "rpool/nixos/root" = "/oldroot";
        };
        bindmounts = {
          "/oldroot/nix" = "/nix";
          "/oldroot/etc/nixos" = "/etc/nixos";
        };
      };
      boot.initrd.postDeviceCommands = ''
        if ! grep -q zfs_no_rollback /proc/cmdline; then
          zpool import -N rpool
          zfs rollback -r rpool/nixos/empty@start
          zpool export -a
        fi
      '';
    })
    {
      entry.fileSystems = {
        efiSystemPartitions =
          (map (diskName: diskName + cfg.partitionScheme.efiBoot)
            cfg.bootDevices);
        swapPartitions =
          (map (diskName: diskName + cfg.partitionScheme.swap) cfg.bootDevices);
      };
      networking = {
        hostId = cfg.hostId;
        hostName = cfg.hostName;
      };
      nix.settings.experimental-features = mkDefault [ "nix-command" "flakes" ];
      programs.git.enable = true;
      boot = {
        initrd.availableKernelModules = cfg.availableKernelModules;
        tmpOnTmpfs = mkDefault true;
        kernelPackages =
          mkDefault config.boot.zfs.package.latestCompatibleLinuxPackages;
        supportedFilesystems = [ "zfs" ];
        zfs = {
          devNodes = cfg.devNodes;
          forceImportRoot = false;
        };
        loader = {
          efi = {
            canTouchEfiVariables = false;
            efiSysMountPoint = with builtins;
              ("/boot/efis/" + (head cfg.bootDevices)
                + cfg.partitionScheme.efiBoot);
          };
          generationsDir.copyKernels = true;
          systemd-boot.enable = true;
          grub = {
            #systemd-boot.enable = true;
            devices = (map (diskName: cfg.devNodes + diskName) cfg.bootDevices);
            efiInstallAsRemovable = true;
            version = 2;
            enable = true;
            copyKernels = true;
            efiSupport = true;
            zfsSupport = true;
            extraInstallCommands = with builtins;
              (toString (map (diskName: ''
                cp -r ${config.boot.loader.efi.efiSysMountPoint}/EFI /boot/efis/${diskName}${cfg.partitionScheme.efiBoot}
              '') (tail cfg.bootDevices)));
          };
        };

      };
    }
    #(mkIf (cfg.system == "aarch64-linux") {
    #  entry.aarch64Grub = {
    #    devices = [ "nodev" ];
    #    efiInstallAsRemovable = true;
    #    # used patched grub for arm64
    #    enable = true;
    #    version = 2;
    #    copyKernels = true;
    #    efiSupport = true;
    #    zfsSupport = true;
    #    extraInstallCommands = config.boot.loader.grub.extraInstallCommands;
    #  };
    #})
    #(mkIf (cfg.system != "aarch64-linux") { 
    #  boot.loader.grub.enable = true; 
    #})
  ]);
}
