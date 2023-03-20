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
      entry = import ./entry { inherit inputs home-manager lib; };
    in {

    
      nixosConfigurations = 
      let
          # Shared config between both the liveimage and real system
          #aarch64Base = {
          #  system = "aarch64-linux";
          #  modules = with self.nixosModules; [
          #    ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
          #    home-manager.nixosModules.home-manager
          #    traits.overlay
          #    traits.base
          #    services.openssh
          #  ];
          #};
          x86_64Base = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              #home-manager.nixosModules.home-manager
              #traits.overlay
              #traits.base
              services.openssh
            ];
          };
        in
      
      {

        lenovo16 = let
          # if aarch64, change to aarch64-linux
          # check with "uname -m" command
          #system = "x86_64-linux";
          inherit (x86_64Base) system;
          modules = x86_64Base.modules ++ [
              #traits.workstation
              #traits.gnome
              #traits.jetbrains
              #users.hernad
          ];
          pkgs = nixpkgs.legacyPackages.${system};
        in entry.lib.mkHost (import ./hosts/lenovo16 { inherit system modules pkgs; });


        #tieling = let
        #  system = "aarch64-linux";
        #  pkgs = nixpkgs.legacyPackages.${system};
        #in entry.lib.mkHost (import ./hosts/tieling { inherit system pkgs; });
      };
    };
}
