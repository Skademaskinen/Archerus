#include <cstdlib>
#include <fstream>
#include <string>
#include <vector>

#include <nlohmann/json.hpp>
#include <libarcherus/log.hpp>

#include "executables_file.hpp"
#include "executable.hpp"

ExecutablesFile::ExecutablesFile() : data(read_json_data()) {
    for(auto& item : data) {
        std::filesystem::path path = "";
        int priority = 0;
        std::vector<Argument> arguments;
        Environment environment;
        const auto name = item.at("name").get<std::string>();
        if (item.contains("path")) {
            path = item.at("path").get<std::string>();
        }
        if (item.contains("arguments")) {
            for(const auto& argument_str : item.at("arguments").get<std::vector<std::string>>()) {
                arguments.push_back(argument_str);
            }
        }
        if (item.contains("priority")) {
            priority = item.at("priority").get<int>();
        }
        if (item.contains("environment")) {
            environment = item.at("environment").get<Environment>();
        }
        executables.push_back({ name, path, arguments, priority, environment });
    }
}

const nlohmann::json& ExecutablesFile::get_data() const {
    return data;
}

const std::vector<Executable> ExecutablesFile::get_executables() const {
    return executables;
}

const nlohmann::json ExecutablesFile::read_json_data() const {
    const auto path = std::getenv("GAMING_EXECUTABLES_CONFIG");
    if (path == nullptr) {
        return nlohmann::json {
           {
               {"name", "gamemode"},
               {"path", "gamemoderun"},
               {"priority", 1}
           },
           {
               {"name", "mangohud"},
               {"path", "mangohud"},
               {"priority", 2}
           },
           {
               {"name", "wayland"},
               {"path", ""},
               {"priority", 0},
               {"environment", {
                   {"DISPLAY", ""}
               }}
           }
        };

    } else {
        std::ifstream file;
        file.open(path);
        std::stringstream ss;
        ss << file.rdbuf();
        return nlohmann::json::parse(ss.str());
    }
}
