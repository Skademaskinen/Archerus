#pragma once

#include <string>
#include <vector>

#include "prefix.hpp"

typedef std::vector<std::string> CommandParts;

class Postfix {
public:
    Postfix();

    void execute(const ExecutablesConfig&, const Prefix&, const CommandParts&) const;
    const std::string represent(const CommandParts&) const;
};
