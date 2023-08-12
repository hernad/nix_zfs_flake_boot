/*
  A trait for headed boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    #hardware.video.hidpi.enable = true;
    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;
    hardware.opengl.extraPackages = with pkgs; [ libvdpau vdpauinfo libvdpau-va-gl ];

    #hardware.steam-hardware.enable = true;
    #hardware.xpadneo.enable = true;

    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      # A definition for option `fonts.fontconfig.hinting.style' is not of type `one of "none", "slight", "medium", "full"'. Definition values:

      hinting.style = "full";
    };

    fonts.enableDefaultFonts = true;
    fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      fira-code-symbols
    ];

    # These should only be GUI applications that are desired systemwide
    environment.variables = {
      # VDPAU_DRIVER = "radeonsi";
    };
    environment.systemPackages = with pkgs; [
      virt-manager
      openrgb
      libva-utils
      vdpauinfo
      ffmpeg
      openrgb
      vim
      #neovimConfigured
    ];

    services.udev.packages = with pkgs; [ openrgb ];
    services.printing.enable = true;
  };
}

