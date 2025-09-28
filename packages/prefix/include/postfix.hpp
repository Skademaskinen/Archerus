#pragma once

#include <string>
#include <vector>

#include "prefix.hpp"

typedef std::vector<std::string> CommandParts;

class Postfix {
    CommandParts parts;
public:
    Postfix(const CommandParts&);

    void execute(const Prefix&) const;
    const std::string represent() const;
};
