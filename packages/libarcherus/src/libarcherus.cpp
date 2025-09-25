#include "libarcherus/base_config.hpp"
#include "libarcherus/error_handling.hpp"
#include "libarcherus/log.hpp"
#include "libarcherus/utils.hpp"
#include <argparse/argparse.hpp>

void archerus::BaseConfig::parse_json() {
    log(DEBUG, "Running default (empty) parse_json implementation");
}

void archerus::BaseConfig::parse(const int argc, const char* argv[]) {
    try {
        parser.parse_args(argc, argv);
    } catch (const std::runtime_error& err) {
        log(DEBUG, "Argument parsing error: {}", err.what());
        exit(1);
    }
    parse_json();
    parsed = true;
}

void archerus::BaseConfig::parse(const Argv& args) {
    try {
        parser.parse_args(args);
    } catch (const std::runtime_error& err) {
        log(DEBUG, "Argument parsing error: {}", err.what());
        exit(1);
    }
    parse_json();
    parsed = true;
}

archerus::BaseConfig::~BaseConfig() {
    log(DEBUG, "Destroying Base config child");
}

bool archerus::BaseConfig::is_parsed() const {
    return parsed;
}

std::string utils::escape(const std::string &input, char target) {
    std::string result;
    for (char c : input) {
        if (c == target)
            result += std::format("\\{}", target);
        else
            result += c;
    }
    return result;
}

std::string utils::capitalize(std::string str) {
    std::string result;
    for (const auto& c : str) {
        result.push_back(c - 32);
    }
    return result;
}

const std::string to_string(LogLevel& level) {
    return (std::map<LogLevel, std::string>) {
        #define X(name,_1,_2,_3) { LogLevel::name, #name },
            LOGLEVEL_DATA
        #undef X
    }[level];
}

const LogLevel from_string(const std::string& data) {
    return (std::map<std::string, LogLevel>) {
        #define X(name,_1,_2,_3) { #name, LogLevel::name },
            LOGLEVEL_DATA
        #undef X
    }[data];
}

const std::string to_string(const ErrorCode& code) {
    return (std::map<ErrorCode, std::string>) {
        #define X(name,str) { ErrorCode::name, str },
            ERROR_DATA
        #undef X
    }[code];
}

const Color to_color(const LogLevel& level) {
    return (std::map<LogLevel, Color>) {
        #define X(name,r,g,b) { LogLevel::name, { r, g, b } },
            LOGLEVEL_DATA
        #undef X
    }[level];
}

void parse_loglevel(argparse::ArgumentParser& parser) {
    parser.add_argument("-v")
        .action([&](const auto &){
            int val = (int)currentLogLevel;
            val--;
            currentLogLevel = (LogLevel)val;
        })
        .append()
        .default_value(false)
        .implicit_value(true)
        .help("Increase verbosity")
        .nargs(0);
    parser.add_argument("-q")
        .action([&](const auto &){
            int val = (int)currentLogLevel;
            val++;
            currentLogLevel = (LogLevel)val;
        })
        .append()
        .default_value(false)
        .implicit_value(true)
        .help("Decrease verbosity")
        .nargs(0);
}
