#pragma once

#include <string>
#include <unistd.h>
#include <vector>

namespace utils {

    std::string escape(const std::string& input, char target = ' ');

    std::string capitalize(std::string str);

}

typedef std::vector<std::string> Argv;
#define Main(name) ErrorCode mainWrapper(const name);       \
    int main(int argc, char* argv[]) {                      \
        std::vector<std::string> args(argv, argv + argc);   \
        ErrorCode errorCode = mainWrapper(args);            \
        if (errorCode != ErrorCode::success) {              \
            log(ERROR, "Error: {}", toString(errorCode));   \
        }                                                   \
        return errorCode;                                   \
    }                                                       \
    ErrorCode mainWrapper(const name)
