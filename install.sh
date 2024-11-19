#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

curl https://raw.githubusercontent.com/dsriggs1/dotfiles/main/disko/btrfs-subvolumes.nix -o /tmp/btrfs-subvolumes.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/btrfs-subvolumes.nix --arg device '"/dev/vda"'

sudo nixos-generate-config --no-filesystems --root /mnt
cd /mnt/etc/nixos || exit 1
#nix-shell -p git --run "git clone https://github.com/dsriggs1/dotfiles"
sudo git clone https://github.com/dsriggs1/dotfiles
sudo git checkout install
sudo rm hardware-configuration.nix
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/dotfiles
sudo cp -r /mnt/etc/nixos /mnt/etc/persist
sudo rm -r /etc/nixos/*



#curl https://raw.githubusercontent.com/vimjoyer/impermanent-setup/main/final/disko.nix -o /tmp/disko.nix
#sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/vda"'
#nix-shell -p git
#sudo nixos-generate-config --no-filesystems --root /mnt
#sudo mv /tmp/disko.nix /mnt/etc/nixos/disko.nix
#nix flake init --template github:dsriggs1/dotfiles
#mv flake.nix /mnt/etc/nixos/flake.nix
#cp /mnt/etc/nixos /mnt/etc/persist
#nixos-install --root /mnt --flake /mnt/etc/nixos#default
#sudo rm -r /etc/nixos/*
#sudo nixos-rebuild boot --flake /persist/nixos#default
#reboot
