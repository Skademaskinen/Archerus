#pragma once

#include <string>

class Argument {
    const std::string value;
public:
    Argument(const std::string&);

    const std::string get() const;
};
