{pkgs, ...}: let 
    mkPy = script: "${pkgs.writeScriptBin "script.py" ''
        #!${pkgs.python312}/bin/python
        ${script}
    ''}/bin/script.py";
    getNode = mkPy ''
        from subprocess import check_output
        from json import loads
        def execute(data):
            if data["focused"]:
                return data
            for node in data["nodes"]:
                result = execute(node)
                if result:
                    return result
        data = execute(loads(check_output(["${pkgs.sway}/bin/swaymsg", "-t", "get_tree"]).decode()))
        print(data["name"])
    '';
    getNetwork = mkPy ''
        from subprocess import check_output
        data = check_output(["${pkgs.networkmanager}/bin/nmcli", "-t", "c"]).decode().split(":")[0]
        if data == "lo":
            print("Disconnected")
        else:
            print(data)
    '';
    getBattery = mkPy ''
        from os import system
        emojis = {
            "Discharging":"🔋",
            "Charging":"🔌",
            "Not charging":"⚡",
            "Full":"⚡"
        }
        with open("/sys/class/power_supply/BAT0/charge_full") as file:
            full = int(file.read())
        with open("/sys/class/power_supply/BAT0/charge_now") as file:
            now = int(file.read())
        with open("/sys/class/power_supply/BAT0/status") as file:
            status = file.read().split("\n")[0]
        level = round((now/full)*100)
        if level <= 10:
            system(f'${pkgs.libnotify}/bin/notify-send "Low battery! [{level}] consider connecting the charger!')
        print(f"{level}% {emojis[status]}")
    '';
    getVolume = mkPy ''            
        from subprocess import check_output
        out = check_output(["${pkgs.wireplumber}/bin/wpctl", "get-volume", "@DEFAULT_SINK@"]).decode().split(" ")[1:]
        if float(out[0]) == 0 or len(out) == 2:
            final="off"
            print(f'off 🔈')
        else:
            print(f"{int(float(out[0])*100)}% 🔊")

    '';
in {battery ? true}: "${pkgs.writeScriptBin "status.sh" ''
    #!${pkgs.bash}/bin/bash
    while true; do
        node=$(${getNode})
        date_time=$(date +'%Y-%m-%d %X')
        uptime_formatted=$(uptime | cut -d ',' -f1 | cut -d ' ' -f 4,5)
        linux_version=$(uname -r)
        network=$(${getNetwork})
        ${if battery then "battery=$(${getBattery})" else ""}
        volume=$(${getVolume})
        echo "$node | $network | $uptime_formatted | $linux_version 🐧 | $volume ${if battery then "| $battery " else ""}| $date_time"
    done
''}/bin/status.sh"
