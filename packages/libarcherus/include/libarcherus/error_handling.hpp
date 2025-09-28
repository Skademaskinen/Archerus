#pragma once

#include <string>

#define ERROR_DATA                                   \
    X(success, "Operation completed successfully")   \
    X(unknown_error, "An unknown error occurred")    \
    X(invalid_argument, "Invalid argument provided") \

enum ErrorCode {
    #define X(name,_1) name,
        ERROR_DATA
    #undef X
};

const std::string toString(const ErrorCode& code);
