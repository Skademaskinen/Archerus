#pragma once

#include "prefix.hpp"
#include <string>
#include <vector>

typedef std::vector<std::string> CommandParts;

class Postfix {
public:
    Postfix();

    void execute(const ExecutablesConfig&, const Prefix&, const CommandParts&) const;
    const std::string represent(const CommandParts&) const;
};
