#!/usr/bin/env bash

if [ -z "${1}" ] ; then
  echo "navedi masinu npr. lenovo16"
  exit 1
fi

# error: Package ‘openssl-1.1.1u’ in /nix/store/2xv3665ir48dzi2vvfv3h3kb995ip3is-source/pkgs/development/libraries/openssl/default.nix:210 is marked as insecure, refusing to evaluate.


sudo nixos-rebuild --flake .#${1} switch --show-trace
