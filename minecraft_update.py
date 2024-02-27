from time import sleep
import requests
import json
import os

services = {
    "hub":{
        "socket":"/run/hub.stdin",
        "stop":"stop",
        "type":"paper"
    },
    "creative":{
        "socket":"/run/creative.socket",
        "stop":"stop",
        "type":"paper"
    },
    "survival":{
        "socket":"/run/survival.stdin",
        "stop":"stop",
        "type":"paper"
    },
    "paradox":{
        "socket":"/run/paradox.stdin",
        "stop":"stop",
        "type":"paper"
    },
    "waterfall":{
        "socket":"/run/waterfall.stdin",
        "stop":"end",
        "type":"waterfall"
    }
}

def runCmd(command:str, socket:str) -> None:
    with open(socket, "w") as stdin:
        stdin.write(command +"\n")

def get_paper_endpoint():
    response = requests.get(f'https://api.papermc.io/v2/projects/paper')
    versions = list(json.loads(response.text)["versions"])
    version = versions[len(versions)-1]
    response = requests.get(f'https://api.papermc.io/v2/projects/paper/versions/{version}')
    json_response = json.loads(response.text)
    builds = list(json_response["builds"])
    latest = builds[len(builds)-1]
    return f'https://api.papermc.io/v2/projects/paper/versions/{version}/builds/{latest}/downloads/paper-{version}-{latest}.jar'

def get_waterfall_endpoint():
    response = requests.get(f'https://api.papermc.io/v2/projects/waterfall')
    versions = list(json.loads(response.text)["versions"])
    version = versions[len(versions)-1]
    response = requests.get(f'https://api.papermc.io/v2/projects/waterfall/versions/{version}')
    json_response = json.loads(response.text)
    builds = list(json_response["builds"])
    latest = builds[len(builds)-1]
    return f'https://api.papermc.io/v2/projects/waterfall/versions/{version}/builds/{latest}/downloads/waterfall-{version}-{latest}.jar'

def main():
    print("Fetching paper and waterfall...")
    paperEndpoint = get_paper_endpoint()
    waterfallEndpoint = get_waterfall_endpoint()

    os.system(f'wget -O /tmp/paper.jar {paperEndpoint}')
    os.system(f'wget -O /tmp/waterfall.jar {waterfallEndpoint}')

    print("Updating archives...")
    for service in services.keys():
        os.system(f"cp /tmp/{services[service]['type']}.jar /mnt/raid/minecraft/{service}/{service}.jar")

    print("Stopping running servers...")
    for service in services.keys():
        runCmd(services[service]["stop"], services[service]["socket"])

    print("sleeping 60 seconds to make sure the servers are stopped...")
    sleep(60)

    print("Restarting systemd units")
    os.system("systemctl restart minecraft-waterfall.service minecraft-paradox.service minecraft-survival.service minecraft-creative.service minecraft-hub.service")

if __name__ == "__main__":
    print("Alerting every instance! 15 minutes")
    runCmd("alert UPDATING SERVER IN 15 MINUTES!", services["waterfall"]["socket"])
    sleep(60*5)
    print("Alerting every instance! 10 minutes")
    runCmd("alert UPDATING SERVER IN 10 MINUTES!", services["waterfall"]["socket"])
    sleep(60*5)
    print("Alerting every instance! 5 minutes")
    runCmd("alert UPDATING SERVER IN 5 MINUTES!", services["waterfall"]["socket"])
    sleep(60*5)
    print("Alerting every instance! NOW")
    runCmd("alert UPDATING SERVER!", services["waterfall"]["socket"])

    main()

