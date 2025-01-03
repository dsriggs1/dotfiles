{...}: {
  fileSystems."/persist".neededForBoot = true;
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
