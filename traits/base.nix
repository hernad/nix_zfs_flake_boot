/*
  A trait for all boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    time.timeZone = "Europe/Sarajevo";
    # Windows wants hardware clock in local time instead of UTC
    time.hardwareClockInLocalTime = true;

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "all" ];

    # https://stackoverflow.com/questions/54811067/how-can-i-install-extension-of-vscode

  environment.systemPackages = with pkgs;
    let
      inherit (pkgs) fetchurl;
      inherit (lib) makeLibraryPath;

      vcsodeWithExtension = vscode-with-extensions.override {
        # When the extension is already available in the default extensions set.
        vscodeExtensions = with vscode-extensions; [
          # nixpkgs/applications/editors/vscode/extensions/default.nix
          # bbenoist.nix = buildVscodeMarketplaceExtension { name = Nix ...
          # }
          bbenoist.nix
          bmalehorn.vscode-fish
          brettm12345.nixfmt-vscode
          bungcip.better-toml
          codezombiech.gitignore
          #denoland.vscode-deno
          dotjoshjohnson.xml
          ms-python.python
          #ms-vscode.cpptools-themes
          #Equinusocio.vsc-community-material-theme
          editorconfig.editorconfig
        ]
        # Concise version from the vscode market place when not available in the default set.
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "code-runner";
            publisher = "formulahendry";
            version = "0.12.0";
            sha256 = "43681cb9c946ecd2d1f351e32a3ff4445d2333912a7b6bd931ba6869ba7fa2c8";
          }
          {
            name = "cpptools-themes";
            publisher = "ms-vscode";
            version = "2.0.0";
            sha256 = "sha256-YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
          }
          {
            name = "vsc-community-material-theme";
            publisher = "Equinusocio";
            version = "1.4.6";
            sha256 = "sha256-DVgyE9CAB7m8VzupUKkYIu3fk63UfE+cqoJbrUbdZGw=";
          }
          {
            name = "noctis";
            publisher = "liviuschera";
            version = "10.40.0";
            sha256 = "sha256-UbGWorOVeitE9Q6tZ18h9K4Noz5Y3oaiuYaJtPzcwOc=";
          }
        ];
      };

      viberFetch = viber.overrideAttrs( attrOld: {
        src = fetchurl {
            url = "https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
            sha256 = "sha256-tjyvf1qjzznPO7YPreebo/CoqAn3fR/dfKuwT/Bm7/c=";
          };

        libPath = lib.makeLibraryPath [
              alsa-lib
              cups
              curl
              dbus
              expat
              fontconfig
              freetype
              glib
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-bad
              gst_all_1.gstreamer
              harfbuzz
              libopus
              libcap
              libGLU libGL
              libpulseaudio
              libxkbcommon
              libxml2
              libxslt
              libwebp
              snappy
              xorg.libxshmfence
              lcms2
              xorg.libxkbfile
              zstd
              libkrb5
              brotli
              nspr
              nss
              openssl_1_1
              stdenv.cc.cc
              systemd
              wayland
              zlib
              xorg.libICE
              xorg.libSM
              xorg.libX11
              xorg.libxcb
              xorg.libXcomposite
              xorg.libXcursor
              xorg.libXdamage
              xorg.libXext
              xorg.libXfixes
              xorg.libXi
              xorg.libXrandr
              xorg.libXrender
              xorg.libXScrnSaver
              xorg.libXtst
              xorg.xcbutilimage
              xorg.xcbutilkeysyms
              xorg.xcbutilrenderutil
              xorg.xcbutilwm
          ];  
      });

    in [
        vim
        remmina
        patchelf
        silver-searcher
        direnv
        nix-direnv
        git
        #python310Full
        #python310Packages.pip
        #python310Packages.setuptools
        #ansible
        jq
        fzf
        ripgrep
        lsof
        htop
        bat
        grex
        broot
        bottom
        fd
        sd
        fio
        hyperfine
        tokei
        bandwhich
        lsd
        #abduco
        #dvtm
        ntfs3g
        killall
        gptfdisk
        fio
        smartmontools
        rnix-lsp
        graphviz
        simple-http-server
        vcsodeWithExtension
        #viber
        #appimage-run
        xorg.xkbcomp
        viberFetch
        nixos-generators
        parprouted
  ];

    #environment.systemPackages = with pkgs; [
    #  # Shell utilities
    #  patchelf
    #  direnv
    #  nix-direnv
    #  git
    #  python310
    #  jq
    #  fzf
    #  ripgrep
    #  lsof
    #  htop
    #  bat
    #  grex
    #  broot
    #  bottom
    #  fd
    #  sd
    #  fio
    #  hyperfine
    #  tokei
    #  bandwhich
    #  lsd
    #  abduco
    #  dvtm
    #  #neovim-remote
    #  ntfs3g
    #  # nvme-cli
    #  # nvmet-cli
    #  # libhugetlbfs # This has a build failure.
    #  killall
    #  gptfdisk
    #  fio
    #  smartmontools
    #  neovimConfigured
    #  rnix-lsp
    #  graphviz
    #  simple-http-server
    #];

    environment.shellAliases = { };
    environment.variables = {
      EDITOR = "${pkgs.vim}/bin/vim";
    };
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];

    programs.bash.promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    programs.bash.shellInit = ''
    '';
    programs.bash.loginShellInit = ''
      HAS_SHOWN_NEOFETCH=''${HAS_SHOWN_NEOFETCH:-false}
      if [[ $- == *i* ]] && [[ "$HAS_SHOWN_NEOFETCH" == "false" ]]; then
        ${pkgs.neofetch}/bin/neofetch --config ${../config/neofetch/config}
        HAS_SHOWN_NEOFETCH=true
      fi
    '';
    programs.bash.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      source "${pkgs.fzf}/share/fzf/key-bindings.bash"
      source "${pkgs.fzf}/share/fzf/completion.bash"
    '';

    security.sudo.wheelNeedsPassword = false;
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    # Use edge NixOS.
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # nix.package = pkgs.nixUnstable;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    nixpkgs.config.allowUnfree = true;

    # Hack: https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.systemd-udevd.restartIfChanged = false;

    
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
