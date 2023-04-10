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
      enable = true;
      bootDevices = [ 
        "nvme0n1" 
      ];
      immutable = false;
      hostId = "22b0a3d0";
      hostName = "yoga15";
      availableKernelModules = [
        "ahci" # for sata drive
        "nvme" # for nvme drive
        "uas" # for external usb drive
      ];
      partitionScheme = {
        efiBoot = "p4";
        bootPool = "p5";
        rootPool = "p6";
        swap = "p7";
        #biosBoot = "p8";
      }; 
    };

  };
}
