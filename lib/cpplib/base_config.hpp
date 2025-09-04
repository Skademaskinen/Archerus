#include "log.hpp"
#include <argparse/argparse.hpp>

// base virtual config class
class BaseConfig {
protected:
    argparse::ArgumentParser parser;
    bool parsed;
    BaseConfig(std::string name) : parser(name), parsed(false) {
    }

public:
    virtual void parse_json() {
        utils::log(Level(utils::Debug), "Running default (empty) parse_json implementation");
    };
    void parse(int argc, char* argv[]) {
        try {
            parser.parse_args(argc, argv);
        } catch (const std::runtime_error& err) {
            utils::log(Level(utils::Debug), "Argument parsing error: {}", err.what());
            exit(1);
        }
        parse_json();
        parsed = true;
    }
    ~BaseConfig() {
        utils::log(Level(utils::Debug), "Destroying Base config child");
    }
    bool is_parsed() const {
        return parsed;
    }
};
