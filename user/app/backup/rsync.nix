{
  lib,
  pkgs,
  userSettings,
  isNixOS,
  ...
}: let

  backupHost = "sean-work";

  backupDirs = [
    "Books"
    "Desktop"
    "Documents"
    "Music"
    "Pictures"
    "Videos"
  ];

  restoreScript = pkgs.writeShellScriptBin "rsync-restore" ''
    set -euo pipefail

    HOST="${backupHost}"

    echo "[rsync-restore] Restoring from $HOST..."

    ${lib.concatMapStrings (dir: ''
      echo "[rsync-restore] Restoring ${dir}..."
      ${pkgs.rsync}/bin/rsync -avz \
        -e "${pkgs.openssh}/bin/ssh -o ConnectTimeout=10" \
        --mkpath \
        "$HOST:${userSettings.homeDir}/${dir}/" \
        "$HOME/${dir}/" \
        || { echo "[rsync-restore] WARNING: ${dir} restore failed"; }
    '') backupDirs}

    echo "[rsync-restore] Restore complete."
  '';

  rsyncScript = pkgs.writeShellScript "rsync-backup" ''
    set -euo pipefail

    HOST="${backupHost}"
    MAX_ATTEMPTS=3
    RETRY_DELAY=300  # 5 minutes between retries

    run_backup() {
      FAILED=0

      ${lib.concatMapStrings (dir: ''
        if [ -d "$HOME/${dir}" ]; then
          echo "[rsync-backup] Syncing ${dir}..."
          ${pkgs.rsync}/bin/rsync -avz \
            -e "${pkgs.openssh}/bin/ssh -o ConnectTimeout=10" \
            --mkpath \
            "$HOME/${dir}/" \
            "$HOST:${userSettings.homeDir}/${dir}/" \
            || { echo "[rsync-backup] WARNING: ${dir} sync failed"; FAILED=1; }
        else
          echo "[rsync-backup] Skipping ${dir} (directory does not exist)"
        fi
      '') backupDirs}

      return $FAILED
    }

    for attempt in $(seq 1 $MAX_ATTEMPTS); do
      echo "[rsync-backup] Attempt $attempt of $MAX_ATTEMPTS..."
      if run_backup; then
        echo "[rsync-backup] Backup completed successfully."
        exit 0
      fi

      if [ "$attempt" -lt "$MAX_ATTEMPTS" ]; then
        echo "[rsync-backup] Retrying in $((RETRY_DELAY / 60)) minutes..."
        sleep $RETRY_DELAY
      fi
    done

    echo "[rsync-backup] Backup failed after $MAX_ATTEMPTS attempts." >&2
    exit 1
  '';
in
  lib.mkIf isNixOS {
    home.packages = [restoreScript];

    systemd.user.services.rsync-backup = {
      Unit = {
        Description = "One-way rsync backup to ${backupHost}";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${rsyncScript}";
      };
    };

    systemd.user.timers.rsync-backup = {
      Unit = {
        Description = "Hourly rsync backup timer";
      };
      Timer = {
        OnCalendar = "hourly";
        Persistent = true;
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  }
