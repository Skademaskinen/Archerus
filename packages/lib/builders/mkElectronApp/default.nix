{ lib, pkgs, ... }:

{ appName, url, icon, description ? "An electron app", extraJavascript ? "", tray? false}:

let
    electron = pkgs.electron_38;
    name = "${appName}-electron";
    version = "1.0.0";
    userDataDir = "$HOME/.local/share/${name}";
    main = pkgs.writeText "main.js" ''
        const { app, BrowserWindow, Tray, session, Menu } = require("electron")
        const { ElectronBlocker } = require('@ghostery/adblocker-electron');
        
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
            
            ElectronBlocker.fromPrebuiltAdsAndTracking(fetch).then((blocker) => {
                blocker.enableBlockingInSession(session.defaultSession);
            });

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
            
            ${if tray then ''
                let tray = new Tray("${icon}")
    
                tray.setToolTip("${appName}")
                tray.setTitle("${appName}")
                tray.setContextMenu(contextMenu)
            '' else ""}
        })
    '';

    package-json = {
        inherit name version;
        devDependencies = {
            electron-builder = "^26.0.12";
            electron = "^38.0.0";
        };
        dependencies."@ghostery/adblocker-electron" = "^2.11.6";
        main = "main.js";
    };

    package-json-file = pkgs.writeText "package.json" (builtins.toJSON package-json);

    baseElectronApp = pkgs.runCommand "${name}-src" {} ''
        mkdir -p $out
        cp ${package-json-file} $out/package.json
        cp ${./package-lock.json} $out/package-lock.json
        cp ${main} $out/main.js
    '';
in

pkgs.buildNpmPackage (finalAttrs: {
    inherit name version;
    src = baseElectronApp;
    npmDepsHash = "sha256-TfrYo5MBr6EECWXWuL8W7CxXxnvDAkr55II2/b/N6Ks=";
    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    forceGitDeps = true;
    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];
    buildPhase = ''
        runHook preBuild

        npm exec electron-builder -- \
            --dir \
            -c.electronDist=${electron.dist} \
            -c.electronVersion=${electron.version}

        runHook postBuild
    '';

    installPhase = ''
        runHook preInstall

        mkdir -p $out/share/${name}
        cp -r dist/*-unpacked $out/share/${name}/dist

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

        runHook postInstall
    '';

    postFixup = ''
        makeWrapper $out/share/${name}/dist/${pkgs.lib.toLower name} $out/bin/${name} \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecoder --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
            --add-flags "--no-sandbox --disable-gpu-sandbox" \
            --add-flags "--user-data-dir=${userDataDir}" \
            --add-flags "--disk-cache-dir=${userDataDir}/cache" \
            --add-flags "--user-agent=Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/537.36 \(KHTML, like Gecko\) Chrome/117.0.0.0 Safari/537.36" \
            --add-flags "--class=${name}"

    '';
})


