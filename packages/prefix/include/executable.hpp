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
    Executable(const std::string&, const std::filesystem::path&, const std::vector<Argument>&, const int&, const Environment&);
    const std::string& getName() const;
    const std::filesystem::path& getPath() const;
    const std::vector<Argument>& getArguments() const;
    const int& getPriority() const;
    const Environment& getEnvironment() const;
};
