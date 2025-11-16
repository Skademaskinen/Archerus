#pragma once

#include <filesystem>
#include <string>

#include <nlohmann/json.hpp>

const std::filesystem::path BASE_CONFIG_PATH = "/etc/archerus";

class ConfigFile {
    const std::string name;
    const std::filesystem::path etcPath;
    const std::string environmentKey;
    nlohmann::json data;
public:
    ConfigFile(std::filesystem::path);

    nlohmann::json& get();
};
