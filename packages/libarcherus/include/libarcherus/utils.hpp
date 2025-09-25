#pragma once

#include <format>
#include <string>
#include <unistd.h>
#include <vector>

namespace utils {

    std::string escape(const std::string& input, char target = ' ');

    std::string capitalize(std::string str);

}

typedef std::vector<std::string> Argv;
#define Main(name) ErrorCode main_wrapper(const name);      \
    int main(int argc, char* argv[]) {                      \
        std::vector<std::string> args(argv, argv + argc);   \
        ErrorCode errorCode = main_wrapper(args);           \
        if (errorCode != ErrorCode::success) {              \
            log(ERROR, "Error: {}", to_string(errorCode));  \
        }                                                   \
        return errorCode;                                   \
    }                                                       \
    ErrorCode main_wrapper(const name)
