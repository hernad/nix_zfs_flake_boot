{ lib,
  ... }:

let
    # https://lazamar.co.uk/nix-versions/
    # https://lazamar.github.io/download-specific-package-version-with-nix/

    # https://lazamar.co.uk/nix-versions/?package=pycharm-professional&version=2020.1&fullName=pycharm-professional-2020.1&keyName=jetbrains.pycharm-professional&revision=4426104c8c900fbe048c33a0e6f68a006235ac50&channel=nixos-22.11#instructions

  	#pkgsPyCharm = import (builtins.fetchGit {
    #    name = "pycharm 2021.1";
    #    url = "https://github.com/nixos/nixos-22.11/";
    #    ref = "refs/heads/nixos-22.11";
    #    rev = "4426104c8c900fbe048c33a0e6f68a006235ac50";
    #    allRefs = true;
    #}) {};

    config = {
       allowUnfree = true;
    };
    system = "x86_64-linux";
    pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/7cf5ccf1cdb2ba5f08f0ac29fc3d04b0b59a07e4.tar.gz";
        sha256 = "sha256:0wfaqjpi7bip86r2piqigqna1fx3m1d9riak4l3rm54lyjxprlpi";

    }) {
      inherit system config;
    };


in
{
  config = {
    environment.systemPackages = with pkgs; [
      #jetbrains.clion
      #jetbrains.datagrip
      jetbrains.pycharm-professional
    ];

    # CLion requires cargo-xlib.
    environment.noXlibs = lib.mkForce false;

    nixpkgs.config.allowUnfree = true;
  };
}
