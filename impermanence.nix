{lib, ...}: {
  fileSystems."/persist".neededForBoot = true;

  # Rotate btrfs root subvolume on each boot; old roots are kept for 30 days
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/expressvpn"
      "/var/lib/jellyfin"
      "/var/lib/libvirt"
      "/etc/NetworkManager/system-connections"
      "/data/media/.state"
      "/data/media/library"
      # "/home/sean/Downloads"
      # "/home/sean/Downloads/dotfiles"

      {
        directory = "/var/lib/colord";
        user = "color";
        group = "colord";
        mode = "u=rwX,g=rX,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      #      "/etc/systemd/system/expressvpn.service"
      #{
      # file="/var/keys/secret_file";
      # parentDirectory = {mode="u=rwX,g=rX,o=";};
      #}
    ];
  };
}
