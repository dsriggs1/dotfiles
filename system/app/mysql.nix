{
  pkgs,
  userSettings,
  ...
}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = ["retrosheet"];
    ensureUsers = [
      {
        name = "sean";
        ensurePermissions = {
          "retrosheet.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # Allow user to run mariadb commands without password
  security.sudo.extraRules = [
    {
      users = [userSettings.username];
      commands = [
        {
          command = "${pkgs.mariadb}/bin/mariadb";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.mariadb}/bin/mysql";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.mariadb}/bin/mariadb-dump";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.mariadb}/bin/mysqldump";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Systemd service to automatically load retrosheet schema if tables don't exist
  systemd.services.retrosheet-schema-init = {
    description = "Initialize Retrosheet Database Schema";
    after = ["mysql.service" "mysql-ensure-users.service"];
    requires = ["mysql.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Wait for MySQL to be ready
      for i in {1..30}; do
        if ${pkgs.sudo}/bin/sudo -u mysql ${pkgs.mariadb}/bin/mariadb -e "SELECT 1;" &>/dev/null; then
          break
        fi
        sleep 1
      done

      # Check if tables exist (use sudo to run as mysql user for socket auth)
      TABLE_COUNT=$(${pkgs.sudo}/bin/sudo -u mysql ${pkgs.mariadb}/bin/mariadb retrosheet -e "SHOW TABLES;" 2>/dev/null | wc -l)

      if [ "$TABLE_COUNT" -eq 0 ]; then
        echo "Loading retrosheet schema..."
        ${pkgs.sudo}/bin/sudo -u mysql ${pkgs.mariadb}/bin/mariadb retrosheet < ${userSettings.homeDir}/Github/retrosheet/load/retrosheet_table_schema.sql
        echo "Retrosheet schema loaded successfully"
      else
        echo "Retrosheet tables already exist, skipping initialization"
      fi
    '';
  };
}
