#pragma once

#include <filesystem>
#include <map>
#include <string>
#include <vector>

#include "argument.hpp"

typedef std::map<std::string, std::string> Environment;

class Executable {
    std::string           name;
    std::filesystem::path path;
    std::vector<Argument> arguments;
    int priority;
    Environment environment;
public:
    Executable(std::string, std::filesystem::path, std::vector<Argument>, int, Environment);
    const std::string& get_name() const;
    const std::filesystem::path& get_path() const;
    const std::vector<Argument>& get_arguments() const;
    const int& get_priority() const;
    const Environment& get_environment() const;
};
