#include "initializer.hpp"
#include "config.hpp"

Initializer::Initializer(Type& type, Config& config) : type(type), config(config), executed(false) {
    utils::log(Level(utils::Debug), "initialized initializer");
}

void Initializer::execute_instructions() {
    executed = true;
    for(const auto& instruction : config.get_instructions()) {
        auto str_instruction = instructions::from_instruction(instruction);
        utils::log(Level(utils::Debug), "Executing instruction: %s", str_instruction.c_str());
        switch(instruction) {
            case instructions::Initialize:
                type.initialize_i();
                break;
            case instructions::Switch:
                type.switch_i();
                break;
        }
    }
}
