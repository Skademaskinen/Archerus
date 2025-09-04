#pragma once

#include <map>
#include <string>
#include <vector>

#include "executable.hpp"
#include "executables_file.hpp"

typedef std::map<std::string, bool> ExecutablesConfig;

class Prefix {
    const std::vector<Executable> executables;
    const std::vector<std::string> environment;
public:
    Prefix(ExecutablesFile);

    const std::vector<Executable> get_executables() const;
    const std::string build(const ExecutablesConfig&) const;
};
