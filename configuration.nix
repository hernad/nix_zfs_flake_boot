{ entry, inputs, pkgs, lib, ... }: 

{
  # load module config to here
  inherit entry;
  # Let 'nixos-version --json' know about the Git revision
  # of this flake.
  system.configurationRevision = if (inputs.self ? rev) then
    inputs.self.rev
  else
    #throw "refuse to build: git tree is dirty";
    "work";
    

  nix.settings.trusted-users = [
    "hernad"
    "root"
  ];

  nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1u"
  ];

  # nix-info -m
  # - system: `"x86_64-linux"`
  # - host os: `Linux 6.2.13, NixOS, 23.05 (Stoat), 23.05.20230502.1a411f2`
  # - multi-user?: `yes`
  # - sandbox: `relaxed`
  # - version: `nix-env (Nix) 2.13.3`
  # - channels(root): `"nixos"`
  # - channels(hernad): `"nixos"`
  # - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixos`



  system.stateVersion = "22.11";

  imports =
    [ "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix" ];

  #services.emacs = { enable = lib.mkDefault true; };
  #programs.neovim = {
  #  enable = lib.mkDefault true;
  #  viAlias = true;
  #  vimAlias = true;
  #};
  environment.systemPackages = with pkgs; [
      htop
      postgresql
      #openvswitch
   ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
   enable = true;
   pinentryFlavor = "curses";
   enableSSHSupport = true;
  };

}
