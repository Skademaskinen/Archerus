{pkgs, ...}: 

let
    env = pkgs.callPackage ../packages/backend.nix {};
in {
  systemd.services.backend = {
    enable = true;
    description = "mast3r_waf1z website database server";
		environment = {
			SQLITE3_PATH = "${pkgs.sqlite-interactive}/bin/sqlite3";
			LSBLK_PATH = "${pkgs.util-linux}/bin/lsblk";
		};
    serviceConfig = {
      User = "mast3r";
      WorkingDirectory = "/mnt/raid/webroot/admin/Backend";
      ExecStart = "${pkgs.bash}/bin/bash ${env}/bin/skademaskinen-backend -db /mnt/raid/webroot/admin/db.db3 --hostname localhost --port 12345 --keyfile /mnt/raid/webroot/admin/keyfile";
      Restart = "on-failure";
    };
    wantedBy = ["default.target"];
  };
}
