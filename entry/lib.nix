{ 
  inputs,
  lib, 
  home-manager,
  nur-no-pkgs,
  ... 
}: 

{
  mkHost = { entry }:
    let
      hostName = entry.boot.hostName;
      system = entry.boot.system;
      baseModules = entry.boot.modules;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in lib.nixosSystem {
      inherit system;
      modules = [
        ../modules
        (import ../configuration.nix { inherit entry inputs pkgs lib nur-no-pkgs; })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ] ++ baseModules;
    };
}
