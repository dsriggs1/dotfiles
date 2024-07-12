{...}: {
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
}
