{pkgs, lib, config, ...}: {
    options.skademaskinen.jupyter.port = lib.mkOption {
        type = lib.types.int;
        default = 30000;
    };

    config.users.users.jupyter = {
        isSystemUser = true;
        group = "jupyter";
    };

    config.services.jupyter = {
        enable = true;
        notebookDir = "${config.skademaskinen.storage}/jupyter";
        port = config.skademaskinen.jupyter.port;
        password = "'$6$0uh7dpBCT0SdcFRU$nAEFSbj0WAqlbrlJHSnXislC6TERXuZj0hHqCH9zai3henKMvGjTpdcHDQUQqS1YZ/vfZ3H9XcZogolneS9Jf0'";

    };
}
