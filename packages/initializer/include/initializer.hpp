#pragma once

#include "type.hpp"
#include "config.hpp"

class Initializer {
    Config& config;
    Type& type;
    bool executed;
public:
    Initializer(Type&, Config&);

    void execute_instructions();
};
