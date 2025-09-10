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

template<typename ...T>
void utils::log(const LogLevelData loglevel_data, const std::format_string<T...> fmt, T&&... args) {
    const auto& [filename, function, line_number, level] = loglevel_data;
    std::time_t now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());

    std::string s(30, '\0');
    std::strftime(&s[0], s.size(), "%Y-%m-%d %H:%M", std::localtime(&now));

    std::string formatted_string = std::format(fmt, std::forward<T>(args)...);
    if (currentLevel <= level)
        std::cout << '[' << s << "] " << strip_path(filename.c_str()) << "::" << function << ':' << line_number << "\r\t\t\t\t\t\t" << formatted_string << std::endl;
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

template<typename T, typename F>
const T& utils::find_element(const std::vector<T> &elements, F find_function) {
    for(const auto& element : elements) {
        if (find_function(element)) {
            return element;
        }
    }
    throw std::exception();
}

template<typename T, typename F>
std::vector<T> utils::order_elements(const std::vector<T> &elements, F comparator) {
    std::vector<T> ordered = elements;
    std::sort(ordered.begin(), ordered.end(), comparator);
    return ordered;
}

template<typename T, typename F>
std::string utils::concat_elements(const std::vector<T> &elements, F to_string_func) {
    std::string result;
    for (const auto& element : elements) {
        result += to_string_func(element);
    }
    return result;
}
