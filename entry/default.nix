{ 
  inputs,
  config, 
  lib, 
  home-manager, 
  ... 
}: 

{
  lib = import ./lib.nix { 
    inherit inputs config lib home-manager; 
  };
}
