#include <string>
#include <unistd.h>

#include <libarcherus/log.hpp>
#include <libarcherus/utils.hpp>

#include "postfix.hpp"
#include "prefix.hpp"


Postfix::Postfix(const CommandParts& parts) :
    parts(parts) {
    log(DEBUG, "Constructed postfix");
}

void Postfix::execute(const Prefix& prefix) const {
    log(WARNING, "!!! LAUNCHING !!!");

    if (parts.empty()) {
        log(ERROR, "No executable specified");
        return;
    }

    // Start with prefix string as-is
    std::string cmd = prefix.build();

    // Escape the actual executable
    cmd += " " + utils::escape(parts[0]);

    // Escape remaining arguments
    bool first = true;
    for (const auto& arg : parts) {
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

const std::string Postfix::represent() const {
    std::string result;
    for(const auto& arg : parts) {
        result += arg + " ";
    }
    return result;
}
