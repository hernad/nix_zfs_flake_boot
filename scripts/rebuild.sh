#!/usr/bin/env bash

if [ -z "${1}" ] ; then
  echo "navedi masinu npr. lenovo16"
  exit 1
fi

sudo nixos-rebuild --flake .#${1} switch
