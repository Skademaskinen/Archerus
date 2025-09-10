#include <cstdlib>
#include <fstream>
#include <string>
#include <vector>

#include <nlohmann/json.hpp>
#include <libarcherus/log.hpp>

#include "executables_file.hpp"
#include "executable.hpp"

ExecutablesFile::ExecutablesFile() : data(read_json_data()) {
    auto j = nlohmann::json::parse(data);
    for(auto& item : j) {
        const auto name = item.at("name").get<std::string>();
        const auto path = item.at("path").get<std::string>();
        std::vector<Argument> arguments;
        for(const auto& argument_str : item.at("arguments").get<std::vector<std::string>>()) {
            arguments.push_back(argument_str);
        }
        const auto priority = item.at("priority").get<int>();
        const auto environment = item.at("environment").get<Environment>();
        executables.push_back({ name, path, arguments, priority, environment });
    }
}

const std::string& ExecutablesFile::get_data() const {
    return data;
}

const std::vector<Executable> ExecutablesFile::get_executables() const {
    return executables;
}

const std::string ExecutablesFile::read_json_data() const {
    const auto path = std::getenv("GAMING_EXECUTABLES_CONFIG");
    if (path == nullptr) {
        return R"([
            {
                "name": "gamemode",
                "path": "gamemoderun",
                "arguments": [],
                "priority": 1,
                "environment": {}
            },
            {
                "name": "mangohud",
                "path": "mangohud",
                "arguments": [],
                "priority": 2,
                "environment": {}
            },
            {
                "name": "wayland",
                "path": "",
                "arguments": [],
                "priority": 0,
                "environment": {
                    "DISPLAY": ""
                }
            }
        ])";
    } else {
        std::ifstream file;
        file.open(path);
        std::stringstream ss;
        ss << file.rdbuf();
        return ss.str();
    }
}
