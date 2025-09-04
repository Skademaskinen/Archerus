#pragma once

#include <format>
#include <string>
#include <unistd.h>

namespace utils {

    inline std::string escape(const std::string& input, char target = ' ') {
        std::string result;
        for (char c : input) {
            if (c == target)
                result += std::format("\\{}", target);
            else
                result += c;
        }
        return result;
    }

    inline std::string capitalize(std::string str) {
        std::string result;
        for (const auto& c : str) {
            result.push_back(c - 32);
        }
        return result;
    }

}
