{ 
  inputs, 
  lib, 
  #home-manager, 
  ... 
}: 

{
  mkHost = { entry }:
    let
      system = entry.boot.system;
      baseModules = entry.boot.modules;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in lib.nixosSystem {
      inherit system;
      modules = [
        ../modules
        (import ../configuration.nix { inherit entry inputs pkgs lib; })
        #home-manager.nixosModules.home-manager
        #{
        #  home-manager.useGlobalPkgs = true;
        #  home-manager.useUserPackages = true;
        #}
      ] ++ baseModules;
    };
}
