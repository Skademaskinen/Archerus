{ lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
    env = pkgs.python312.withPackages (py: with py; [

    ]);
in

{ pages ? { "" = pkgs.writeText "index.html" ''<h1>Hello world!</h1><br><a href="/test">test</a>''; "test" = pkgs.writeText "index.html" ''hello test''; }, extraFiles ? {}, port ? 9000 }:

 let
  serverScript = ''
    #!${env.interpreter}
    from http.server import BaseHTTPRequestHandler, HTTPServer
    import os

    routes = {
      ${builtins.concatStringsSep ",\n      " (pkgs.lib.mapAttrsToList
        (name: path: ''"${name}": "${path}"'')
        pages)}
    }

    filemap = {
      ${builtins.concatStringsSep ",\n      " (pkgs.lib.mapAttrsToList
        (name: path: ''"${name}": "${path}"'')
        extraFiles)}
    }

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            if self.path.lstrip("/") in routes:
                filepath = routes[self.path.lstrip("/")]
                if os.path.exists(filepath):
                    self.send_response(200)
                    self.end_headers()
                    with open(filepath, "rb") as f:
                        self.wfile.write(f.read())
                else:
                    self.send_error(404, "File not found")
            elif self.path.lstrip("/") in filemap:
                filepath = filemap[self.path.lstrip("/")]
                if os.path.exists(filepath):
                    self.send_response(200)
                    self.end_headers()
                    with open(filepath, "rb") as f:
                        self.wfile.write(f.read())
                else:
                    self.send_error(404, "File not found")
            else:
                self.send_error(404, "Not found")

    if __name__ == "__main__":
        server = HTTPServer(("0.0.0.0", ${toString port}), Handler)
        print("Serving on port ${toString port}")
        server.serve_forever()
  '';
in
  pkgs.writeScriptBin "webserver-${toString port}" serverScript   
    
    
