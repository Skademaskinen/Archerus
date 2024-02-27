{config,lib,pkgs,modulesPath,...}:{
	systemd.services.wordcount = {
		description = "Wordcount bot";
		environment = {
			XELATEX_PATH = "${pkgs.texliveFull}/bin/xelatex";
			BASH_PATH = "${pkgs.bash}/bin/bash";
			SQLITE3_PATH = "${pkgs.sqlite}/bin/sqlite3";
			PYTHON_EXE_PATH = "${pkgs.python3}/bin/python";
		};
		serviceConfig = {
			WorkingDirectory = "/mnt/raid/wordcount";
			User = "mast3r";
			ExecStart = "${pkgs.gradle}/bin/gradle run -Dorg.gradle.java.home=${pkgs.jdk21}/lib/openjdk";
		};
		wantedBy = ["default.target"];
		after = ["network-online.target"];
		wants = ["network-online.target"];
	};
	systemd.services.wordcount.enable = true;
}
