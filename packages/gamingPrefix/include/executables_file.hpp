#pragma once

#include "executable.hpp"
#include <string>
#include <vector>
class ExecutablesFile {
    std::string data;
    std::vector<Executable> executables;
public:
    ExecutablesFile();

    const std::string& get_data() const;
    const std::vector<Executable> get_executables() const;
    const std::string read_json_data() const;
};
