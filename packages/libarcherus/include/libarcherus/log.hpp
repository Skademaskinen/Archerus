#pragma once

#include <chrono>
#include <cstdio>
#include <ctime>
#include <iostream>
#include <map>
#include <string>
#include <tuple>
#include <format>



#define Level(level) {__PRETTY_FUNCTION__, __LINE__, utils::level}

#define LOGLEVEL_ENUM \
    X(Debug)          \
    X(Info)           \
    X(Warn)           \
    X(Error)

namespace utils {
    // This function strips everything until the last '/' in a file path to just show the file name
    const std::string strip_path(const std::string path);

    enum LogLevel {
        #define X(name) name,
            LOGLEVEL_ENUM
        #undef X
    };

    inline std::string toString(LogLevel level) {
        return (std::map<LogLevel, std::string>) {
            #define X(name) { LogLevel::name, #name },
                LOGLEVEL_ENUM
            #undef X
        }[level];
    }

    inline LogLevel fromString(std::string data) {
        return (std::map<std::string, LogLevel>) {
            #define X(name) { #name, LogLevel::name },
                LOGLEVEL_ENUM
            #undef X
        }[data];
    }

    typedef std::tuple<std::string, unsigned int, LogLevel> LogLevelData;
    inline LogLevel currentLevel = Info;

    typedef std::tuple<unsigned int, unsigned int, unsigned int> Color;

    inline std::string color(LogLevel level, const std::string& data) {
        const auto [red, green, blue] = (std::map<LogLevel, Color>) {
            {Debug,     {100, 100, 100}},
            {Info,      {255, 255, 255}},
            {Warn,      {255, 255, 0  }},
            {Error,     {255, 0,   0  }}
        }[level];
        return std::format("\033[38;2;{};{};{}m{}\033[0m", red, green, blue, data);
    }

    template<typename ...T>
    void log(const LogLevelData loglevel_data, const std::format_string<T...> fmt, T&&... args) {
        const auto& [function, line_number, level] = loglevel_data;
        std::time_t now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
    
        std::string s(30, '\0');
        std::strftime(&s[0], s.size(), "%Y-%m-%d %H:%M", std::localtime(&now));
    
        std::string formatted_string = std::format(fmt, std::forward<T>(args)...);
        if (currentLevel <= level) {
            if (currentLevel == Debug) {
                std::cout << "| [" << s << "] " << function << ':' << line_number << "\n*-\t";
            }
            std::cout << color(level, formatted_string) << std::endl;
        }
    }
}
