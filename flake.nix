{
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # stable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    # home-manager.url = "github:nix-community/home-manager/release-22.11";

    # unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    baseModules = [
              #home-manager.nixosModules.home-manager
              #traits.overlay
              #traits.base
              self.nixosModules.services.openssh
          ];
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      lib = nixpkgs.lib;
      entry = import ./entry { inherit inputs home-manager lib; };
    in {

    
      nixosConfigurations = 
      {

        lenovo16 = let
          # if aarch64, change to aarch64-linux
          # check with "uname -m" command
          #system = "x86_64-linux";
          inherit (x86_64Base) system;
          pkgs = nixpkgs.legacyPackages.${system};
        in entry.lib.mkHost (import ./hosts/lenovo16 { inherit system pkgs; });


        #tieling = let
        #  system = "aarch64-linux";
        #  pkgs = nixpkgs.legacyPackages.${system};
        #in entry.lib.mkHost (import ./hosts/tieling { inherit system pkgs; });
      };

      nixosModules = {
        services.openssh = ./services/openssh.nix;
      };

    };
}
