#!/bin/bash

sudo su

curl https://raw.githubusercontent.com/vimjoyer/impermanent-setup/main/final/disko.nix -o /tmp/disko.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/vda"'
nix-shell -p git
sudo nixos-generate-config --no-filesystems --root /mnt
sudo mv /tmp/disko.nix /mnt/etc/nixos/disko.nix
nix flake init --template github:dsriggs1/dotfiles
mv flake.nix /mnt/etc/nixos/flake.nix
cp /mnt/etc/nixos /mnt/etc/persist
nixos-install --root /mnt --flake /mnt/etc/nixos#default
sudo rm -r /etc/nixos/*
sudo nixos-rebuild boot --flake /persist/nixos#default
reboot
