#pragma once

#include <string>
#include <vector>

#include <nlohmann/json.hpp>

#include "executable.hpp"
class ExecutablesFile {
    nlohmann::json data;
    std::vector<Executable> executables;
public:
    ExecutablesFile();

    const nlohmann::json& get_data() const;
    const std::vector<Executable> get_executables() const;
    const nlohmann::json read_json_data() const;
};
