#include "prefix.hpp"
#include "argument.hpp"
#include "executable.hpp"
#include "executables_file.hpp"
#include "log.hpp"
#include "vector_utils.hpp"
#include <vector>

Prefix::Prefix(ExecutablesFile executables_file) : executables(executables_file.get_executables()) {
    utils::log(Level(utils::Debug), "Constructed prefix");
}

const std::vector<Executable> Prefix::get_executables() const {
    return executables;
}

const std::string Prefix::build(const ExecutablesConfig& config) const {
    const auto enabled_executables = get_enabled_executables(config);
    auto ordered = utils::order_elements(
        enabled_executables, 
        [](const Executable& first, const Executable& second){
            return first.get_priority() < second.get_priority();
        }
    );
    return utils::concat_elements(ordered, [](const Executable& executable){
        return executable.get_path() + " " + utils::concat_elements(
            executable.get_arguments(), 
            [](const Argument argument) {
                return argument.get() + " ";
            }
        );
    });
}

const std::vector<Executable> Prefix::get_enabled_executables(const ExecutablesConfig& config) const {
    std::vector<Executable> enabled_executables;
    for(auto [name, state] : config) {
        utils::log(Level(utils::Debug), "{} -> {}", name.c_str(), state ? "true" : "false");
        if (!state) {
            continue;
        }
        enabled_executables.push_back(utils::find_element(
            executables, 
            [name, state](const Executable& element) {
                return element.get_name() == name && state;
            }
        ));
    }
    return enabled_executables;
}
