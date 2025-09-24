#pragma once

#include <map>
#include <string>
#include <vector>

#include "argument.hpp"

typedef std::map<std::string, std::string> Environment;

class Executable {
    std::string name;
    std::string path;
    std::vector<Argument> arguments;
    int priority;
    Environment environment;
public:
    Executable(std::string, std::string, std::vector<Argument>, int, Environment);
    const std::string& get_name() const;
    const std::string& get_path() const;
    const std::vector<Argument>& get_arguments() const;
    const int& get_priority() const;
    const Environment& get_environment() const;
};
