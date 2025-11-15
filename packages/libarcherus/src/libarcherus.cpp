#include "libarcherus/base_config.hpp"
#include "libarcherus/error_handling.hpp"
#include "libarcherus/log.hpp"
#include "libarcherus/utils.hpp"
#include "libarcherus/config_file.hpp"
#include <cstdlib>
#include <filesystem>
#include <fstream>

#include <argparse/argparse.hpp>
#include <nlohmann/json.hpp>

void archerus::BaseConfig::parseJson() {
    log(DEBUG, "Running default (empty) parse_json implementation");
}

void archerus::BaseConfig::parse(const int argc, const char* argv[]) {
    try {
        parser.parse_args(argc, argv);
    } catch (const std::runtime_error& err) {
        log(DEBUG, "Argument parsing error: {}", err.what());
        exit(1);
    }
    parseJson();
    parsed = true;
}

void archerus::BaseConfig::parse(const Argv& args) {
    try {
        parser.parse_args(args);
    } catch (const std::runtime_error& err) {
        log(DEBUG, "Argument parsing error: {}", err.what());
        exit(1);
    }
    parseJson();
    parsed = true;
}

archerus::BaseConfig::~BaseConfig() {
    log(DEBUG, "Destroying Base config child");
}

bool archerus::BaseConfig::isParsed() const {
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

const std::string toString(LogLevel& level) {
    return (std::map<LogLevel, std::string>) {
        #define X(name,_1,_2,_3) { LogLevel::name, #name },
            LOGLEVEL_DATA
        #undef X
    }[level];
}

const LogLevel fromString(const std::string& data) {
    return (std::map<std::string, LogLevel>) {
        #define X(name,_1,_2,_3) { #name, LogLevel::name },
            LOGLEVEL_DATA
        #undef X
    }[data];
}

const std::string toString(const ErrorCode& code) {
    return (std::map<ErrorCode, std::string>) {
        #define X(name,str) { ErrorCode::name, str },
            ERROR_DATA
        #undef X
    }[code];
}

const Color toColor(const LogLevel& level) {
    return (std::map<LogLevel, Color>) {
        #define X(name,r,g,b) { LogLevel::name, { r, g, b } },
            LOGLEVEL_DATA
        #undef X
    }[level];
}

void parseLoglevel(argparse::ArgumentParser& parser) {
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

ConfigFile::ConfigFile(std::filesystem::path name) :
    name(name),
    etcPath((BASE_CONFIG_PATH / name).replace_extension(".json")),
    environmentKey("ARCHERUS_" + utils::capitalize(name) + "_CONFIG")
{
    auto envConfig = std::getenv(environmentKey.c_str());
    if (envConfig != nullptr) {
        data = nlohmann::json::parse(envConfig);
    } else if (std::filesystem::exists(etcPath)) {
        std::ifstream ifs(etcPath);
        std::stringstream ss;
        ss << ifs.rdbuf();
        auto rawData = ss.str();
        data = nlohmann::json::parse(rawData);
    } else {
        std::filesystem::path exe = "/proc/self/exe";
        auto target = std::filesystem::read_symlink(exe);
        auto bin = target.parent_path();
        auto package = bin.parent_path();
        auto localPath = (package / "etc" / "archerus" / name).replace_extension(".json");
        log(DEBUG, "local path: {}", localPath.string());
        std::ifstream ifs(localPath);
        std::stringstream ss;
        ss << ifs.rdbuf();
        auto rawData = ss.str();
        data = nlohmann::json::parse(rawData);
    }
}

nlohmann::json& ConfigFile::get() {
    return data;
}
