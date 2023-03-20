##
##
##  per-host configuration for lenovo16
##
##

{ 
  system,
  pkgs, 
  ... 
}: 

{
  entry = {
    boot = {
      inherit system;
      devNodes = "/dev/";
      bootDevices = [ 
        "nvme0n1" 
      ];
      immutable = false;
      hostId = "38bdc3d4";
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
