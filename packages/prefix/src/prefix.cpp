#include <vector>

#include <libarcherus/log.hpp>
#include <libarcherus/vector_utils.hpp>

#include "prefix.hpp"
#include "argument.hpp"
#include "executable.hpp"

Prefix::Prefix(const Config& config) : executables(config.getEnabledExecutables()) {
    log(DEBUG, "Constructed prefix");
}

const std::vector<Executable>& Prefix::getExecutables() const {
    return executables;
}

const std::string Prefix::build() const {
    auto ordered = utils::orderElements(
        executables, 
        [](const Executable& first, const Executable& second){
            return first.getPriority() < second.getPriority();
        }
    );
    // Very functional
    return ordered + [](const Executable& exe){
        return std::format("{} {} ", exe.getPath().string(), exe.getArguments() + [](const Argument& arg){
            return std::format("{} ", arg.get());
        });
    };
}
