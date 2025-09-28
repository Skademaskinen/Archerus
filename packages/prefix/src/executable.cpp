#include <filesystem>
#include <string>

#include <libarcherus/log.hpp>

#include "executable.hpp"

Executable::Executable(const std::string& name, const std::filesystem::path& path, const std::vector<Argument>& arguments, const int& priority, const Environment& environment) :
    name(name),
    path(path),
    arguments(arguments),
    priority(priority),
    environment(environment) {
    log(DEBUG, "Constructed executable | {} | {} | {}", name.c_str(), path.c_str(), priority);

}

const std::string& Executable::getName() const {
    return name;
}

const std::filesystem::path& Executable::getPath() const {
    return path;
}

const std::vector<Argument>& Executable::getArguments() const {
    return arguments;
}

const int& Executable::getPriority() const {
    return priority;
}

const Environment& Executable::getEnvironment() const {
    return environment;
}
