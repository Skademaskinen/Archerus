project(gamingPrefix)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PROJECT_IMPLEMENTATIONS
    src/config.cpp
    src/argument.cpp
    src/executable.cpp
    src/executables_file.cpp
    src/prefix.cpp
    src/postfix.cpp
)

include_directories(include)

include_directories(../../lib/cpplib)

find_package(argparse REQUIRED)
find_package(nlohmann_json REQUIRED)

add_executable(lutris-prefix src/lutris.cpp ${PROJECT_IMPLEMENTATIONS})
add_executable(steam-prefix src/steam.cpp ${PROJECT_IMPLEMENTATIONS})

target_link_libraries(lutris-prefix PRIVATE 
    argparse::argparse 
    nlohmann_json::nlohmann_json
)

target_link_libraries(steam-prefix PRIVATE 
    argparse::argparse 
    nlohmann_json::nlohmann_json
)
