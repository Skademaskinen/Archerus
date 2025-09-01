#include <fstream>

#include <nlohmann/json.hpp>

#include "config.hpp"
#include "log.hpp"

File::File(const std::string& type, const std::string& path) : type(type), path(path) {

}

File::File() : type("text/plain"), path("") {
}

const std::string& File::get_path() const {
    return path;
}

const std::string& File::get_type() const {
    return type;
}

Config::Config() : BaseConfig("Webserver") {
    LOG("Config initializing");
    parser.add_argument("-c", "--config")
        .help("Path to configuration file")
        .default_value(std::string("config.json"))
        .action([](const std::string& value) { return value; });
}

// This function processes the passed config file, it should be json in the form { "port": 8080, "routes": { "/index.html", "/nix/store/aaaa-index.html"}}
void Config::parse_json() {
    std::string config_path = parser.get<std::string>("--config");
    LOG("Processing config file: %s", config_path.c_str());
    // use nlohhmann_json to parse the json file
    std::ifstream config_file(config_path);
    if (!config_file.is_open()) {
        LOG("Could not open config file: %s", config_path.c_str());
        exit(1);
    }
    nlohmann::json config_json;
    try {
        config_file >> config_json;
    } catch (const nlohmann::json::parse_error& err) {
        LOG("JSON parsing error: %s", err.what());
        exit(1);
    }
    if (config_json.contains("port") && config_json["port"].is_number_unsigned()) {
        port = config_json["port"];
        LOG("Configured port: %d", port);
    } else {
        LOG("Config file missing 'port' or 'port' is not an unsigned number");
        exit(1);
    }
    if (config_json.contains("routes") && config_json["routes"].is_object()) {
        for (auto& [key, value] : config_json["routes"].items()) {
            if (value.is_string()) {
                routes[key] = value;
                LOG("Configured route: %s -> %s", key.c_str(), ((std::string)value).c_str());
            } else {
                LOG("Route value for key '%s' is not a string", key.c_str());
                exit(1);
            }
        }
    } else {
        LOG("Config file missing 'routes' or 'routes' is not an object");
        exit(1);
    }
    if (config_json.contains("extra_files") && config_json["extra_files"].is_object()) {
        for (auto& [key, value] : config_json["extra_files"].items()) {
            File file(value["type"], value["path"]);
            extra_route_files[key] = file;
            LOG("Configured extra route file: %s -> %s", key.c_str(), ((std::string)value["path"]).c_str());
        }
    }
}

const unsigned int Config::get_port() const {
    return port;
}

const std::map<std::string, std::string>& Config::get_routes() const {
    return routes;
}

const std::map<std::string, File>& Config::get_extra_route_files() const {
    return extra_route_files;
}
