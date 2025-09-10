#pragma once

#include <chrono>
#include <cstdio>
#include <ctime>
#include <iostream>
#include <string>
#include <tuple>
#include <format>



#define Level(level) {__FILE__, __FUNCTION__, __LINE__, level}

namespace utils {
    // This function strips everything until the last '/' in a file path to just show the file name
    const std::string strip_path(const std::string path);

    enum LogLevel {
        Debug,
        Info,
        Warn,
        Error
    };
    typedef std::tuple<std::string, std::string, unsigned int, LogLevel> LogLevelData;
    inline LogLevel currentLevel = Info;

    template<typename ...T>
    void log(const LogLevelData loglevel_data, const std::format_string<T...> fmt, T&&... args);
}
