##
##
##  per-host configuration for lenovo16
##
##

{ 
  system,
  modules,
  pkgs, 
  ... 
}: 

{
  entry = {
    boot = {
      inherit system modules;
      devNodes = "/dev/";
      bootDevices = [ 
        "nvme0n1" 
      ];
      immutable = false;
      hostId = "48b0a3d1";
      hostName = "xps13-bjasko";
      availableKernelModules = [
        "ahci" # for sata drive
        "nvme" # for nvme drive
        "uas" # for external usb drive
      ];
      partitionScheme = {
        efiBoot = "p5";
        bootPool = "p6";
        rootPool = "p7";
        swap = "p8";
        biosBoot = "p9";
      }; 
    };

  };
}
