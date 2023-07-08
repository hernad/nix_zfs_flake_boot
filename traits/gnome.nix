/*
  A trait for headed boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    services.xserver.enable = true;
    #services.xserver = {
    #  layout = "us,ba";
    #  xkbVariant = "workman,";
    ##  xkbOptions = "grp:win_space_toggle";
    #};
    services.xserver.layout = "bs";
    services.xserver.exportConfiguration = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.autoLogin.enable = false;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = (with pkgs; [
      #gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gedit # text editor
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]);

    environment.systemPackages = with pkgs.gnome; [
      gnome-tweaks
      gnome-characters
      gnome-screenshot
      gnome-control-center
      #gnome-terminal
      pkgs.localsend
    ];

    networking.firewall.allowedTCPPorts = [ 53317 ];

    services.gnome.gnome-keyring.enable = true;

    programs.dconf.enable = true;

    fileSystems."/usr/share/X11" = {
     device = "${pkgs.xkeyboard_config}/share/X11";
     options = [ "bind" ];
    };
  };

  
}

