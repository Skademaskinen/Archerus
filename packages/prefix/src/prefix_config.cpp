#include "prefix_config.hpp"

const std::vector<Executable> PrefixConfig::parse() {
    std::vector<Executable> executables;
    for(auto& item : ConfigFile::get()) {
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
    return executables;
}


PrefixConfig::PrefixConfig() : ConfigFile("prefix"), executables(parse()) {
}

const std::vector<Executable>& PrefixConfig::get() const {
    return executables;
}


