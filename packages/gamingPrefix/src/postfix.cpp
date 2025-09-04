#include "postfix.hpp"
#include "log.hpp"
#include "vector_utils.hpp"
#include <string>

Postfix::Postfix() {
    utils::log(Level(utils::Debug), "Constructed postfix");
}

const std::string Postfix::build(const std::vector<std::string>& command_parts) const {
    return utils::concat_elements(command_parts, [](std::string part) {
        return part + " ";
    });
}
