#pragma once

#include "executable.hpp"
#include <libarcherus/config_file.hpp>
#include <vector>

class PrefixConfig : protected ConfigFile {
    const std::vector<Executable> executables;

    const std::vector<Executable> parse();
public:
    PrefixConfig();
    const std::vector<Executable>& get() const;
};
