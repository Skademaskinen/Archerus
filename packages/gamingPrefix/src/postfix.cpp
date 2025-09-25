#include <string>
#include <unistd.h>

#include <libarcherus/log.hpp>
#include <libarcherus/utils.hpp>

#include "postfix.hpp"
#include "prefix.hpp"


Postfix::Postfix() {
    log(DEBUG, "Constructed postfix");
}

void Postfix::execute(const ExecutablesConfig& config, const Prefix& prefix, const CommandParts& args) const {

    if (args.empty()) {
        log(ERROR, "No executable specified");
        return;
    }

    // Start with prefix string as-is
    std::string cmd = prefix.build(config);

    // Escape the actual executable
    cmd += " " + utils::escape(args[0]);

    // Escape remaining arguments
    bool first = true;
    for (const auto& arg : args) {
        if (first) {
            first = !first;
            continue;
        }
        log(DEBUG, "arg: {}", arg);
        cmd += " " + utils::escape(utils::escape(utils::escape(arg), '('), ')');
    }

    log(DEBUG, "Running command: {}", cmd);

    int ret = std::system(cmd.c_str());
    if (ret == -1) {
        log(ERROR, "system failed");
    }
}

const std::string Postfix::represent(const CommandParts& args) const {
    std::string result;
    for(const auto& arg : args) {
        result += arg + " ";
    }
    return result;
}
