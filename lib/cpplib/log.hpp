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
    inline char* strip_path(const char* path) {
        const char* last_slash = path;
        for (const char* p = path; *p; ++p) {
            if (*p == '/' || *p == '\\') {
                last_slash = p + 1;
            }
        }
        return const_cast<char*>(last_slash);
    }

    enum LogLevel {
        Debug,
        Info,
        Warn,
        Error
    };
    typedef std::tuple<std::string, std::string, unsigned int, LogLevel> LogLevelData;
    inline LogLevel currentLevel = Info;

    template<typename ...T>
    void log(const LogLevelData loglevel_data, const std::format_string<T...> fmt, T&&... args) {
        const auto& [filename, function, line_number, level] = loglevel_data;
        std::time_t now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
    
        std::string s(30, '\0');
        std::strftime(&s[0], s.size(), "%Y-%m-%d %H:%M", std::localtime(&now));

        std::string formatted_string = std::format(fmt, std::forward<T>(args)...);
        if (currentLevel <= level)
            std::cout << '[' << s << "] " << strip_path(filename.c_str()) << "::" << function << ':' << line_number << "   |||   " << formatted_string << std::endl;
    }
}
