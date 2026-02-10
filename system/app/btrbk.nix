{ config, lib, pkgs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [ btrbk ];

  # Auto-generate SSH key for btrbk if it doesn't exist
  systemd.services.btrbk-ssh-keygen = {
    description = "Generate SSH key for btrbk backups";
    wantedBy = [ "multi-user.target" ];
    before = [ "btrbk-home-backup.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      SSH_KEY="/root/.ssh/btrbk_backup_key"

      if [ ! -f "$SSH_KEY" ]; then
        echo "Generating btrbk SSH key..."
        mkdir -p /root/.ssh
        chmod 700 /root/.ssh
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "btrbk@${config.networking.hostName}"
        echo "✓ SSH key generated at $SSH_KEY"
        echo ""
        echo "================================================"
        echo "IMPORTANT: Add this public key to your backup server"
        echo "================================================"
        cat "$SSH_KEY.pub"
        echo "================================================"
      fi
    '';
  };

  # Create .ssh/config for btrbk to avoid host key verification issues
  systemd.tmpfiles.rules = [
    "d /root/.ssh 0700 root root -"
  ];

  environment.etc."root-ssh-config" = {
    target = "root/.ssh/config";
    text = ''
      Host backup-server backup-server.local
        HostName backup-server.local
        User backup
        IdentityFile /root/.ssh/btrbk_backup_key
        StrictHostKeyChecking accept-new
    '';
  };

  services.btrbk = {
    instances = {
      home-backup = {
        # Run daily at 11 PM
        onCalendar = "daily";

        settings = {
          # Snapshot directory
          snapshot_dir = ".snapshots";

          # Always create snapshots even if send fails
          snapshot_create = "always";

          # Retention on SOURCE (main computer)
          snapshot_preserve_min = "2d";
          snapshot_preserve = "7d 4w";  # 7 daily, 4 weekly

          # Retention on DESTINATION (backup server)
          target_preserve_min = "no";
          target_preserve = "14d 8w 12m 5y";  # Keep more on backup

          # SSH settings
          ssh_identity = "/root/.ssh/btrbk_backup_key";
          ssh_user = "backup";

          # Compression during transfer (reduces bandwidth)
          stream_compress = "zstd";
          stream_compress_level = "3";

          # Lockfile to prevent concurrent runs
          lockfile = "/var/lock/btrbk.lock";

          # Volume: backup entire home directory
          volume."/home" = {
            subvolume."${userSettings.username}" = {
              # Target on backup server
              target = "ssh://backup-server.local/mnt/backups/home-${userSettings.username}";
            };
          };
        };
      };
    };
  };

  # Allow btrbk to run btrfs commands without password
  security.sudo.extraRules = [
    {
      users = [ "btrbk" ];
      commands = [
        {
          command = "${pkgs.btrfs-progs}/bin/btrfs";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Helpful aliases for managing backups
  environment.shellAliases = {
    backup-run = "sudo systemctl start btrbk-home-backup.service";
    backup-status = "sudo systemctl status btrbk-home-backup.service";
    backup-logs = "sudo journalctl -u btrbk-home-backup.service -n 50";
    backup-list = "sudo btrbk list snapshots";
    backup-key = "sudo cat /root/.ssh/btrbk_backup_key.pub";
  };
}
