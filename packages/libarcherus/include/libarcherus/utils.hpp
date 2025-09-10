#pragma once

#include <format>
#include <string>
#include <unistd.h>

namespace utils {

    std::string escape(const std::string& input, char target = ' ');

    std::string capitalize(std::string str);

}
