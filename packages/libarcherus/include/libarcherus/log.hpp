#pragma once

#include <argparse/argparse.hpp>
#include <iostream>
#include <string>
#include <format>

#include "error_handling.hpp"

#define LOGLEVEL_DATA                              \
    X(tra,  100, 100, 100)                         \
    X(dbg,  100, 100, 100)                         \
    X(info, 255, 255, 255)                         \
    X(warn, 255, 255, 0)                           \
    X(err,  255, 0,   0)                           \
    X(cri,  255, 0,   0)                           \

enum LogLevel {
    #define X(name,_1,_2,_3) name,
        LOGLEVEL_DATA
    #undef X
};

#define LEVEL(level) {__PRETTY_FUNCTION__, __LINE__, level}
#define TRACE LEVEL(tra)
#define DEBUG LEVEL(dbg)
#define INFO LEVEL(info)
#define WARNING LEVEL(warn)
#define ERROR LEVEL(err)
#define CRITICAL LEVEL(cri)

typedef std::tuple<std::string, unsigned int, LogLevel> logger_data;
typedef std::tuple<unsigned int, unsigned int, unsigned int> Color;

const std::string toString(const LogLevel& level);

const LogLevel fromString(const std::string& data);


const Color toColor(const LogLevel& level);

inline LogLevel currentLogLevel = LogLevel::info;

void parseLoglevel(argparse::ArgumentParser& parser);

template<typename ...T>
ErrorCode log(logger_data loglevel, std::format_string<T...> fmt, T... values) {
    try {
        const auto& [function, line, level] = loglevel;
        const auto formatted = std::format(fmt, std::forward<T>(values)...);
        const auto [r, g, b] = toColor(level);
        const auto formatted_color = std::format("\033[38;2;{};{};{}m", r, g, b);

        if (level < currentLogLevel) {
            return ErrorCode::success;
        }

        std::cout << formatted_color << function << ':' << line << ' ' << formatted << "\033[0m" << std::endl;
        return ErrorCode::success;
    } catch (const std::exception& e) {
        log(ERROR, "Unknown Exception: {}", e.what());
        return ErrorCode::unknown_error;
    }
}
