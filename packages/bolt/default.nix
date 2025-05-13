inputs:

with inputs.nixpkgs.legacyPackages.${inputs.system};

writeScriptBin "blot" ''
    #!${bash}/bin/bash
    echo "Hello, world! :-)"
''
