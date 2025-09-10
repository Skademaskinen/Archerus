#include <string>

#include <libarcherus/log.hpp>

#include "executable.hpp"

Executable::Executable(std::string name, std::string path, std::vector<Argument> arguments, int priority, Environment environment) : name(name), path(path), arguments(arguments), priority(priority), environment(environment) {
    utils::log(Level(utils::Debug), "Constructed executable | {} | {} | {}", name.c_str(), path.c_str(), priority);

}

const std::string& Executable::get_name() const {
    return name;
}

const std::string& Executable::get_path() const {
    return path;
}

const std::vector<Argument>& Executable::get_arguments() const {
    return arguments;
}

const int& Executable::get_priority() const {
    return priority;
}

const Environment& Executable::get_environment() const {
    return environment;
}
