project(prefix)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PROJECT_IMPLEMENTATIONS
    src/prefix_config.cpp
    src/config.cpp
    src/argument.cpp
    src/executable.cpp
    src/prefix.cpp
    src/postfix.cpp
)

include_directories(include)

find_package(argparse REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(PkgConfig REQUIRED)
find_package(libarcherus REQUIRED)
pkg_check_modules(LIBNOTIFY REQUIRED libnotify)

add_executable(pfx src/main.cpp ${PROJECT_IMPLEMENTATIONS})

target_include_directories(pfx PRIVATE ${LIBNOTIFY_INCLUDE_DIRS})

target_link_libraries(pfx PRIVATE 
    argparse::argparse 
    nlohmann_json::nlohmann_json
    archerus::libarcherus
    ${LIBNOTIFY_LIBRARIES}
)

