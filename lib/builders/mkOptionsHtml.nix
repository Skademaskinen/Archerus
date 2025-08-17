inputs:

let
    pkgs = inputs.lib.load inputs.nixpkgs;
    lib = pkgs.lib;
in options: root:

let
  # flatten recursive option sets into list of { path, value }
  flattenOptions = prefix: optSet:
    lib.concatMapAttrs
      (name: val:
        if lib.isAttrs val && val ? _type && val._type == "option"
        then {
          "${prefix}.${name}" = val;
        }
        else if lib.isAttrs val then
          flattenOptions "${prefix}.${name}" val
        else {}
      )
      optSet;

  allOptions = flattenOptions root options;

  html = ''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Nix Options</title>
      <style>
        body { font-family: sans-serif; margin: 2rem; }
        input { width: 100%; padding: 0.5rem; font-size: 1rem; margin-bottom: 1rem; }
        .option { margin-bottom: 1rem; }
        .path { font-weight: bold; }
        .desc { margin-left: 1rem; color: #555; }
      </style>
      <script>
        function filterOptions() {
          let input = document.getElementById("search").value.toLowerCase();
          let options = document.getElementsByClassName("option");
          for (let opt of options) {
            if (opt.textContent.toLowerCase().includes(input)) {
              opt.style.display = "block";
            } else {
              opt.style.display = "none";
            }
          }
        }
      </script>
    </head>
    <body>
      <input id="search" type="text" onkeyup="filterOptions()" placeholder="Search options..."/>
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList
        (path: opt:
          let
            desc = if opt ? description then opt.description else "";
            type = opt.type.name;
          in
            ''<div class="option">
              <div class="path">${lib.escapeXML path}</div>
              <div class="desc">${lib.escapeXML desc}</div>
              <div class="desc">Type: ${lib.escapeXML type}</div>
            </div>'')
        allOptions)}
    </body>
    </html>
  '';
in
    html

