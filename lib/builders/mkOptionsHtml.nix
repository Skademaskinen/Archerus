inputs:

let
    pkgs = inputs.lib.load inputs.nixpkgs;
    lib = pkgs.lib;
in options:

let
  docList = lib.optionAttrSetToDocList options;

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
        .path { font-weight: bold; font-size: 1.1rem; }
        .desc { margin-left: 1rem; color: #555; }
        .data { margin-left: 2rem; }
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
      ${lib.concatStringsSep "\n" (map
        (option:
          let
            desc = if option ? description then option.description else "";
          in
            ''<div class="option">
                <div class="path">${lib.escapeXML option.name}</div>
                <div class="desc">${lib.escapeXML desc}</div>
                <ul>
                    <li>Type: ${lib.escapeXML option.type}</li>
                    <li>Default: ${lib.escapeXML option.default.text}</li>
                </ul>
                <b>Declared in:</b><br>
                <ul>
                    ${builtins.toString (map (d: "<li>${lib.escapeXML d}</li>") option.declarations)}
                </ul>
            </div>'')
        docList)}
    </body>
    </html>
  '';
in
    html

