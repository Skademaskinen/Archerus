project(nix-launcher)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PROJECT_IMPLEMENTATIONS
    src/config.cpp
    src/launcher.cpp
)

include_directories(include)

find_package(argparse REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Core Widgets Gui)
find_package(libarcherus REQUIRED)

add_executable(nix-launcher src/main.cpp ${PROJECT_IMPLEMENTATIONS})

target_link_libraries(nix-launcher PRIVATE 
    argparse::argparse 
    nlohmann_json::nlohmann_json
    archerus::libarcherus
    Qt6::Core
    Qt6::Widgets
    Qt6::Gui
)

