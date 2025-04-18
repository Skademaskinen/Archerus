 { config, ... }: 

 {
    home.file = {
        Documents.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Documents";
        Pictures.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Pictures";
        Downloads.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Downloads";
        git.source = config.lib.file.mkOutOfStoreSymlink "/data/files/git";
        Games.source = config.lib.file.mkOutOfStoreSymlink "/data/games";
    };
 }
