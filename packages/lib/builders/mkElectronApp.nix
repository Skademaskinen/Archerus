{ lib, pkgs, ... }:

{ appName, url, icon, description ? "An electron app", extraJavascript ? ""}:

let
    electron = pkgs.electron_38;
    name = "${appName}-electron";
    version = "1.0";
    userDataDir = "$HOME/.local/share/${name}";
    package-json = pkgs.writeText "package.json" (builtins.toJSON {
        inherit name version;
        dependencies = {
            "@ghostery/adblocker-electron" = "^2.3.1";
            electron = "^38.0.0";
        };
        main = pkgs.writeText "main.js" ''
            const { app, BrowserWindow, Tray, session, Menu } = require("electron")
            
            const url = "${url}"
            
            app.whenReady().then(() => {
                const win = new BrowserWindow({
                    title: '${appName}',
                    icon: __dirname + '${icon}',
                    frame: false,       // hides the top bar
                    autoHideMenuBar: true,
                    webPreferences: {
                        webSecurity: false,
                        nativeWindowOpen: true,
                        webviewTag: true,
                        contextIsolation: true,
                        nodeIntegration: true,
                    },
                })
                win.loadURL(url)

                ${extraJavascript}

                // TODO: Figure out how to declaratively get dependencies to work
                //const { ElectronBlocker } = require('@ghostery/adblocker-electron');
                //
                //ElectronBlocker.fromPrebuiltAdsAndTracking(fetch).then((blocker) => {
                //    blocker.enableBlockingInSession(session.defaultSession);
                //});

                win.webContents.setWindowOpenHandler(({ url }) => {
                    shell.openExternal(url);
                    return { action: 'deny' };
                });

                // hide scrollbars
                win.webContents.on("did-finish-load", () => {
                    win.webContents.insertCSS("::-webkit-scrollbar { display: none; }");
                });
                
                const contextMenu = Menu.buildFromTemplate([
                    {
                        label: 'Clear Cache',
                        click: () => {
                            session.defaultSession.clearStorageData()
                            app.relaunch();
                            app.exit();
                        }
                    },
                    {
                        label: 'Reload',
                        click: () => win.reload()
                    },
                    {
                        label: 'Quit',
                        type: 'normal',
                        role: 'quit'
                    }
                ])
                
                let tray = new Tray("${icon}")

                tray.setToolTip("${appName}")
                tray.setTitle("${appName}")
                tray.setContextMenu(contextMenu)
            })
        '';
    });
in

pkgs.stdenv.mkDerivation {
    inherit name version;

    src = null;
    dontUnpack = true;

    buildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
        mkdir -p $out/{bin,share/${name}}
        cp ${package-json} $out/share/${name}/package.json
        makeWrapper ${electron}/bin/electron $out/bin/${name} \
            --add-flags "$out/share/${name}" \
            --add-flags "--ozone-platform=wayland" \
            --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecoder" \
            --add-flags "--user-data-dir=${userDataDir}" \
            --add-flags "--disk-cache-dir=${userDataDir}/cache" \
            --add-flags "--user-agent=Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/537.36 \(KHTML, like Gecko\) Chrome/117.0.0.0 Safari/537.36" \
            --add-flags "--class=${name}"

            # desktop entry
            mkdir -p $out/share/applications
            cp ${pkgs.writeText "${name}.desktop" ''
                [Desktop Entry]
                Name=${appName}
                Comment=${description}
                Exec=${name}
                Icon=${name}
                Type=Application
                Categories=Network;Chat
                StartupNotify=true
            ''} $out/share/applications/${name}.desktop

            # icon (official logo in PNG/SVG)
            mkdir -p $out/share/icons/hicolor/512x512/apps
            cp ${icon} $out/share/icons/hicolor/512x512/apps/${name}.png
  '';
}

