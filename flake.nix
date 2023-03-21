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


  };

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      lib = nixpkgs.lib;
      entry = import ./entry { inherit inputs lib home-manager; };
    in {

    
      nixosConfigurations =
      with self.nixosModules;
      {

        lenovo16 = let
          # if aarch64, change to aarch64-linux
          # check with "uname -m" command
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
              #({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              traits.base
              traits.gnome
              traits.workstation
              traits.jetbrains
              traits.virtualisation
              services.openssh
              users.hernad
          ];
        in entry.lib.mkHost (import ./hosts/lenovo16 { inherit system modules pkgs; });


        #tieling = let
        #  system = "aarch64-linux";
        #  pkgs = nixpkgs.legacyPackages.${system};
        #in entry.lib.mkHost (import ./hosts/tieling { inherit system pkgs; });
      };

      nixosModules = {
        services.openssh = ./services/openssh.nix;
        traits.base = ./traits/base.nix;
        traits.workstation = ./traits/workstation.nix;
        traits.gnome = ./traits/gnome.nix;
        traits.jetbrains = ./traits/jetbrains.nix;
        traits.virtualisation = ./traits/virtualisation.nix;
        traits.sourceBuild = ./traits/source-build.nix;
        users.hernad = ./users/hernad;
      };


    };
}
