#include "libarcherus/base_config.hpp"
#include "libarcherus/log.hpp"
#include "libarcherus/utils.hpp"
#include "libarcherus/vector_utils.hpp"

void archerus::BaseConfig::parse_json() {
    utils::log(Level(utils::Debug), "Running default (empty) parse_json implementation");
}

void archerus::BaseConfig::parse(int argc, char* argv[]) {
    try {
        parser.parse_args(argc, argv);
    } catch (const std::runtime_error& err) {
        utils::log(Level(utils::Debug), "Argument parsing error: {}", err.what());
        exit(1);
    }
    parse_json();
    parsed = true;
}

archerus::BaseConfig::~BaseConfig() {
    utils::log(Level(utils::Debug), "Destroying Base config child");
}

bool archerus::BaseConfig::is_parsed() const {
    return parsed;
}

const std::string utils::strip_path(const std::string path) {
    return std::filesystem::path(path).filename().string();
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

