{ 
  inputs,
  lib, 
  home-manager,
  nur-no-pkgs, 
  ... 
}: 

{
  lib = import ./lib.nix { 
    inherit inputs lib home-manager nur-no-pkgs; 
  };
}
