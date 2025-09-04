#pragma once

#include <string>
#include <vector>

class Postfix {
public:
    Postfix();

    const std::string build(const std::vector<std::string>&) const;
};
