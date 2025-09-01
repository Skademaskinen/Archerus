#pragma once

#include <cstdio>
#include <ctime>

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

#define LOG(fmt, ...) do { \
    std::time_t t = std::time(nullptr); \
    std::tm tm = *std::localtime(&t); \
    char timebuf[32]; \
    std::strftime(timebuf, sizeof(timebuf), "[%d/%m/%Y]", &tm); \
    std::fprintf(stderr, "%s %s::%s:%d\r\t\t\t\t\t\t- " fmt "\n", \
        timebuf, strip_path(__FILE__), __FUNCTION__, __LINE__, ##__VA_ARGS__); \
} while (0)

