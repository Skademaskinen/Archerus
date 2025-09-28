#pragma once

#include <map>
#include <string>
#include <vector>

#include <libarcherus/config_file.hpp>

#include "config.hpp"
#include "executable.hpp"

typedef std::map<std::string, bool> ExecutablesConfig;

class Prefix {
    const std::vector<Executable> executables;
    const std::vector<std::string> environment;
public:
    Prefix(const Config&);

    const std::vector<Executable>& getExecutables() const;
    const std::string build() const;
};
