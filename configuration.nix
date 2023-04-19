{ entry, inputs, pkgs, lib, nur-no-pkgs, ... }: 

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
      openvswitch
      nur-no-pkgs.repos.iagocq.parprouted
   ];
}
