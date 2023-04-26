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
    
    #nur.url = github:nix-community/NUR;


  };

  outputs = { self, nixpkgs, home-manager, nur }@inputs:
  #outputs = { self, nixpkgs, home-manager }@inputs:
    let
      lib = nixpkgs.lib;

    
      entry = import ./entry { inherit inputs lib home-manager; };
      supportedSystems = [ 
          "x86_64-linux" 
          #"aarch64-linux" 
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

    in {

      #defaultPackage.x86_64-linux =
      #  # Notice the reference to nixpkgs here.
      #  with import nixpkgs { system = "x86_64-linux"; };
      #  import ./parprouted;
      #

      overlays.default = final: prev: {
        #neovimConfigured = final.callPackage ./packages/neovimConfigured { };
        #fix-vscode = final.callPackage ./packages/fix-vscode { };
        parprouted = final.callPackage ./packages/parprouted { };
        test-shell = final.callPackage ./packages/test-shell {};
        
      };

      packages = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
              config.allowUnfree = true;
            };
          in
          {
            inherit (pkgs) test-shell parprouted;
  
            # Excluded from overlay deliberately to avoid people accidently importing it.
            #unsafe-bootstrap = pkgs.callPackage ./packages/unsafe-bootstrap { };
          });


      devShells = forAllSystems
          (system:
            let
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ self.overlays.default ];
              };
            in
            {
              default = pkgs.mkShell
                {
                  inputsFrom = with pkgs; [ ];
                  buildInputs = with pkgs; [
                    nixpkgs-fmt
                  ];
                };
            });

      homeConfigurations = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          in
          {
            hernad = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./users/hernad/home.nix
              ];
            };
          }
        );

      nixosConfigurations =
        let
          x86_64Base = {
                system = "x86_64-linux";
                modules = with self.nixosModules; [
                  ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
                  home-manager.nixosModules.home-manager
                  traits.overlay
                  traits.base
                  services.openssh
                ];
              };
        in
        with self.nixosModules;
        {
          x86_64IsoImage = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.iso
            ];
          };

          lenovo16 = let
            # if aarch64, change to aarch64-linux
            # check with "uname -m" command
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
                #({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
                traits.overlay
                traits.base
                traits.gnome
                traits.workstation
                traits.jetbrains
                traits.virtualisation
                services.openssh
                users.hernad
                #nur.nixosModules.nur
                services.paperless
            ];
          in entry.lib.mkHost (import ./hosts/lenovo16 { inherit system modules pkgs; });

          xps13 = let
            # if aarch64, change to aarch64-linux
            # check with "uname -m" command
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
                #({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
                traits.overlay
                traits.base
                traits.gnome
                traits.workstation
                #traits.jetbrains
                traits.virtualisation
                services.openssh
                users.bjasko
                #nur.nixosModules.nur
            ];
          in entry.lib.mkHost (import ./hosts/xps13 { inherit system modules pkgs; });

          yoga15 = let
            # if aarch64, change to aarch64-linux
            # check with "uname -m" command
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
                #({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
                traits.overlay
                traits.base
                traits.gnome
                traits.workstation
                #traits.jetbrains
                traits.virtualisation
                services.openssh
                users.hernad
                #nur.nixosModules.nur
            ];
          in entry.lib.mkHost (import ./hosts/yoga15 { inherit system modules pkgs; });

          #tieling = let
          #  system = "aarch64-linux";
          #  pkgs = nixpkgs.legacyPackages.${system};
          #in entry.lib.mkHost (import ./hosts/tieling { inherit system pkgs; });
        };

      nixosModules = {
        services.openssh = ./services/openssh.nix;
        services.paperless = ./services/paperless.nix;
        traits.base = ./traits/base.nix;
        traits.workstation = ./traits/workstation.nix;
        traits.gnome = ./traits/gnome.nix;
        traits.jetbrains = ./traits/jetbrains.nix;
        traits.virtualisation = ./traits/virtualisation.nix;
        traits.sourceBuild = ./traits/source-build.nix;
        users.hernad = ./users/hernad;
        users.bjasko = ./users/bjasko;
        platforms.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
      };

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          format = pkgs.runCommand "check-format"
            {
              buildInputs = with pkgs; [ rustfmt cargo ];
            } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out # it worked!
          '';
        });


    };
}
